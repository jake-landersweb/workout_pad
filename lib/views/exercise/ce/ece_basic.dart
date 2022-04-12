import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:workout_pad/data/exercise.dart';
import 'package:workout_pad/data/root.dart';
import 'package:workout_pad/extras/root.dart';
import 'package:workout_pad/views/exercise/ce/root.dart';
import '../../../components/root.dart' as cv;

class ECEBasic extends StatefulWidget {
  const ECEBasic({
    Key? key,
    required this.onPageChange,
  }) : super(key: key);
  final Function(int) onPageChange;

  @override
  State<ECEBasic> createState() => _ECEBasicState();
}

class _ECEBasicState extends State<ECEBasic> {
  late TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ECEModel ecemodel = Provider.of<ECEModel>(context);
    return Column(
      children: [
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: cv.SegmentedPicker(
            initialSelection:
                ecemodel.exercise.type == ExerciseType.set ? 1 : 2,
            titles: const ["Set", "Super Set"],
            selections: const [1, 2],
            onSelection: (val) {
              setState(() {
                if (val == 1) {
                  ecemodel.exercise.type = ExerciseType.set;
                } else {
                  ecemodel.exercise.type = ExerciseType.superSet;
                }
                widget.onPageChange(val - 1);
              });
              ecemodel.updateView();
            },
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: cv.ListView<Widget>(
            horizontalPadding: 0,
            childPadding: EdgeInsets.zero,
            children: [
              cv.TextField(
                value: ecemodel.exercise.title,
                labelText: "Title",
                isLabeled: true,
                onChanged: (val) {
                  setState(() {
                    ecemodel.exercise.title = val;
                  });
                  ecemodel.updateView();
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: cv.ListView<Widget>(
            horizontalPadding: 0,
            childPadding: const EdgeInsets.only(left: 16),
            children: [
              Row(
                children: [
                  Expanded(
                    child: cv.TextField(
                      controller: _controller,
                      showBackground: false,
                      onChanged: (val) {
                        setState(() {});
                      },
                      labelText: "New Category",
                    ),
                  ),
                  cv.BasicButton(
                    onTap: () {
                      if (_controller.text.isNotEmpty &&
                          !ecemodel.categories.contains(_controller.text)) {
                        setState(() {
                          ecemodel.categories.add(_controller.text);
                          _controller.clear();
                        });
                      }
                    },
                    child: Column(
                      children: [
                        SizedBox(
                          width: 50,
                          child: Icon(
                            Icons.add,
                            color: (_controller.text.isEmpty ||
                                    ecemodel.categories
                                        .contains(_controller.text))
                                ? CustomColors.textColor(context)
                                    .withOpacity(0.5)
                                : CustomColors.textColor(context),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (var i in ecemodel.categories)
                _categoryCell(context, ecemodel, i),
            ],
          ),
        ),
      ],
    );
  }

  Widget _categoryCell(BuildContext context, ECEModel ecemodel, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: cv.BasicButton(
        onTap: () {
          if (ecemodel.exercise.categories.contains(title)) {
            setState(() {
              ecemodel.exercise.categories
                  .removeWhere((element) => element == title);
            });
          } else {
            setState(() {
              ecemodel.exercise.categories.add(title);
            });
          }
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: ecemodel.exercise.categories.contains(title)
                ? Colors.blue
                : CustomColors.cellColor(context),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Text(
              title,
              style: TextStyles.label(
                color: ecemodel.exercise.categories.contains(title)
                    ? Colors.white
                    : CustomColors.textColor(context),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
