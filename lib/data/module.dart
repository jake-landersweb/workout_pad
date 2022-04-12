import 'package:flutter/material.dart';

import 'epoch_date.dart';
import 'package:uuid/uuid.dart';
import '../extras/root.dart';

class Module {
  late String id;
  int? reps;
  int? weight;
  int? time;
  String? percent;
  late WeightType weightType;
  late TimeType timeType;
  late EpochDate created;
  EpochDate? updated;
  late int repeats;

  Module({
    required this.id,
    this.reps,
    this.weight,
    this.time,
    this.percent,
    required this.weightType,
    required this.timeType,
    required this.created,
    this.updated,
    required this.repeats,
  });

  Module.empty() {
    id = const Uuid().v4();
    reps = 0;
    weight = 0;
    time = 0;
    percent = "";
    weightType = WeightType.lbs;
    timeType = TimeType.sec;
    created = EpochDate();
    repeats = 1;
  }

  Module clone() => Module(
        id: id,
        reps: reps,
        weight: weight,
        time: time,
        percent: percent,
        weightType: weightType,
        timeType: timeType,
        created: created,
        updated: updated,
        repeats: repeats,
      );

  Module.fromJson(dynamic json) {
    id = json['id'];
    reps = json['reps'];
    weight = json['weight'];
    time = json['time'];
    percent = json['percent'];
    weightType = json['weightType'] == "lbs" ? WeightType.lbs : WeightType.kg;
    timeType = json['timeType'] == "sec" ? TimeType.sec : TimeType.min;
    created = EpochDate.fromJson(json['created']);
    if (json['updated'] != null) {
      updated = EpochDate.fromJson(json['updated']);
    }
    repeats = json['repeats'] ?? 1;
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "reps": reps == 0 ? null : reps,
      "weight": weight == 0 ? null : weight,
      "time": time == 0 ? null : time,
      "percent": percent.isEmpty ? null : percent,
      "weightType": weightType == WeightType.lbs ? "lbs" : "kg",
      "timeType": timeType == TimeType.sec ? "sec" : "min",
      "created": created.date,
      "updated": updated?.date,
      "repeats": repeats,
    };
  }

  Widget title(BuildContext context) {
    List<Widget> vals = [];

    if (reps.isNotEmpty) {
      if (weight.isNotEmpty) {
        // reps and weight
        vals.add(Row(
          children: [
            Text("$reps ", style: TextStyles.label()),
            Text("reps @", style: TextStyles.smallLabel(context)),
            Text(" $weight ", style: TextStyles.label()),
            Text(weightType == WeightType.lbs ? "lbs" : "kg",
                style: TextStyles.label()),
          ],
        ));
      } else {
        // only reps
        vals.add(Row(
          children: [
            Text("$reps ", style: TextStyles.label()),
            Text("reps", style: TextStyles.smallLabel(context)),
          ],
        ));
      }
    } else {
      if (weight.isNotEmpty) {
        // weight
        vals.add(Row(
          children: [
            Text("$weight ", style: TextStyles.label()),
            Text(weightType == WeightType.lbs ? "lbs" : "kg",
                style: TextStyles.body()),
          ],
        ));
      }
    }

    // add time if applicable
    if (time.isNotEmpty) {
      vals.add(Row(
        children: [
          if (vals.isNotEmpty) Text(" ", style: TextStyles.label()),
          Text("for", style: TextStyles.smallLabel(context)),
          Text(" $time ", style: TextStyles.label()),
          Text(timeType == TimeType.sec ? "sec" : "min",
              style: TextStyles.label()),
        ],
      ));
    }
    return Row(children: [for (var i in vals) i]);
  }
}

enum WeightType { lbs, kg }

enum TimeType { sec, min }
