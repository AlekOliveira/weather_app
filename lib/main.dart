//this file is like an entrypoint for the application, loading the "WeatherApp"

import 'package:flutter/material.dart';
import 'package:weather_app/widgets/weather_app.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


Future main() async {
  // To load the .env file contents into dotenv.
  // NOTE: fileName defaults to .env and can be omitted in this case.
  // Ensure that the filename corresponds to the path in step 1 and 2.
  await dotenv.load(fileName: ".env");
  runApp(WeatherApp());
}