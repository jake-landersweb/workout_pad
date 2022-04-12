import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class Navigate extends Navigator {
  Navigate(BuildContext context, Widget body) {
    if (kIsWeb) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Scaffold(
            resizeToAvoidBottomInset: false,
            body: body,
          ),
        ),
      );
    } else if (Platform.isIOS || Platform.isMacOS) {
      Navigator.push(
        context,
        MaterialWithModalsPageRoute(
          builder: (context) => Scaffold(
            resizeToAvoidBottomInset: false,
            body: body,
          ),
        ),
      );
    } else {
      // android, windows and linux
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Scaffold(
            resizeToAvoidBottomInset: false,
            body: body,
          ),
        ),
      );
    }
  }
}
