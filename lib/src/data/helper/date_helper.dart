class DateHelper {
  List<int> months = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
  List<int> monthsLeap = [31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];

  bool isLeapYear(year) {
    if ((year % 400 == 0) || (year % 100 != 0) && (year % 4 == 0)) {
      return true;
    }
    return false;
  }

  int daysInMonth(year, month) {
    print(isLeapYear(year));
    if (isLeapYear(year)) {
      return monthsLeap[month - 1];
    } else {
      return months[month - 1];
    }
  }

  String nextDay(year, month, day) {
    int numberOfDays = daysInMonth(year, month);
    print('${year}-${month}-${day + 1}');
    if (day < numberOfDays) {
      return '$year-$month-${day + 1}';
    } else {
      if (month == 12) {
        return '${year + 1}-${1}-${1}';
      } else {
        return '$year-${month + 1}-${day + 1}';
      }
    }
  }

  String nextTomorrow(date) {
    List<String> newDate = date.split("-");
    int year = int.parse(newDate[0]);
    int month = int.parse(newDate[1]);
    int day = int.parse(newDate[2]);
    return nextDay(year, month, day);
  }

  
}
