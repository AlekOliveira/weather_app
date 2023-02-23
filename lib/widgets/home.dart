//this is an stateful widget "stful"

import 'package:flutter/material.dart';
import 'package:weather_app/widgets/today_forecast.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Weather App"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          TodayForecast(
              city: "Londrina",
              minTemp: 15.0,
              currTemp: 22.0,
              maxTemp: 30.0,
              description: "Mostly Cloudy")
        ],
      ),
    );
  }
}
