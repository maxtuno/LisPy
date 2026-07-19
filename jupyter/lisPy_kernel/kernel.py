"""
LisPy Jupyter Kernel implementation.
Spawns lispy.exe --kernel as a persistent subprocess for stateful evaluation.
"""
import os
import sys
import shutil
import subprocess
import threading

from ipykernel.kernelbase import Kernel

_tools_dir = os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__)))), "tools")
if not os.path.isdir(_tools_dir):
    _lispy_exe = os.environ.get("LISPY_EXE", "")
    if _lispy_exe:
        _tools_dir = os.path.join(os.path.dirname(_lispy_exe), "tools")
sys.path.insert(0, _tools_dir)
from _lp_preprocess import preprocess as _lp_preprocess


def _project_root():
    return os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))


def _find_lispy():
    exe_name = "lispy.exe" if sys.platform == "win32" else "lispy"
    root = _project_root()
    candidates = [
        os.path.join(root, "bin", exe_name),
        os.path.join(root, "dist", exe_name),
        os.path.join(root, exe_name),
    ]
    for path in os.environ.get("PATH", "").split(os.pathsep):
        if path:
            candidates.append(os.path.join(path, exe_name))
    for path in candidates:
        if os.path.isfile(path):
            return os.path.abspath(path)
    return "lispy"


def _find_venv():
    kernel_dir = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    path = os.path.join(kernel_dir, "venv")
    if os.path.isdir(path) and os.path.isfile(os.path.join(path, "pyvenv.cfg")):
        return os.path.abspath(path)
    return None


def _find_pythonhome():
    root = _project_root()
    for d in ["dist", "Python-3.14.5"]:
        path = os.path.join(root, d)
        if os.path.isdir(os.path.join(path, "Lib")):
            return os.path.abspath(path)
    return None


