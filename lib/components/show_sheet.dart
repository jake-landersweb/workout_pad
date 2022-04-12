import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:sprung/sprung.dart';
import 'package:workout_pad/data/root.dart';
import 'package:provider/provider.dart';
import 'package:workout_pad/extras/root.dart';

Future<void> showSheet(BuildContext context, Widget child,
    {bool? dismissable, bool? expand}) async {
  Provider.of<SheetModel>(context, listen: false).openSheet();
  showCustomModalBottomSheet(
    context: context,
    isDismissible: dismissable ?? true,
    builder: (context) {
      return child;
    },
    animationCurve: Sprung(36),
    duration: const Duration(milliseconds: 500),
    containerWidget: (_, animation, child) => SheetContainer(
      child: child,
      expand: expand,
    ),
    expand: false,
  );
}

class SheetContainer extends StatefulWidget {
  const SheetContainer({
    Key? key,
    required this.child,
    this.expand,
  }) : super(key: key);
  final Widget child;
  final bool? expand;

  @override
  State<SheetContainer> createState() => _SheetContainerState();
}

class _SheetContainerState extends State<SheetContainer> {
  late SheetModel _sheetModel;
  @override
  void didChangeDependencies() {
    _sheetModel = Provider.of<SheetModel>(context, listen: false);
    super.didChangeDependencies();
  }

  @override
  void deactivate() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _sheetModel.closeSheet();
    });
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        height: widget.expand ?? true
            ? MediaQuery.of(context).size.height * 0.92
            : null,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            child: widget.child,
            color: CustomColors.backgroundColor(context),
          ),
        ),
      ),
    );
  }
}
