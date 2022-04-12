import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sprung/sprung.dart';
import 'package:workout_pad/data/exercise.dart';
import 'package:workout_pad/data/root.dart';
import 'package:workout_pad/views/exercise/ce/ece_exercises.dart';
import 'package:workout_pad/views/exercise/ce/ece_module.dart';
import 'package:workout_pad/views/exercise/ce/root.dart';
import '../../../components/root.dart' as cv;

class ECERoot extends StatefulWidget {
  const ECERoot({
    Key? key,
    required this.categories,
    this.exercise,
  }) : super(key: key);
  final List<String> categories;
  final Exercise? exercise;

  @override
  State<ECERoot> createState() => _ECERootState();
}

class _ECERootState extends State<ECERoot> {
  late PageController _controller;

  @override
  void initState() {
    _controller = PageController();
    if (widget.exercise != null) {
      _controller = PageController(
          initialPage: widget.exercise!.type == ExerciseType.set ? 0 : 1);
    } else {
      _controller = PageController();
    }
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) =>
          ECEModel(widget.categories, exercise: widget.exercise),
      builder: (context, child) {
        return _body(context);
      },
    );
  }

  Widget _body(BuildContext context) {
    ECEModel ecemodel = Provider.of<ECEModel>(context);
    DataModel dmodel = Provider.of<DataModel>(context);
    return cv.Sheet(
      title: ecemodel.isCreate ? "Create Exercise" : "Update Exercise",
      child: ListView(
        shrinkWrap: false,
        children: [
          Column(
            children: [
              ECEBasic(
                onPageChange: (val) {
                  _controller.animateToPage(
                    val,
                    duration: const Duration(milliseconds: 500),
                    curve: Sprung(36),
                  );
                },
              ),
              cv.SizingPageView(
                controller: _controller,
                physics: const NeverScrollableScrollPhysics(),
                children: const [
                  ECEModule(),
                  ECEExercises(),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(32.0),
                child: cv.RoundedLabel(
                  ecemodel.buttonTitle(),
                  color: ecemodel.buttonTitle() ==
                          (ecemodel.isCreate ? "Create" : "Confirm")
                      ? Colors.blue
                      : Colors.red.withOpacity(0.5),
                  textColor: Colors.white,
                  onTap: () {
                    if (ecemodel.buttonTitle() ==
                        (ecemodel.isCreate ? "Create" : "Confirm")) {
                      _action(context, dmodel, ecemodel);
                    }
                  },
                ),
              ),
              const SizedBox(height: 100),
            ],
          )
        ],
      ),
    );
  }

  Future<void> _action(
      BuildContext context, DataModel dmodel, ECEModel ecemodel) async {
    if (ecemodel.isCreate) {
      final response = await dmodel.createExercise(ecemodel.exercise);
      if (response) {
        Navigator.of(context).pop();
      }
    } else {
      // remove excess data
      if (ecemodel.exercise.type == ExerciseType.set) {
        ecemodel.exercise.sModules = [];
      } else {
        ecemodel.exercise.modules = [];
      }
      final response =
          await dmodel.updateExercise(ecemodel.exercise, read: true);
      if (response) {
        Navigator.of(context).pop();
      }
    }
  }
}
