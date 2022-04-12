import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sprung/sprung.dart';
import 'package:workout_pad/data/root.dart';
import 'package:workout_pad/extras/root.dart';
import 'package:workout_pad/views/root.dart';
import '../../components/root.dart' as cv;

class ExerciseList extends StatefulWidget {
  const ExerciseList({
    Key? key,
    this.scrollOffset,
  }) : super(key: key);
  final double? scrollOffset;

  @override
  State<ExerciseList> createState() => _ExerciseListState();
}

class _ExerciseListState extends State<ExerciseList> {
  String _searchText = "";
  List<String> _selectedCategories = [];

  @override
  Widget build(BuildContext context) {
    DataModel dmodel = Provider.of<DataModel>(context);
    return Column(
      children: [
        SizedBox(height: _scrollMultiplier()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: cv.ListView<Widget>(
            horizontalPadding: 0,
            childPadding: EdgeInsets.zero,
            children: [
              cv.TextField(
                labelText: "Search ...",
                onChanged: (v) {
                  setState(() {
                    _searchText = v;
                  });
                },
                validator: (v) => null,
              ),
            ],
          ),
        ),
        if (dmodel.categories.isNotEmpty)
          Column(
            children: [
              SizedBox(height: 16 + _scrollMultiplier()),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      for (var i in dmodel.categories)
                        _categoryCell(context, dmodel, i),
                    ],
                  ),
                ),
              ),
            ],
          ),
        SizedBox(height: 16 + _scrollMultiplier()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 8 + _scrollMultiplier(),
            crossAxisSpacing: 8,
            childAspectRatio: 3,
            crossAxisCount: 2,
            children: [
              for (var i in items(context, dmodel)) ExerciseCell(item: i),
            ],
          ),
        ),
      ],
    );
  }

  Widget _categoryCell(BuildContext context, DataModel dmodel, String title) {
    return Padding(
      padding: EdgeInsets.only(right: title == dmodel.categories.last ? 0 : 8),
      child: GestureDetector(
        onTap: () {
          if (_selectedCategories.contains(title)) {
            setState(() {
              _selectedCategories.removeWhere((element) => element == title);
            });
          } else {
            setState(() {
              _selectedCategories.add(title);
            });
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          curve: Sprung(36),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: _selectedCategories.contains(title)
                ? Colors.blue
                : CustomColors.cellColor(context),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Text(
              title,
              style: TextStyles.label(
                color: _selectedCategories.contains(title)
                    ? Colors.white
                    : CustomColors.textColor(context),
              ),
            ),
          ),
        ),
      ),
    );
  }

  double _scrollMultiplier() {
    if (widget.scrollOffset == null) {
      return 0;
    } else {
      if (widget.scrollOffset! < 0) {
        return (-(widget.scrollOffset!) * 0.05);
      } else {
        return 0;
      }
    }
  }

  List<IndexItem> items(BuildContext context, DataModel dmodel) {
    if (_searchText.isNotEmpty) {
      if (_selectedCategories.isEmpty) {
        return dmodel.index
            .where((element) =>
                element.title.toLowerCase().contains(_searchText.toLowerCase()))
            .toList();
      } else {
        return dmodel.index
            .where((element) =>
                element.title.toLowerCase().contains(_searchText.toLowerCase()))
            .toList()
            .where((element) => _selectedCategories
                .any((item) => element.categories.contains(item)))
            .toList();
      }
    } else {
      if (_selectedCategories.isEmpty) {
        return dmodel.index;
      } else {
        return dmodel.index
            .where((element) => _selectedCategories
                .any((item) => element.categories.contains(item)))
            .toList();
      }
    }
  }
}
