import 'package:flutter/material.dart';

class SheetModel extends ChangeNotifier {
  bool isOpen = false;

  void openSheet() {
    isOpen = true;
    notifyListeners();
  }

  void closeSheet() {
    isOpen = false;
    notifyListeners();
  }
}
