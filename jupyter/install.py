"""
Install the LisPy Jupyter kernel.

Usage:
    python install.py
    python install.py --user
    python install.py --sys-prefix
"""
import os
import sys
import json
import shutil
import subprocess
import tempfile


def project_root():
    return os.path.dirname(os.path.dirname(os.path.abspath(__file__)))


def find_lispy():
    exe_name = "lispy.exe" if sys.platform == "win32" else "lispy"
    root = project_root()
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
    return None


def find_venv():
    script_dir = os.path.dirname(os.path.abspath(__file__))
    path = os.path.join(script_dir, "venv")
    if os.path.isdir(path) and os.path.isfile(os.path.join(path, "pyvenv.cfg")):
        return os.path.abspath(path)
    return None


def _install_codemirror_config(script_dir):
    """Install JupyterLab / Notebook 7+ CodeMirror settings for LisPy syntax highlighting."""
    cm_src = os.path.join(script_dir, "lisPy_kernel", "lispy-codemirror.js")
    if not os.path.isfile(cm_src):
        return

    lab_settings_dir = os.path.join(
        os.path.expanduser("~"), ".jupyter", "lab", "user-settings",
        "@jupyterlab", "codemirror-extension"
    )
    os.makedirs(lab_settings_dir, exist_ok=True)

    settings_path = os.path.join(lab_settings_dir, "plugin.jupyterlab-settings")

    existing = {}
    if os.path.isfile(settings_path):
        try:
            with open(settings_path, 'r') as f:
                existing = json.load(f)
        except json.JSONDecodeError:
            pass

    custom_config = existing.get("customCodeMirrorConfig", {})
    custom_config["lispy"] = {
        "displayName": "LisPy",
        "mime": "text/x-lisp",
        "ext": ["lp"],
        "loader": "/kernelspecs/lisPy/lispy-codemirror.js",
    }
    existing["customCodeMirrorConfig"] = custom_config

    with open(settings_path, 'w') as f:
        json.dump(existing, f, indent=2)

    print(f"  CodeMirror lispy mode configured in: {settings_path}")


def install_kernel(user=True):
    script_dir = os.path.dirname(os.path.abspath(__file__))
    root = project_root()

    lispy_path = find_lispy()
    if lispy_path:
        print(f"Found LisPy: {lispy_path}")
    else:
        print("WARNING: lispy.exe not found. Kernel will search PATH at runtime.")

    venv_path = find_venv()
    if venv_path:
        print(f"Using venv: {venv_path}")
    else:
        print("WARNING: No venv found in script directory.")

    kernel_json = {
        "argv": [sys.executable, "-m", "lisPy_kernel", "-f", "{connection_file}"],
        "display_name": "LisPy (Common Lisp + Python)",
        "language": "lp",
        "interrupt_mode": "signal",
        "env": {
            "PYTHONPATH": script_dir,
            "LISPY_HOME": root,
        },
    }

    if lispy_path:
        kernel_json["env"]["LISPY_EXE"] = os.path.dirname(lispy_path)

    with tempfile.TemporaryDirectory() as tmpdir:
        spec_dir = os.path.join(tmpdir, "lisPy")
        os.makedirs(spec_dir, exist_ok=True)

        with open(os.path.join(spec_dir, "kernel.json"), "w") as f:
            json.dump(kernel_json, f, indent=2)

        logo_src = os.path.join(root, "icon.png")
        if os.path.isfile(logo_src):
            shutil.copy(logo_src, os.path.join(spec_dir, "logo-64x64.png"))

        codemirror_src = os.path.join(script_dir, "lisPy_kernel", "lispy-codemirror.js")
        if os.path.isfile(codemirror_src):
            shutil.copy(codemirror_src, os.path.join(spec_dir, "lispy-codemirror.js"))

        cmd = [
            sys.executable, "-m", "jupyter", "kernelspec",
            "install", spec_dir,
            "--name", "lisPy",
            "--replace",
        ]
        if user:
            cmd.append("--user")

        print(f"Running: {' '.join(cmd)}")
        result = subprocess.run(cmd, capture_output=True, text=True)

        if result.returncode == 0:
            print()
            print("LisPy kernel installed successfully.")
            print(f"  Display name: LisPy (Common Lisp + Python)")
            print(f"  Language:     .lp (Lisp + Python FFI)")
            print(f"  Syntax:       custom LisPy CodeMirror mode")

            _install_codemirror_config(script_dir)
            print()
            print("  IMPORTANT: Restart JupyterLab / Notebook 7+ for the")
            print("  CodeMirror syntax highlighting to take effect.")
        else:
            print(f"Error: {result.stderr}")
            sys.exit(1)

    print()
    print("Usage:")
    print("  jupyter notebook LisPy-Demo.ipynb")
    print("  jupyter lab")
    print("  Then select: New > LisPy (Common Lisp + Python)")


if __name__ == "__main__":
    user = "--sys-prefix" not in sys.argv
    install_kernel(user=user)
