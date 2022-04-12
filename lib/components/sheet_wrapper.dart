import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sprung/sprung.dart';
import 'package:workout_pad/data/sheet_model.dart';

class SheetWrapper extends StatefulWidget {
  const SheetWrapper({
    Key? key,
    required this.child,
  }) : super(key: key);
  final Widget child;

  @override
  State<SheetWrapper> createState() => _SheetWrapperState();
}

class _SheetWrapperState extends State<SheetWrapper> {
  @override
  Widget build(BuildContext context) {
    SheetModel sheetModel = Provider.of<SheetModel>(context);
    return SafeArea(
        top: false,
        right: false,
        left: false,
        bottom: false,
        child: Container(
          color: Colors.black,
          child: AnimatedScale(
            scale: sheetModel.isOpen ? 0.9 : 1,
            duration: const Duration(milliseconds: 500),
            curve: Sprung(36),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(sheetModel.isOpen ? 10 : 0),
              child: widget.child,
            ),
          ),
        ));
  }
}
