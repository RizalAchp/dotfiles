#!/usr/bin/env python3

from argparse import ArgumentParser, Namespace
from pathlib import Path
import logging
import subprocess
import shutil


def create_program():
    program = ArgumentParser(
        prog="scriptvideo",
        description="script for collection of ffmpeg commands",
    )
    program.add_argument(
        "-v", "--verbose", action="count", default=0, help="set verbosity level"
    )
    program.add_argument("input", help="input video file", type=Path)
    program.add_argument(
        "-o",
        "--output",
        help="output video file",
        required=False,
        type=Path,
    )

    sub = program.add_subparsers(title="actions", required=True, dest="actions")
    speed = sub.add_parser(
        "speed",
        help="set speed of video",
        aliases=["s"],
        add_help=True,
        exit_on_error=True,
    )
    speed.add_argument(
        "-s",
        "--speed",
        help="output video file",
        required=False,
        default=1.5,
        type=float,
    )

    normalize = sub.add_parser(
        "normalize",
        aliases=["n"],
        help="set video vollume and bitrate to normalize default",
    )
    normalize.add_argument(
        "-v",
        "--volume",
        help="volume for video file",
        required=False,
        default=1.5,
        type=float,
    )
    normalize.add_argument(
        "-b",
        "--bitrate",
        help="bitrate for video file",
        required=False,
        default=192,
        type=int,
    )

    lauder = sub.add_parser("lauder", aliases=["l"], help="set video volume lauder")
    lauder.add_argument(
        "-v",
        "--volume",
        help="volume for video file",
        required=False,
        default=1.5,
        type=float,
    )

    all = sub.add_parser("all", aliases=["a"], help="set all action for video")
    all.add_argument(
        "-v",
        "--volume",
        help="volume for video file",
        required=False,
        default=1.5,
        type=float,
    )
    all.add_argument(
        "-b",
        "--bitrate",
        help="bitrate for video file",
        required=False,
        default=192,
        type=int,
    )
    all.add_argument(
        "-s",
        "--speed",
        help="output video file",
        required=False,
        default=1.5,
        type=float,
    )

    extract = sub.add_parser("extract", aliases=["e"], help="extract frames for video")
    extract.add_argument(
        "-e",
        "--extension",
        help="image extension for determine output frame types",
        required=False,
        default="png",
        type=str,
    )

    return program.parse_args()


def ffmpeg_run(args: list[str] | str):
    commands = [
        shutil.which("ffmpeg"),
        "-hide_banner",
        "-v",
        "quiet",
        "-stats",
        "-loglevel",
        "error",
    ]
    if isinstance(args, list):
        commands.extend(args)
    else:
        commands.extend(args.split(" "))

    logging.info(f"Running commands: '{' '.join(commands)}'")

    with subprocess.Popen(commands) as sp:
        return sp.wait()


def output_path(input: Path, output: Path | None) -> Path:
    return output if output is not None else Path(f"output_{input.name}")


def action_speed(args: Namespace):
    input: Path = args.input
    output: Path = output_path(input, args.output)
    logging.info(f"Running action `speed` [{input=}, {output=}]")
    return ffmpeg_run(
        f"-i {input} -vf setpts=(PTS-STARTPTS)/{args.speed} -af atempo={args.speed} {output}"
    )


def action_normalize(args: Namespace) -> int:
    input: Path = args.input
    output: Path = output_path(input, args.output)
    logging.info(f"Running action `normalize` [{input=}, {output=}]")
    return ffmpeg_run(
        f"-i {input} -af volume={args.volume} -c:v copy -c:a aac -b:a {args.bitrate}k {output}"
    )


def action_lauder(args: Namespace) -> int:
    input: Path = args.input
    output: Path = output_path(input, args.output)
    logging.info(f"Running action `lauder` [{input=}, {output=}]")
    return ffmpeg_run(
        f"-i {input} -vcodec copy -filter:a volume={args.volume} {output}"
    )


def action_all(args: Namespace) -> int:
    input: Path = args.input
    output: Path = output_path(input, args.output)
    logging.info(f"Running action `all` [{input=}, {output=}]")
    return ffmpeg_run(
        f"-i {input} -vf setpts=(PTS-STARTPTS)/{args.speed} -af atempo={args.speed},volume={args.volume} -c:a aac -b:a {args.bitrate}k {output}"
    )


def action_extract(args: Namespace) -> int:
    input: Path = args.input
    output: Path = (
        args.output if args.output is not None else Path(f"frames_{input.stem}/")
    )
    logging.info(f"Running action `extract` [{input=}, {output=}]")

    output.mkdir(exist_ok=True)
    logging.info(f"creating directory: {output}")

    return ffmpeg_run(f"-i {input} {output}/%08d.{args.extension}")


def verbosity_to_log_level(verbosity: int) -> int:
    if verbosity >= 2:
        return logging.DEBUG
    elif verbosity >= 1:
        return logging.INFO
    else:
        return logging.WARNING


if __name__ == "__main__":
    program = create_program()
    logging.basicConfig(level=verbosity_to_log_level(program.verbose))
    exit_code = 0
    match program.actions:
        case "speed":
            exit_code = action_speed(program)
        case "normalize":
            exit_code = action_normalize(program)
        case "lauder":
            exit_code = action_lauder(program)
        case "all":
            exit_code = action_all(program)
        case "extract":
            exit_code = action_extract(program)

    exit(exit_code)
