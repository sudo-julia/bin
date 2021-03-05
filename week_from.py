#!/usr/bin/env python3
import datetime
from sys import argv


def get_new_date(date: str):
    """get the date 7 days from the date given
    date must be formatted as 'YYYY-MM-DD'
    """
    last_day = datetime.date.fromisoformat(date)
    next_day = last_day + datetime.timedelta(weeks=1)
    print(next_day)


if __name__ == "__main__":
    try:
        get_new_date(argv[1])
    except IndexError:
        print("No argument given. Please provide a date (ISO 8601)")
    except ValueError:
        print(f"'{argv[1]}' is not a valid argument. Please provide a date in ISO 8601")
