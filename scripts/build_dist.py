#!/usr/bin/env python3
"""Create a clean, dependency-free GitHub Pages site in dist/."""

from __future__ import annotations

import shutil
import subprocess
import sys
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
DIST = ROOT / "dist"


def run(*args: str) -> None:
    subprocess.run(args, cwd=ROOT, check=True)


def main() -> None:
    if DIST.exists():
        shutil.rmtree(DIST)
    DIST.mkdir()

    run(sys.executable, "build_whole_timetable.py", "--output", str(DIST / "index.html"))
    run(sys.executable, "bundle_whole_visualizer.py", "--output", str(DIST / "whole_soundcloud_standalone.html"))

    qr_code = ROOT / "whole-festival-timetable-qr.png"
    if not qr_code.exists():
        raise SystemExit("whole-festival-timetable-qr.png is missing. Run scripts/generate_qr.swift before building.")
    shutil.copy2(qr_code, DIST / qr_code.name)

    favicon = ROOT / "favicon.ico"
    if not favicon.exists():
        raise SystemExit("favicon.ico is missing. Fetch the official WHOLE favicon before building.")
    shutil.copy2(favicon, DIST / "favicon.ico")
    (DIST / ".nojekyll").touch()
    print(f"GitHub Pages build ready: {DIST}")


if __name__ == "__main__":
    main()
