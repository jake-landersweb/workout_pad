import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_pad/data/root.dart';
import 'package:workout_pad/extras/root.dart';
import 'package:workout_pad/views/root.dart';
import '../../components/root.dart' as cv;

class ExerciseCell extends StatefulWidget {
  const ExerciseCell({
    Key? key,
    required this.item,
  }) : super(key: key);
  final IndexItem item;

  @override
  State<ExerciseCell> createState() => _ExerciseCellState();
}

class _ExerciseCellState extends State<ExerciseCell> {
  @override
  Widget build(BuildContext context) {
    DataModel dmodel = Provider.of<DataModel>(context);
    return cv.BasicButton(
      onTap: () {
        _navigate(context, dmodel);
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: CustomColors.cellColor(context),
        ),
        child: Center(
          child: Text(
            widget.item.title,
            style: TextStyles.label(
              color: CustomColors.textColor(context),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _navigate(BuildContext context, DataModel dmodel) async {
    // read the file
    dmodel.exercise = await dmodel.readExercise(widget.item.id);
    if (dmodel.exercise != null) {
      cv.Navigate(context, const ExerciseDetail());
    } else {
      // TODO -- add to indicator stack
    }
  }
}