class LisPyKernel(Kernel):
    implementation = "LisPy"
    implementation_version = "1.0.0"
    language = "lp"
    language_version = "1.0"
    language_info = {
        "name": "lp",
        "mimetype": "text/x-lisp",
        "file_extension": ".lp",
        "codemirror_mode": "lispy",
        "pygments_lexer": "common-lisp",
        "version": "1.0",
    }
    banner = "LisPy Kernel \u2014 ANSI Common Lisp with Python FFI"
    _read_timeout = 30.0

    def __init__(self, **kwargs):
        super().__init__(**kwargs)
        self._proc = None
        self._stderr_thread = None
        self._stderr_buffer = []
        self._stderr_lock = threading.Lock()
        self._startup_loaded = False

    def _start_lispy(self):
        if self._proc is not None:
            try:
                self._proc.stdin.close()
                self._proc.terminate()
                try:
                    self._proc.wait(timeout=3)
                except subprocess.TimeoutExpired:
                    self._proc.kill()
                    self._proc.wait()
            except OSError:
                pass
            self._proc = None

        lispy_path = _find_lispy()
        if not lispy_path or lispy_path == "lispy":
            if not shutil.which("lispy"):
                raise RuntimeError(
                    "LisPy executable not found. "
                    "Build lispy first or set LISPY_EXE environment variable."
                )
            lispy_path = "lispy"

        args = [lispy_path, "--kernel"]

        venv_path = _find_venv()
        if venv_path:
            args.extend(["--venv", venv_path])

        env = os.environ.copy()
        python_home = _find_pythonhome()
        if python_home:
            env["PYTHONHOME"] = python_home

        self._proc = subprocess.Popen(
            args,
            stdin=subprocess.PIPE,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            bufsize=0,
            cwd=_project_root(),
            env=env,
        )

        self._stderr_thread = threading.Thread(target=self._read_stderr, daemon=True)
        self._stderr_thread.start()
        self._startup_loaded = False

        self._send_init_code()

    def _read_stderr(self):
        try:
            while self._proc and self._proc.stderr:
                line = self._proc.stderr.readline()
                if not line:
                    break
                decoded = line.decode("utf-8", errors="replace")
                with self._stderr_lock:
                    self._stderr_buffer.append(decoded)
        except (ValueError, OSError):
            pass

    def _drain_stderr(self):
        with self._stderr_lock:
            lines = self._stderr_buffer
            self._stderr_buffer = []
            return "".join(lines)

    def _send_init_code(self):
        try:
            lib_dir = os.path.join(_project_root(), "lib")
            lib_files = [
                "ffi.lp",
                "continuations.lp",
                "defpyfun.lp",
                "defpyclass.lp",
                "python-template.lp",
                "persist.lp",
            ]
            load_forms = " ".join(
                f'(load "{os.path.join(lib_dir, f).replace(os.sep, "/")}")'
                for f in lib_files
                if os.path.isfile(os.path.join(lib_dir, f))
            )
            init_forms = f"(progn (in-package :cl-user) {load_forms}) "
            self._send_code(init_forms)
            self._read_output()
            self._drain_stderr()
            self._startup_loaded = True
        except (BrokenPipeError, OSError, RuntimeError):
            self._startup_loaded = False

    def _send_code(self, code):
        encoded = code.encode("utf-8")
        header = f"{len(encoded)}\n".encode("ascii")
        try:
            self._proc.stdin.write(header)
            self._proc.stdin.write(encoded)
            self._proc.stdin.flush()
        except (BrokenPipeError, OSError) as e:
            raise BrokenPipeError(f"Lost connection to LisPy process: {e}")

    def _read_output(self):
        output_chunks = []
        deadline = None
        if self._read_timeout:
            import time
            deadline = time.monotonic() + self._read_timeout
        while True:
            if deadline and time.monotonic() > deadline:
                break
            if self._proc.stdout.closed:
                break
            line = self._proc.stdout.readline()
            if not line:
                break
            decoded = line.decode("utf-8", errors="replace")
            if decoded.rstrip("\r\n") == "__LISPY_DONE__":
                return "".join(output_chunks)
            output_chunks.append(decoded)
        proc = self._proc
        if proc is not None and proc.poll() is not None:
            stderr_tail = self._drain_stderr()
            raise RuntimeError(
                f"LisPy process exited with code {proc.returncode}.\n{stderr_tail}"
            )
        return "".join(output_chunks)

    def _shutdown_proc(self):
        if self._proc:
            try:
                self._proc.stdin.close()
            except OSError:
                pass
            try:
                self._proc.terminate()
                try:
                    self._proc.wait(timeout=3)
                except subprocess.TimeoutExpired:
                    self._proc.kill()
                    self._proc.wait()
            except OSError:
                pass
            self._proc = None

    def do_execute(
        self, code, silent, store_history=True, user_expressions=None, allow_stdin=False
    ):
        if self._proc is None or self._proc.poll() is not None:
            try:
                self._start_lispy()
            except RuntimeError as e:
                error_content = {
                    "ename": "KernelStartupError",
                    "evalue": str(e),
                    "traceback": [],
                }
                self.send_response(self.iopub_socket, "error", error_content)
                return {
                    "status": "error",
                    "execution_count": self.execution_count,
                    "payload": [],
                    "user_expressions": {},
                }

        code_stripped = code.strip()
        if not code_stripped:
            return {
                "status": "ok",
                "execution_count": self.execution_count,
                "payload": [],
                "user_expressions": {},
            }

        processed = _lp_preprocess(code_stripped)
        if not processed or not processed.strip():
            return {
                "status": "ok",
                "execution_count": self.execution_count,
                "payload": [],
                "user_expressions": {},
            }

        try:
            self._send_code(processed)
            stdout_text = self._read_output()
            stderr_text = self._drain_stderr()

            if not silent and stdout_text:
                stream_content = {"name": "stdout", "text": stdout_text}
                self.send_response(self.iopub_socket, "stream", stream_content)

            if stderr_text:
                stream_content = {"name": "stderr", "text": stderr_text}
                self.send_response(self.iopub_socket, "stream", stream_content)

        except (BrokenPipeError, OSError, RuntimeError) as e:
            self._shutdown_proc()
            error_content = {
                "ename": "KernelError",
                "evalue": str(e),
                "traceback": [],
            }
            self.send_response(self.iopub_socket, "error", error_content)
            return {
                "status": "error",
                "execution_count": self.execution_count,
                "payload": [],
                "user_expressions": {},
            }

        return {
            "status": "ok",
            "execution_count": self.execution_count,
            "payload": [],
            "user_expressions": {},
        }

    def do_shutdown(self, restart):
        self._shutdown_proc()
        return {"status": "ok", "restart": restart}

    def comm_open(self, stream, ident, msg):
        pass

    def comm_msg(self, stream, ident, msg):
        pass
