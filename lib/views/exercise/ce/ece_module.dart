import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:workout_pad/data/exercise.dart';
import 'package:workout_pad/data/root.dart';
import 'package:workout_pad/extras/root.dart';
import 'package:workout_pad/views/components/number_field.dart';
import 'package:workout_pad/views/exercise/ce/root.dart';
import '../../../components/root.dart' as cv;

class ECEModule extends StatefulWidget {
  const ECEModule({Key? key}) : super(key: key);

  @override
  State<ECEModule> createState() => _ECEModuleState();
}

class _ECEModuleState extends State<ECEModule> {
  @override
  Widget build(BuildContext context) {
    ECEModel ecemodel = Provider.of<ECEModel>(context);
    return cv.Section(
      "Modules",
      child: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            cv.ListView<Module>(
              childPadding: EdgeInsets.zero,
              allowsDelete: true,
              onDelete: (val) {
                setState(() {
                  ecemodel.exercise.modules
                      .removeWhere((element) => element.id == val.id);
                });
                ecemodel.updateView();
              },
              isAnimated: true,
              children: ecemodel.exercise.modules,
              childBuilder: (context, module) {
                return ECEModuleCell(module: module);
              },
            ),
            const SizedBox(height: 16),
            cv.BasicButton(
              onTap: () {
                setState(() {
                  ecemodel.exercise.modules.add(Module.empty());
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
    );
  }
}

class ECEModuleCell extends StatefulWidget {
  const ECEModuleCell({
    Key? key,
    required this.module,
  }) : super(key: key);
  final Module module;

  @override
  State<ECEModuleCell> createState() => _ECEModuleCellState();
}

class _ECEModuleCellState extends State<ECEModuleCell> {
  @override
  Widget build(BuildContext context) {
    ECEModel ecemodel = Provider.of<ECEModel>(context);
    return Column(
      children: [
        cv.TextField(
          labelText: "Reps",
          isLabeled: true,
          value:
              widget.module.reps.isEmpty ? "0" : widget.module.reps.toString(),
          formatters: [FilteringTextInputFormatter.digitsOnly],
          onChanged: (val) {
            setState(() {
              widget.module.reps = int.tryParse(val) ?? 0;
            });
            ecemodel.updateView();
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              Expanded(
                child: NumberField(
                  label: "Weight",
                  value: widget.module.weight ?? 0,
                  onChanged: (val) {
                    setState(() {
                      widget.module.weight = val;
                    });
                    ecemodel.updateView();
                  },
                ),
              ),
              cv.BasicButton(
                onTap: () {
                  setState(() {
                    if (widget.module.weightType == WeightType.lbs) {
                      widget.module.weightType = WeightType.kg;
                    } else {
                      widget.module.weightType = WeightType.lbs;
                    }
                  });
                  ecemodel.updateView();
                },
                child: Text(
                  widget.module.weightType == WeightType.lbs ? "lbs" : "kg",
                  style: TextStyles.label(color: Colors.blue, underline: true),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              Expanded(
                child: NumberField(
                  label: "Time",
                  value: widget.module.time ?? 0,
                  onChanged: (val) {
                    setState(() {
                      widget.module.time = val;
                    });
                    ecemodel.updateView();
                  },
                ),
              ),
              cv.BasicButton(
                onTap: () {
                  setState(() {
                    if (widget.module.timeType == TimeType.sec) {
                      widget.module.timeType = TimeType.min;
                    } else {
                      widget.module.timeType = TimeType.sec;
                    }
                  });
                  ecemodel.updateView();
                },
                child: Text(
                  widget.module.timeType == TimeType.sec ? "sec" : "min",
                  style: TextStyles.label(color: Colors.blue, underline: true),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: NumberField(
            label: "Repeats",
            isLabeled: true,
            value: widget.module.repeats,
            onChanged: (val) {
              setState(() {
                widget.module.repeats = val;
              });
              ecemodel.updateView();
            },
          ),
        ),
      ],
    );
  }
}
