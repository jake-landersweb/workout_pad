import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_pad/data/root.dart';
import 'package:workout_pad/extras/root.dart';
import '../../components/root.dart' as cv;

class EditButton extends StatefulWidget {
  const EditButton({
    Key? key,
    this.color = Colors.blue,
    required this.onTap,
  }) : super(key: key);
  final Color color;
  final VoidCallback onTap;

  @override
  State<EditButton> createState() => _EditButtonState();
}

class _EditButtonState extends State<EditButton> {
  @override
  Widget build(BuildContext context) {
    SheetModel sheetModel = Provider.of<SheetModel>(context);
    return cv.BasicButton(
      onTap: () => widget.onTap(),
      child: Text(
        "Edit",
        style: TextStyles.label(
          color: sheetModel.isOpen
              ? CustomColors.textColor(context).withOpacity(0.5)
              : widget.color,
        ),
      ),
    );
  }
}
