import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sprung/sprung.dart';
import 'package:workout_pad/data/data_model.dart';
import 'package:workout_pad/data/root.dart';
import 'package:workout_pad/extras/themes.dart';
import 'package:workout_pad/views/home.dart';
import 'components/root.dart' as cv;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => DataModel()),
        ChangeNotifierProvider(create: (context) => SheetModel())
      ],
      child: Builder(
        builder: (context) {
          return _body(context);
        },
      ),
    );
  }

  Widget _body(BuildContext context) {
    return MaterialApp(
      title: 'Workout Pad',
      theme: lightTheme,
      darkTheme: darkTheme,
      home: const cv.SheetWrapper(
        child: Home(),
      ),
      debugShowCheckedModeBanner: false,
      // showPerformanceOverlay: true,
      builder: (context, child) {
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: MediaQuery.of(context).platformBrightness == Brightness.light
              ? SystemUiOverlayStyle.dark
              : SystemUiOverlayStyle.light,
          child: GestureDetector(
            onTap: () {
              // for dismissing keybaord when tapping on the screen
              WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
            },
            child: child!,
          ),
        );
      },
    );
  }
}
