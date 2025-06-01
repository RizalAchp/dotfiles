#!/usr/bin/env python3


import os
import sys
import subprocess as sp
from typing import Iterator


MON0 = "LVDS1"
MON0_ARGS = "--primary --mode 1366x768 --pos 0x0 --rotate normal"

MON1 = "VGA1"
MON1_ARGS = "--mode 1366x768 --pos -1366x0 --rotate normal"


def run_xrandr(
    mon0: bool,
    mon1: bool,
):
    args = ["xrandr"]
    args.extend(("--output", MON0))
    args.extend(["--off"] if not mon0 else MON0_ARGS.split(" "))

    args.extend(("--output", MON1))
    args.extend(["--off"] if not mon1 else MON1_ARGS.split(" "))
    return sp.call(args, env=os.environ)


def help(program: str):
    print(f"USAGE: {program} <MODE>")
    print()
    print("MODE:")
    print("     first, f, 0")
    print("     second, s, 1")
    print("     double, d, 2")


def main(argv: Iterator[str]):
    program = next(argv)
    arg = next(argv, None)
    if arg is None:
        help(program)
        return 1

    match arg:
        case "-h" | "--help" | "help":
            help(program)
            return 0
        case "first" | "f" | "0":
            print("Running monitor on first monitor")
            return run_xrandr(True, False)
        case "second" | "s" | "1":
            print("Running monitor on second monitor")
            return run_xrandr(False, True)
        case "both" | "b" | "2":
            print("Running monitor on both monitor")
            return run_xrandr(True, True)
        case other:
            print(f"unknown argument: {other}")
            return 1


if __name__ == "__main__":
    exit(main(sys.argv.__iter__()))
