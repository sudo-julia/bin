"""get the date a week from the date given"""
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
    get_new_date(argv[1])
