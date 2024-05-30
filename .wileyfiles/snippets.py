#!/usr/bin/env python3

import argparse
import datetime
import pathlib
import typing


class _Args(typing.NamedTuple):
    weeks_ago: int
    snippets_dir: pathlib.Path

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



def parse_args() -> _Args:
    parser = argparse.ArgumentParser(
            description='Get the date of the most recent snippets file.')
    parser.add_argument(
            '--weeks_ago', type=int, default=0, nargs='?',
            help='number of weeks ago to open snippets for')
    parser.add_argument('--snippets_dir', type=str, required=True)
    args = parser.parse_args()
    return _Args(
        weeks_ago=args.weeks_ago,
        snippets_dir=pathlib.Path(args.snippets_dir),
    )


def create_snippets_template(monday_date: datetime.date, f) -> None:
    for num_days_offset, day in _DAY_OFFSETS:
        date = monday_date + datetime.timedelta(days=num_days_offset)
        f.write(_DAY_TEMPLATE.format(name_of_day=day, date=date.isoformat()))

def main():
    args = parse_args()

    today = datetime.date.today() - datetime.timedelta(weeks=args.weeks_ago)
    # Monday is 0, go back to the most recent Monday
    snippets_date = today - datetime.timedelta(days=today.weekday())
    snippets_file_name = snippets_date.isoformat() + '.md'
    snippets_path = args.snippets_dir / snippets_file_name

    if args.weeks_ago == 0 and not snippets_path.exists():
        args.snippets_dir.mkdir(parents=True, exist_ok=True)
        with open(snippets_path, "w") as f:
            create_snippets_template(snippets_date, f)
    print(snippets_path)

if __name__ == '__main__':
    main()
