"""Run import, runtime tests and a scene smoke test; fail even if Godot logs errors with exit 0."""
from __future__ import annotations

import argparse
import subprocess
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--godot", default="godot", help="Path to the Godot 4.5.1 standard executable")
    args = parser.parse_args()
    commands = [
        ["--headless", "--path", str(ROOT), "--editor", "--import"],
        ["--headless", "--path", str(ROOT), "--script", "res://tests/test_world_state.gd"],
        ["--headless", "--path", str(ROOT), "--quit-after", "30"],
    ]
    for command in commands:
        try:
            result = subprocess.run([args.godot, *command], capture_output=True, text=True, timeout=90)
        except (OSError, subprocess.TimeoutExpired) as exc:
            print(f"Godot validation could not run: {exc}")
            return 1
        output = result.stdout + result.stderr
        print(output, end="")
        if result.returncode or "SCRIPT ERROR:" in output or "ERROR:" in output:
            print(f"Godot validation failed: {' '.join(command)}")
            return 1
    print("Godot import, runtime regressions and scene smoke: PASS")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
