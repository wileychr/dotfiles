#!/usr/bin/env python3

from __future__ import annotations

import argparse
import datetime
import pathlib
import sys
import typing


class _Args(typing.NamedTuple):
    weeks_ago: list[int]
    snippets_dir: pathlib.Path


class _SnippetsInfo(typing.NamedTuple):
    path: pathlib.Path
    monday_date: datetime.date


_DAY_OFFSETS = [
    (0, "Monday"),
    (1, "Tuesday"),
    (2, "Wednesday"),
    (3, "Thursday"),
    (4, "Friday"),
]

_DAY_TEMPLATE = """


{name_of_day} - {date}
--------------------------------------------------------------------------------
"""


def parse_args(args: list[str]) -> _Args:
    parser = argparse.ArgumentParser(
        description="Get the date of the most recent snippets file."
    )
    parser.add_argument("--snippets_dir", type=str, required=True)
    parser.add_argument(
        "--weeks_ago",
        type=int,
        nargs="*",
        default=tuple([0]),
        help="any number of weeks ago to open snippets for (e.g. --weeks_ago 0 1)",
    )
    parsed_args = parser.parse_args()
    return _Args(
        weeks_ago=list(parsed_args.weeks_ago),
        snippets_dir=pathlib.Path(parsed_args.snippets_dir),
    )


def create_snippets_template(monday_date: datetime.date, f) -> None:
    for num_days_offset, day in _DAY_OFFSETS:
        date = monday_date + datetime.timedelta(days=num_days_offset)
        f.write(_DAY_TEMPLATE.format(name_of_day=day, date=date.isoformat()))


def get_snippets_info(args: _Args) -> list[_SnippetsInfo]:
    def _get_monday_date(weeks_ago: int) -> datetime.date:
        today = datetime.date.today() - datetime.timedelta(weeks=weeks_ago)
        # Monday is 0, go back to the most recent Monday
        return today - datetime.timedelta(days=today.weekday())

    def _get_path(monday_date: datetime.date) -> pathlib.Path:
        snippets_file_name = monday_date.isoformat() + ".md"
        return args.snippets_dir / snippets_file_name

    result = []
    for weeks_ago in args.weeks_ago:
        monday_date = _get_monday_date(weeks_ago)
        result.append(
            _SnippetsInfo(path=_get_path(monday_date), monday_date=monday_date),
        )
    return result


def main():
    args = parse_args(sys.argv[1:])

    all_snippets = get_snippets_info(args)
    for snippets in all_snippets:
        if not snippets.path.exists():
            with open(snippets.path, "w") as f:
                create_snippets_template(snippets.monday_date, f)

    selected_paths = [s.path for s in all_snippets] + [args.snippets_dir / "notes.md"]
    print("  ".join([str(p) for p in selected_paths]))


if __name__ == "__main__":
    main()
