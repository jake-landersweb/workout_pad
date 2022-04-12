import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../components/root.dart' as cv;

class NumberField extends StatefulWidget {
  const NumberField({
    Key? key,
    required this.label,
    required this.value,
    this.isLabeled = false,
    required this.onChanged,
    this.incrament = 1,
    this.clickerIsFirst = true,
    this.color = Colors.blue,
  }) : super(key: key);
  final String label;
  final int value;
  final bool isLabeled;
  final void Function(int) onChanged;
  final int incrament;
  final bool clickerIsFirst;
  final Color color;

  @override
  State<NumberField> createState() => _NumberFieldState();
}

class _NumberFieldState extends State<NumberField> {
  late TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController(text: widget.value.toString());
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (widget.clickerIsFirst) _picker(context),
        Expanded(
          child: cv.TextField(
            labelText: widget.label,
            controller: _controller,
            isLabeled: widget.isLabeled,
            formatters: [FilteringTextInputFormatter.digitsOnly],
            onChanged: (val) {
              widget.onChanged(int.tryParse(val) ?? 0);
            },
          ),
        ),
        if (!widget.clickerIsFirst) _picker(context),
      ],
    );
  }

  Widget _picker(BuildContext context) {
    return cv.NumberPicker(
      cornerRadius: 5,
      minValue: -1000,
      maxValue: 1000,
      plusBackgroundColor: widget.color,
      initialValue: int.tryParse(_controller.text) ?? 0,
      onPlusClick: (val) {
        var v = int.tryParse(_controller.text) ?? 0;
        v += 1;
        setState(() {
          _controller.text = v.toString();
        });
        widget.onChanged(v);
      },
      onMinusClick: (val) {
        var v = int.tryParse(_controller.text) ?? 0;
        if (v > 0) {
          v -= 1;
        }
        setState(() {
          _controller.text = v.toString();
        });
        widget.onChanged(v);
      },
    );
  }
}
