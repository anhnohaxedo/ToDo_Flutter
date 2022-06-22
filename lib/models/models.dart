class Date {
  DateTime now = DateTime.now();
  Map<int, String> thisMonth = {
    1: "Jan",
    2: "Feb",
    3: "Mar",
    4: "Apr",
    5: "May",
    6: "Jun",
    7: "Jul",
    8: "Aug",
    9: "Sep",
    10: "Oct",
    11: "Nov",
    12: "Dec",
  };
  Map<int, String> thisWeekDay = {
    1: "Monday",
    2: "Tuesday",
    3: "Wednesday",
    4: "Thursday",
    5: "Friday",
    6: "Sartuday",
    7: "Sunday",
  };
  String? getMonth() {
    return thisMonth[now.month];
  }

  String getWeek() {
    return thisWeekDay[now.weekday] ??= "Can't detect weekday";
  }
}
