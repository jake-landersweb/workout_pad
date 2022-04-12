import 'package:uuid/uuid.dart';

import 'root.dart';

class ExerciseLog {
  late String id;
  late EpochDate date;
  late Exercise snapshot;

  ExerciseLog({
    required this.id,
    required this.date,
    required this.snapshot,
  });

  ExerciseLog clone() =>
      ExerciseLog(id: id, date: date, snapshot: snapshot.clone());

  ExerciseLog.empty(Exercise exercise) {
    id = const Uuid().v4();
    date = EpochDate();
    snapshot = exercise;
  }

  ExerciseLog.fromJson(dynamic json) {
    id = json['id'];
    date = EpochDate.fromJson(json['date']);
    snapshot = Exercise.fromJson(json['snapshot']);
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "date": date.date,
      "snapshot": snapshot.toJson(),
    };
  }
}
