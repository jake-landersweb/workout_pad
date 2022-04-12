import 'package:flutter/material.dart';
import 'package:workout_pad/extras/root.dart';

import 'root.dart' as cv;

class Sheet extends StatefulWidget {
  const Sheet({
    Key? key,
    required this.title,
    required this.child,
    this.headerHeight = 50,
    this.color = Colors.blue,
    this.closeText = "Cancel",
    this.padding = const EdgeInsets.all(8),
  }) : super(key: key);

  final String title;
  final Widget child;
  final double headerHeight;
  final Color color;
  final String closeText;
  final EdgeInsets padding;

  @override
  _SheetState createState() => _SheetState();
}

class _SheetState extends State<Sheet> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        Column(
          children: [
            cv.GlassContainer(
              width: double.infinity,
              borderRadius: BorderRadius.circular(0),
              backgroundColor: CustomColors.backgroundColor(context),
              opacity: 0.4,
              blur: 12,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.title,
                        style: TextStyle(
                          color: CustomColors.textColor(context),
                          fontSize: 26,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    cv.BasicButton(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color:
                              CustomColors.textColor(context).withOpacity(0.1),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Icon(
                            Icons.close,
                            color: CustomColors.textColor(context)
                                .withOpacity(0.7),
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Divider(
                height: 0.5,
                indent: 0,
                color: CustomColors.textColor(context).withOpacity(0.1))
          ],
        ),
      ],
    );
  }
}
