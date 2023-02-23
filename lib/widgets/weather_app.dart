//this is an statless widget "stles"

import 'package:flutter/src/widgets/framework.dart';

import 'package:flutter/material.dart';
import 'package:weather_app/widgets/home.dart';

class WeatherApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "WeatherApp",
      debugShowCheckedModeBanner: true,
      home: Home(),
    );
  }
}