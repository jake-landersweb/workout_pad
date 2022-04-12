import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:workout_pad/data/root.dart';
import 'package:workout_pad/views/components/add_button.dart';
import 'package:workout_pad/views/root.dart';
import '../components/root.dart' as cv;

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  double _scrollOffset = 0;

  @override
  Widget build(BuildContext context) {
    DataModel dmodel = Provider.of<DataModel>(context);
    return cv.AppBar(
      title: "Exercises",
      isLarge: true,
      childPadding: const EdgeInsets.fromLTRB(0, 16, 0, 48),
      itemBarPadding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      scrollOffset: (val) {
        setState(() {
          _scrollOffset = val;
        });
      },
      trailing: [
        AddButton(onTap: () {
          cv.showSheet(context, ECERoot(categories: dmodel.categories),
              expand: true);
        })
      ],
      children: [
        ExerciseList(
          scrollOffset: _scrollOffset,
        ),
      ],
    );
  }
}
