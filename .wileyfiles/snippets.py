#!/usr/bin/env python3

import datetime
import argparse

def main():
    parser = argparse.ArgumentParser(
            description='Get the date of the most recent snippets file.')
    parser.add_argument(
            'weeks_ago', type=int, default=0, nargs='?',
            help='number of weeks ago to open snippets for')
    args = parser.parse_args()

    today = datetime.date.today() - datetime.timedelta(weeks=args.weeks_ago)
    # Monday is 0, go back to the most recent Monday
    snippets_date = today - datetime.timedelta(days=today.weekday())
    print(snippets_date.isoformat())

if __name__ == '__main__':
    main()
