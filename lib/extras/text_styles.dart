import 'package:flutter/material.dart';
import 'package:workout_pad/extras/root.dart';

class TextStyles {
  static TextStyle smallLabel(BuildContext context,
      {Color? color, bool? underline}) {
    return TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: color ?? CustomColors.textColor(context).withOpacity(0.7),
      decoration: underline ?? false ? TextDecoration.underline : null,
    );
  }

  static TextStyle section(BuildContext context,
      {Color? color, bool? underline}) {
    return TextStyle(
      fontWeight: FontWeight.w500,
      color: color ?? CustomColors.textColor(context).withOpacity(0.5),
      decoration: underline ?? false ? TextDecoration.underline : null,
    );
  }

  static TextStyle body({Color? color, bool? underline}) {
    return TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: color,
      decoration: underline ?? false ? TextDecoration.underline : null,
    );
  }

  static TextStyle label({Color? color, bool? underline}) {
    return TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: color,
      decoration: underline ?? false ? TextDecoration.underline : null,
    );
  }

  static TextStyle title({Color? color, bool? underline}) {
    return TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.w700,
      color: color,
      decoration: underline ?? false ? TextDecoration.underline : null,
    );
  }
}
