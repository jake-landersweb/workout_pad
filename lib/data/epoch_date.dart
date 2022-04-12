class EpochDate {
  late int date;

  EpochDate() {
    date = DateTime.now().millisecondsSinceEpoch;
  }

  EpochDate.fromDate(DateTime date) {
    this.date = date.millisecondsSinceEpoch;
  }

  EpochDate.fromEpoch({required this.date});

  EpochDate clone() => EpochDate.fromEpoch(date: date);

  EpochDate.fromJson(dynamic json) {
    date = json;
  }

  int day() {
    DateTime d = DateTime.fromMillisecondsSinceEpoch(date);
    return d.day;
  }

  int month() {
    DateTime d = DateTime.fromMillisecondsSinceEpoch(date);
    return d.month;
  }

  int year() {
    DateTime d = DateTime.fromMillisecondsSinceEpoch(date);
    return d.year;
  }

  String monthName() {
    return months[month()]!;
  }

  String pretty() {
    return "${day()}, ${monthName().substring(0, 2)} ${year().toString().substring(2)}";
  }

  String basic() {
    return "${month()}-${day()}-${year()}";
  }
}

Map<int, String> months = {
  1: "january",
  2: "february",
  3: "march",
  4: "april",
  5: "may",
  6: "june",
  7: "july",
  8: "august",
  9: "september",
  10: "october",
  11: "november",
  12: "december",
};
