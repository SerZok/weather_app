import 'package:flutter/material.dart';
import 'package:weather_app/di/di.dart';
import 'package:weather_app/weather_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  FlutterError.onError = (details) => talker.handle(
        details.exception,
        details.stack,
      );
  runApp(const NewsBriefApp());
}
