import 'package:flutter/material.dart';
import 'dart:math' as math;

extension StringExtension on String? {
  bool get isEmpty {
    if (this == null) {
      return true;
    } else if (this == "") {
      return true;
    } else {
      return false;
    }
  }

  bool get isNotEmpty {
    if (this == null) {
      return false;
    } else if (this == "") {
      return false;
    } else {
      return true;
    }
  }
}

extension IntExtensions on int? {
  bool get isEmpty {
    if (this == null) {
      return true;
    } else if (this == 0) {
      return true;
    } else {
      return false;
    }
  }

  bool get isNotEmpty {
    if (this == null) {
      return false;
    } else if (this == 0) {
      return false;
    } else {
      return true;
    }
  }
}

extension FancyIterable on Iterable<int> {
  int get max => reduce(math.max);

  int get min => reduce(math.min);
}

extension CustomColors on Colors {
  static Color lightList = const Color.fromRGBO(242, 242, 248, 1);
  // static Color subLightList = const Color.fromRGBO(232, 232, 240, 1);

  static Color darkList = const Color.fromRGBO(48, 48, 50, 1);
  // static Color subDarkList = const Color.fromRGBO(38, 38, 40, 1);

  static Color darkBackground = const Color.fromRGBO(30, 30, 33, 1);

  static Color textColor(BuildContext context) {
    if (Theme.of(context).brightness == Brightness.light) {
      return Colors.black;
    } else {
      return Colors.white;
    }
  }

  static Color plainBackground(BuildContext context) {
    if (Theme.of(context).brightness == Brightness.light) {
      return Colors.white;
    } else {
      return Colors.black;
    }
  }

  static Color cellColor(BuildContext context) {
    if (Theme.of(context).brightness == Brightness.light) {
      return Colors.white;
    } else {
      return CustomColors.darkList;
    }
  }

  static Color backgroundColor(BuildContext context) {
    if (Theme.of(context).brightness == Brightness.light) {
      return lightList;
    } else {
      return const Color.fromRGBO(30, 30, 33, 1);
    }
  }

  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  static Color base() {
    return CustomColors.fromHex("7bc5d6");
  }

  static Color random(String seed) {
    int num = 0;
    for (int i = 0; i < seed.length; i++) {
      num += seed[i].codeUnitAt(0);
    }
    // add lightness to make it look better overall
    Color col = Color((math.Random(num).nextDouble() * 0xFFFFFF).toInt())
        .withOpacity(1.0);
    HSLColor hsl = HSLColor.fromColor(col);
    return hsl.withLightness(0.75).toColor();
  }
}
