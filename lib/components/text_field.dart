import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:workout_pad/extras/root.dart';

///
/// Creates a text field with custom styling that is follows
/// simple material design guidlines for android. On iOS and macOS,
/// a TextField from SwiftUI embeded into a List design priciples are
/// followed. Best to use on a black background in darkmode, or a purple tinted
/// background in light mode.
/// All of the highlight coloring is handled by [highlightColor].
class TextField extends StatefulWidget {
  final String labelText;
  final void Function(String) onChanged;
  final String? Function(String?)? validator;
  final Icon? icon;
  final bool obscureText;
  final Color highlightColor;
  final bool showCharacters;
  final int charLimit;
  String? value;
  final TextStyle? style;
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;
  final bool showBackground;
  final bool isLabeled;
  final EdgeInsets fieldPadding;
  final TextEditingController? controller;
  final List<TextInputFormatter> formatters;

  TextField({
    Key? key,
    required this.labelText,
    required this.onChanged,
    this.validator,
    this.icon,
    this.obscureText = false,
    this.highlightColor = Colors.blue,
    this.showCharacters = false,
    this.charLimit = 100,
    this.value,
    this.style,
    this.keyboardType,
    this.textCapitalization = TextCapitalization.sentences,
    this.showBackground = true,
    this.isLabeled = false,
    this.fieldPadding = const EdgeInsets.only(left: 16),
    this.formatters = const [],
    this.controller,
  }) : super(key: key);
  @override
  _TextFieldState createState() => _TextFieldState();
}

class _TextFieldState extends State<TextField> {
  @override
  Widget build(BuildContext context) {
    return Theme(
      key: widget.key,
      data: Theme.of(context).copyWith(
        primaryColor: widget.highlightColor,
        inputDecorationTheme: const InputDecorationTheme(
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              style: BorderStyle.solid,
              color: Colors.transparent,
            ),
          ),
        ),
      ),
      child: Stack(
        alignment: AlignmentDirectional.topEnd,
        children: [
          if (widget.showBackground)
            Material(
              color: CustomColors.cellColor(context),
              shape: ContinuousRectangleBorder(
                  borderRadius: BorderRadius.circular(35)),
              child: Padding(
                padding: widget.fieldPadding,
                child: _getLabeledCupertino(context),
              ),
            )
          else
            _getLabeledCupertino(context),
          if (widget.showCharacters)
            Text(
              '${widget.value?.length} / ${widget.charLimit}',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
        ],
      ),
    );
  }

  Widget _getLabeledCupertino(BuildContext context) {
    if (widget.isLabeled) {
      return _labelWrapper(context, _cupertinoTextField(context));
    } else {
      return _cupertinoTextField(context);
    }
  }

  Widget _labelWrapper(BuildContext context, Widget child) {
    return Stack(
      alignment: AlignmentDirectional.centerEnd,
      children: [
        child,
        Padding(
          padding: widget.showBackground
              ? EdgeInsets.only(right: widget.fieldPadding.left)
              : const EdgeInsets.all(0),
          child: Text(
            widget.labelText,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.black.withOpacity(0.5)
                  : Colors.white.withOpacity(0.5),
            ),
          ),
        ),
      ],
    );
  }

  Widget _cupertinoTextField(BuildContext context) {
    return TextFormField(
      autocorrect: false,
      controller: widget.controller,
      inputFormatters: widget.formatters,
      textCapitalization: widget.textCapitalization,
      keyboardType: widget.keyboardType,
      keyboardAppearance: Theme.of(context).brightness,
      initialValue: widget.value,
      cursorColor: widget.highlightColor,
      obscureText: widget.obscureText,
      maxLength: widget.charLimit,
      style: widget.style ??
          TextStyle(
            color: Theme.of(context).brightness == Brightness.light
                ? Colors.black
                : Colors.white,
          ),
      decoration: InputDecoration(
        counterStyle: const TextStyle(
          height: double.minPositive,
        ),
        counterText: "",
        hintText: widget.labelText,
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent),
        ),
        icon: widget.icon,
        hintStyle: TextStyle(
            color: Theme.of(context).brightness == Brightness.light
                ? Colors.black.withOpacity(0.5)
                : Colors.white.withOpacity(0.5)),
      ),
      onChanged: (value) {
        if (widget.showCharacters) {
          setState(() {
            widget.value = value;
          });
        }
        widget.onChanged(value);
      },
      validator: widget.validator,
    );
  }
}
