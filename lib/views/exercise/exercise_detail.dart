import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_pad/data/exercise.dart';
import 'package:workout_pad/data/root.dart';
import 'package:workout_pad/data/sheet_model.dart';
import 'package:workout_pad/extras/root.dart';
import 'package:workout_pad/views/components/root.dart';
import 'package:workout_pad/views/root.dart';
import '../../components/root.dart' as cv;
import 'package:provider/provider.dart';

class ExerciseDetail extends StatefulWidget {
  const ExerciseDetail({
    Key? key,
  }) : super(key: key);

  @override
  State<ExerciseDetail> createState() => _ExerciseDetailState();
}

class _ExerciseDetailState extends State<ExerciseDetail> {
  double _scrollOffset = 0;

  @override
  void initState() {
    if (context.read<DataModel>().exercise == null) {
      throw "Need to initialize dmodel.exercise before landing on this page";
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DataModel dmodel = Provider.of<DataModel>(context);
    return cv.SheetWrapper(
      child: cv.AppBar(
        title: "",
        isLarge: false,
        childPadding: const EdgeInsets.fromLTRB(0, 16, 0, 48),
        scrollOffset: (val) {
          if (val < 0) {
            setState(() {
              _scrollOffset = (-(val) * 0.05);
            });
          } else {
            setState(() {
              _scrollOffset = 0;
            });
          }
        },
        trailing: [
          EditButton(onTap: () {
            cv.showSheet(
              context,
              ECERoot(
                categories: dmodel.categories,
                exercise: dmodel.exercise!,
              ),
            );
          })
        ],
        leading: [
          BButton(
            onTap: () {
              Navigator.of(context).pop();
            },
          )
        ],
        children: [_body(context, dmodel)],
      ),
    );
  }

  Widget _body(BuildContext context, DataModel dmodel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Text(dmodel.exercise!.title, style: TextStyles.title()),
        ),
        SizedBox(height: 16 + _scrollOffset),
        SizedBox(
          height: 50,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: _infoCell(
                      context,
                      dmodel,
                      dmodel.exercise!.type == ExerciseType.set
                          ? "Set"
                          : "Super Set",
                    ),
                  ),
                  for (var i in dmodel.exercise!.categories)
                    Padding(
                      padding: EdgeInsets.only(
                          right: i == dmodel.exercise!.categories.last ? 0 : 8),
                      child: _infoCell(context, dmodel, i),
                    ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 16 + _scrollOffset),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: dmodel.exercise!.type == ExerciseType.set
              ? _set(context, dmodel.exercise!)
              : _superSet(context, dmodel.exercise!),
        ),
      ],
    );
  }

  Widget _infoCell(BuildContext context, DataModel dmodel, String category) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: CustomColors.cellColor(context),
      ),
      height: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Center(child: Text(category, style: TextStyles.label())),
      ),
    );
  }

  Widget _set(BuildContext context, Exercise exercise) {
    return _modules(context, exercise.modules);
  }

  Widget _superSet(BuildContext context, Exercise exercise) {
    return Column(
      children: [
        if (exercise.type == ExerciseType.superSet && exercise.orderType == 1)
          _everyOtherModules(context, exercise)
        else
          for (var i in exercise.sModules)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(i.title, style: TextStyles.label()),
                SizedBox(height: 8 + _scrollOffset),
                _modules(context, i.modules),
                SizedBox(height: 16 + _scrollOffset),
              ],
            ),
      ],
    );
  }

  Widget _everyOtherModules(BuildContext context, Exercise exercise) {
    return cv.ListView<Widget>(
      horizontalPadding: 0,
      children: [
        for (var i in _composeEveryOtherModules(context, exercise)) i,
      ],
    );
  }

  Widget _modules(BuildContext context, List<Module> modules) {
    return cv.ListView<Widget>(
      horizontalPadding: 0,
      children: [
        for (var i in _composeModules(context, modules)) i.title(context)
      ],
    );
  }

  List<Module> _composeModules(BuildContext context, List<Module> modules) {
    List<Module> m = [];

    for (var module in modules) {
      for (var i = 0; i < module.repeats; i++) {
        m.add(module.clone());
      }
    }

    return m;
  }

  List<Widget> _composeEveryOtherModules(
      BuildContext context, Exercise exercise) {
    List<Widget> c = [];

    // make list of list to account for any repeats that may have been added to modules
    List<List<Module>> extendedModules = [];
    for (var e in exercise.sModules) {
      List<Module> list = [];
      for (var module in e.modules) {
        for (var i = 0; i < module.repeats; i++) {
          list.add(module.clone());
        }
      }
      extendedModules.add(list);
    }

    final int largest = extendedModules.map((e) => e.length).toList().max;

    int index = 0;

    while (index < largest) {
      for (var i = 0; i < extendedModules.length; i++) {
        if (extendedModules[i].length > index) {
          c.add(
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(exercise.sModules[i].title.toUpperCase(),
                    style: TextStyles.section(context)),
                extendedModules[i][index].title(context)
              ],
            ),
          );
        }
      }
      ++index;
    }

    return c;
  }
}
