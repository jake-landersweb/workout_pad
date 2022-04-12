import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:workout_pad/data/exercise.dart';
import 'package:workout_pad/data/root.dart';
import 'package:workout_pad/extras/root.dart';
import 'package:workout_pad/views/components/number_field.dart';
import 'package:workout_pad/views/exercise/ce/ece_module.dart';
import 'package:workout_pad/views/exercise/ce/root.dart';
import '../../../components/root.dart' as cv;

class ECEExercises extends StatefulWidget {
  const ECEExercises({Key? key}) : super(key: key);

  @override
  State<ECEExercises> createState() => _ECEExercisesState();
}

class _ECEExercisesState extends State<ECEExercises> {
  @override
  Widget build(BuildContext context) {
    ECEModel ecemodel = Provider.of<ECEModel>(context);
    return Column(
      children: [
        cv.Section(
          "Exercise Order Type",
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: cv.SegmentedPicker(
              titles: const ["Normal", "Every Other"],
              selections: const [0, 1],
              initialSelection: ecemodel.exercise.orderType,
              onSelection: (val) {
                setState(() {
                  ecemodel.exercise.orderType = val;
                });
              },
            ),
          ),
        ),
        const SizedBox(height: 16),
        cv.Section(
          "Exercises",
          child: SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                cv.ListView<Exercise>(
                  childPadding: EdgeInsets.zero,
                  allowsDelete: true,
                  showStyling: false,
                  backgroundColor: Colors.transparent,
                  onDelete: (val) {
                    setState(() {
                      ecemodel.exercise.sModules
                          .removeWhere((element) => element.id == val.id);
                    });
                    ecemodel.updateView();
                  },
                  isAnimated: true,
                  children: ecemodel.exercise.sModules,
                  childBuilder: (context, exercise) {
                    return Column(
                      children: [
                        const SizedBox(height: 16),
                        ECEExerciseCell(exercise: exercise),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 16),
                cv.BasicButton(
                  onTap: () {
                    setState(() {
                      ecemodel.exercise.sModules.add(Exercise.nested());
                    });
                    ecemodel.updateView();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: CustomColors.cellColor(context),
                    ),
                    width: MediaQuery.of(context).size.width / 2,
                    height: 40,
                    child: Center(
                      child: Icon(
                        Icons.add,
                        color: CustomColors.textColor(context).withOpacity(0.5),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class ECEExerciseCell extends StatefulWidget {
  const ECEExerciseCell({
    Key? key,
    required this.exercise,
  }) : super(key: key);
  final Exercise exercise;

  @override
  State<ECEExerciseCell> createState() => _ECEExerciseCellState();
}

class _ECEExerciseCellState extends State<ECEExerciseCell> {
  @override
  Widget build(BuildContext context) {
    ECEModel ecemodel = Provider.of<ECEModel>(context);
    return Column(
      children: [
        cv.ListView<Widget>(
          horizontalPadding: 0,
          childPadding: EdgeInsets.zero,
          children: [
            cv.TextField(
              labelText: "Title",
              isLabeled: true,
              value: widget.exercise.title,
              onChanged: (val) {
                setState(() {
                  widget.exercise.title = val;
                });
                ecemodel.updateView();
              },
            ),
          ],
        ),
        cv.Section(
          "Modules",
          child: cv.ListView<Module>(
            childPadding: EdgeInsets.zero,
            allowsDelete: true,
            onDelete: (val) {
              setState(() {
                widget.exercise.modules
                    .removeWhere((element) => element.id == val.id);
              });
              ecemodel.updateView();
            },
            isAnimated: true,
            children: widget.exercise.modules,
            childBuilder: (context, module) {
              return ECEModuleCell(module: module);
            },
          ),
        ),
        const SizedBox(height: 8),
        cv.BasicButton(
          onTap: () {
            setState(() {
              widget.exercise.modules.add(Module.empty());
            });
            ecemodel.updateView();
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: CustomColors.cellColor(context),
            ),
            width: MediaQuery.of(context).size.width / 3,
            height: 40,
            child: Center(
              child: Text(
                "Add Module",
                style: TextStyles.body(
                  color: CustomColors.textColor(context).withOpacity(0.5),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
