import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'root.dart';

class DataModel extends ChangeNotifier {
  List<IndexItem> index = [];
  List<String> categories = [];
  Exercise? exercise;

  List<LogIndexItem>? logs;
  ExerciseLog? exerciseLog;

  // control the scale for the overarching view
  bool sheetOpen = false;

  DataModel() {
    init();
  }

  Future<void> init() async {
    // open the index file
    index = await readIndex();
    // final file = await _localFile("index");
    // await file.delete();
    notifyListeners();
  }

  Future<void> writeIndex(List<IndexItem> items) async {
    final file = await _localFile("index");
    String body = jsonEncode(items.map((e) => e.toJson()).toList());
    file.writeAsString(body);
    log("successfully wrote to index file");
    // re-read index file
    index = await readIndex();
  }

  Future<List<IndexItem>> readIndex() async {
    try {
      final file = await _localFile("index");

      // read as string
      final contents = await file.readAsString();

      // decode string into json
      dynamic json = jsonDecode(contents);

      // convert list into index items
      List<IndexItem> items = [];
      categories = [];
      for (var i in json) {
        final item = IndexItem.fromJson(i);
        items.add(item);
        categories.addAll([for (var i in item.categories) i]);
      }
      categories = categories.toSet().toList();

      log("successfully read the index file");
      return items;
    } catch (error) {
      log(error.toString());
      log("the log file does not exist, writing to new file");
      // the index file does not exist
      List<IndexItem> items = [];
      writeIndex(items);
      return items;
    }
  }

  Future<bool> writeExercise(Exercise e) async {
    try {
      final file = await _localFile(e.id);
      String body = jsonEncode(e.toJson());
      file.writeAsString(body);
      log("successfully wrote to exercise file");
      return true;
    } catch (error) {
      log(error.toString());
      return false;
    }
  }

  Future<Exercise> readExercise(String id) async {
    final file = await _localFile(id);
    final contents = await file.readAsString();
    dynamic json = jsonDecode(contents);
    Exercise temp = Exercise.fromJson(json);
    log("successfully read exercise file");
    return temp;
  }

  Future<bool> createExercise(Exercise e) async {
    try {
      final writeResponse = await writeExercise(e);
      if (writeResponse) {
        // create new entry in the index file
        index.insert(
            0,
            IndexItem(
              title: e.title,
              id: e.id,
              categories: e.categories,
            ));
        await writeIndex(index);
        notifyListeners();
        return true;
      } else {
        notifyListeners();
        return false;
      }
    } catch (error) {
      log(error.toString());
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateExercise(Exercise e, {bool read = false}) async {
    try {
      final writeResponse = await writeExercise(e);
      if (writeResponse) {
        // update entry in the index file
        // get the index
        final idx = index.indexWhere((element) => element.id == e.id);
        // remove the value
        index.removeWhere((element) => element.id == e.id);
        // add new value at index
        index.insert(
            idx, IndexItem(title: e.title, id: e.id, categories: e.categories));
        await writeIndex(index);
        if (read) {
          exercise = await readExercise(e.id);
        }
        notifyListeners();
        return true;
      } else {
        notifyListeners();
        return false;
      }
    } catch (error) {
      log(error.toString());
      notifyListeners();
      return false;
    }
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> _localFile(String id) async {
    final path = await _localPath;
    return File('$path/$id.json');
  }

  void openSheet() {
    sheetOpen = true;
    notifyListeners();
  }

  void closeSheet() {
    sheetOpen = false;
    notifyListeners();
  }
}
