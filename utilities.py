from datetime import date
from datetime import timedelta
from dateutil.parser import parse

# Returns all working days (skips saturdays, sundays and fixed Belgian public holidays)
def workdays(input_start_date, input_end_date):
    start_date = parse(input_start_date)
    end_date = parse(input_end_date)
    days = []
    current_date = start_date
    while current_date <= end_date:
        if current_date.weekday() < 5 and isNotPublicHoliday(current_date):
            days.append(current_date)
        current_date += timedelta(days=1)
    return days

def isNotPublicHoliday(date):
    publicholidays = ['01-01', '05-01', '07-21', '08-15', '11-01', '11-11', '12-25']
    return not any(date.strftime('%m-%d') in x for x in publicHolidays)

# For testing purposes
def main():
    test_end_date date.today()
    test_begin_date test_end_date timedelta(days 10)
    print(workdays(test_begin_date.strftime("%B %d, %Y")
    test_end_date.strftime("%B %d, ")))

# __name__
if name="__main__":
    main()
