import 'package:flutter/material.dart';
import 'package:workout_pad/data/exercise.dart';
import 'package:workout_pad/data/root.dart';

class ECEModel extends ChangeNotifier {
  late Exercise exercise;
  late bool isCreate;

  late List<String> categories;

  ECEModel(List<String> categories, {Exercise? exercise}) {
    if (exercise == null) {
      this.exercise = Exercise.empty();
      isCreate = true;
    } else {
      this.exercise = exercise.clone();
      isCreate = false;
    }
    this.categories = List.of(categories);
  }

  void updateView() {
    notifyListeners();
  }

  String buttonTitle() {
    if (exercise.title.isEmpty) {
      return "Title is Empty";
    }

    if (exercise.type == ExerciseType.set) {
      // set
      if (exercise.modules.any((element) =>
          element.reps == 0 && element.weight == 0 && element.time == 0)) {
        return "Reps, Weight, or Time is Empty";
      }
    } else {
      // super set
      if (exercise.sModules.any((element) => element.title.isEmpty)) {
        return "Module Titles are Empty";
      }
      if (exercise.sModules.any((element) => element.modules.any((element) =>
          element.reps == 0 && element.weight == 0 && element.time == 0))) {
        return "Reps, Weight, or Time is Empty";
      }
    }

    return isCreate ? "Create" : "Confirm";
  }
}
