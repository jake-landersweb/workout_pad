import 'package:uuid/uuid.dart';

import 'root.dart';

class Exercise {
  late String id;
  late String title;
  late bool isNested;
  late ExerciseType type;
  late List<Module> modules;
  late List<Exercise> sModules;
  late EpochDate created;
  EpochDate? updated;
  late List<ExerciseLog> logs;
  late List<String> categories;
  late int orderType;

  Exercise({
    required this.id,
    required this.title,
    required this.isNested,
    required this.type,
    required this.modules,
    required this.sModules,
    required this.created,
    this.updated,
    required this.logs,
    required this.categories,
    required this.orderType,
  });

  Exercise clone() => Exercise(
        id: id,
        title: title,
        isNested: isNested,
        type: type,
        modules: [for (var i in modules) i.clone()],
        sModules: [for (var i in sModules) i.clone()],
        created: created,
        updated: updated,
        logs: [for (var i in logs) i.clone()],
        categories: categories,
        orderType: orderType,
      );

  Exercise.empty() {
    id = const Uuid().v4();
    title = "";
    isNested = false;
    type = ExerciseType.set;
    modules = [];
    sModules = [];
    created = EpochDate();
    logs = [];
    categories = [];
    orderType = 0;
  }

  Exercise.nested() {
    id = const Uuid().v4();
    title = "";
    isNested = true;
    type = ExerciseType.set;
    modules = [];
    sModules = [];
    created = EpochDate();
    logs = [];
    categories = [];
    orderType = 0;
  }

  Exercise.fromJson(dynamic json) {
    id = json['id'];
    title = json['title'];
    isNested = json['isNested'];
    type = json['type'] == 1 ? ExerciseType.set : ExerciseType.superSet;
    modules = [];
    if (json['modules'] != null) {
      for (var i in json['modules']) {
        modules.add(Module.fromJson(i));
      }
    }
    sModules = [];
    if (json['sModules'] != null) {
      for (var i in json['sModules']) {
        sModules.add(Exercise.fromJson(i));
      }
    }
    created = EpochDate.fromJson(json['created']);
    if (json['updated'] != null) {
      updated = EpochDate.fromJson(json['updated']);
    }
    logs = [];
    if (json['logs'] != null) {
      for (var i in json['logs']) {
        logs.add(ExerciseLog.fromJson(i));
      }
    }
    categories = [for (var i in json['categories']) i];
    orderType = json['orderType'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "isNested": isNested,
      "type": type == ExerciseType.set ? 1 : 2,
      "modules": modules.map((e) => e.toJson()).toList(),
      "sModules": sModules.map((e) => e.toJson()).toList(),
      "created": created.date,
      "updated": updated?.date,
      "logs": logs.map((e) => e.toJson()).toList(),
      "categories": categories,
      "orderType": orderType,
    };
  }

  String filename() {
    return "$id.json";
  }
}

enum ExerciseType { set, superSet }
