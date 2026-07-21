#!/usr/bin/env python3
"""LisPy test runner. Runs all .lp test files and reports pass/fail/error."""

import subprocess
import sys
import os
from pathlib import Path
from collections import defaultdict

ROOT = Path(__file__).resolve().parent.parent
HERE = Path(__file__).resolve().parent
IS_WIN = sys.platform == "win32"
LISPY_EXE = ROOT / "bin" / ("lispy.exe" if IS_WIN else "lispy")
TEST_DIRS = [
    "test/cl",
    "test/lispy-test",
    "test/qa",
]
VENV_DIR = ROOT / "venv"
if not VENV_DIR.exists():
    VENV_DIR = ROOT / "venv-linux"
TIMEOUT_SEC = 60

SKIP_TESTS = {}
if IS_WIN:
    SKIP_TESTS["test/lispy-test/ffi_linux.lp"] = "Linux-only (libm.so.6), skip on Windows"
else:
    SKIP_TESTS["test/lispy-test/ffi_win.lp"] = "Windows-only (kernel32.dll), skip on Linux"


def setup_output_dirs():
    """Create output directories that tests expect."""
    (HERE / "advanced").mkdir(exist_ok=True)


def is_python_test(filepath: Path) -> bool:
    """Check if the test file uses Python bridge."""
    try:
        text = filepath.read_text(encoding="utf-8", errors="ignore")
        return any(kw in text for kw in ("py:import", "py:run", "py:call", "py:attr"))
    except Exception:
        return False


def run_one_test(lispy_exe: Path, venv_dir: Path, test_file: Path,
                 needs_python: bool, skip_reason: str = None) -> dict:
    """Run a single .lp test file."""
    rel = str(test_file.relative_to(ROOT))
    result = {
        "file": rel, "passed": False, "error": False,
        "timeout": False, "skipped": False,
        "stdout": "", "stderr": "", "exit_code": -1, "skip_reason": "",
    }

    if skip_reason:
        result["skipped"] = True
        result["skip_reason"] = skip_reason
        return result

    cmd = [str(lispy_exe)]
    if needs_python and venv_dir.exists():
        cmd.extend(["--venv", str(venv_dir)])
    cmd.append("--batch")

    try:
        stdin_data = test_file.read_text(encoding="utf-8", errors="ignore")
        stdin_bytes = stdin_data.encode("utf-8")
    except Exception as e:
        result["error"] = True
        result["stderr"] = str(e)
        return result

    env = os.environ.copy()
    env["PYTHONIOENCODING"] = "utf-8"
    env["PYTHONHOME"] = ""
    env["PYTHONPATH"] = ""

    try:
        proc = subprocess.run(
            cmd, input=stdin_bytes, capture_output=True,
            timeout=TIMEOUT_SEC, cwd=str(ROOT), env=env,
        )
        result["stdout"] = proc.stdout.decode("utf-8", errors="replace")
        result["stderr"] = proc.stderr.decode("utf-8", errors="replace")
        result["exit_code"] = proc.returncode
        result["passed"] = (proc.returncode == 0)
        if not result["passed"]:
            result["error"] = True
    except subprocess.TimeoutExpired:
        result["timeout"] = True
        result["error"] = True
        result["stderr"] = f"TIMEOUT after {TIMEOUT_SEC}s"
    except Exception as e:
        result["error"] = True
        result["stderr"] = str(e)

    return result


def main():
    if not LISPY_EXE.exists():
        print(f"ERROR: lispy.exe not found at {LISPY_EXE}")
        sys.exit(1)

    setup_output_dirs()

    print(f"LisPy Test Runner")
    print(f"  exe:     {LISPY_EXE}")
    print(f"  venv:    {VENV_DIR} (exists={VENV_DIR.exists()})")
    print(f"  timeout: {TIMEOUT_SEC}s")
    print()

    all_tests = []
    for td in TEST_DIRS:
        d = ROOT / td
        if not d.exists():
            print(f"  SKIP: directory {td} not found")
            continue
        for f in sorted(d.glob("*.lp")):
            rel = str(f.relative_to(ROOT)).replace("\\", "/")
            skip = SKIP_TESTS.get(rel)
            all_tests.append((f, skip))

    print(f"Running {len(all_tests)} tests...\n")

    results = []
    n = len(all_tests)
    for i, (f, skip_reason) in enumerate(all_tests):
        needs_py = is_python_test(f)
        r = run_one_test(LISPY_EXE, VENV_DIR, f, needs_py, skip_reason)
        results.append(r)

        if r["skipped"]:
            status = "SKIP"
        elif r["passed"]:
            status = "PASS"
        elif r["timeout"]:
            status = "TIMEOUT"
        else:
            status = "FAIL"

        marker = ""
        if needs_py and not r["skipped"]:
            marker = " [py]"
        if r["skipped"]:
            marker = f" [{r['skip_reason'][:50]}]"

        print(f"[{i+1:3d}/{n}] {status:7s} {r['file']}{marker}")

    passed  = [r for r in results if r["passed"]]
    skipped = [r for r in results if r["skipped"]]
    failed  = [r for r in results if r["error"] and not r["timeout"] and not r["skipped"]]
    timeouts= [r for r in results if r["timeout"]]

    print(f"\n{'='*68}")
    print(f"RESULTS: {len(passed)} passed, {len(failed)} failed, "
          f"{len(timeouts)} timeout, {len(skipped)} skipped")
    print(f"{'='*68}")

    if skipped:
        print(f"\n--- SKIPPED ({len(skipped)}) ---")
        for r in skipped:
            print(f"  {r['file']}  ({r['skip_reason']})")

    if failed:
        print(f"\n--- FAILED ({len(failed)}) ---")
        for r in failed:
            stderr = r["stderr"].strip()
            lines = stderr.split("\n") if stderr else []
            print(f"\n  {r['file']}  (exit={r['exit_code']})")
            for line in lines[:6]:
                print(f"    stderr: {line}")
            if r["stdout"].strip():
                print(f"    stdout: {r['stdout'].strip()[:200]}")

    if timeouts:
        print(f"\n--- TIMEOUTS ({len(timeouts)}) ---")
        for r in timeouts:
            print(f"  {r['file']}")

    n_ok = len(passed) + len(skipped)
    return 0 if len(failed) == 0 and len(timeouts) == 0 else 1


if __name__ == "__main__":
    sys.exit(main())
