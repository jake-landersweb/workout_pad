import 'root.dart';

class LogIndexItem {
  late EpochDate date;
  late List<LogIndexItemItem> data;

  LogIndexItem({
    required this.date,
    required this.data,
  });

  LogIndexItem.fromJson(dynamic json) {
    date = EpochDate.fromJson(json['date']);
    for (var i in json['data']) {
      data.add(LogIndexItemItem.fromJson(i));
    }
  }

  Map<String, dynamic> toJson() {
    return {
      "date": date.date,
      "data": data.map((e) => e.toJson()).toList(),
    };
  }
}

class LogIndexItemItem {
  late String exerciseId;
  late String logId;

  LogIndexItemItem({
    required this.exerciseId,
    required this.logId,
  });

  LogIndexItemItem.fromJson(dynamic json) {
    exerciseId = json['exerciseId'];
    logId = json['logId'];
  }

  Map<String, String> toJson() {
    return {
      "exerciseId": exerciseId,
      "logId": logId,
    };
  }
}
