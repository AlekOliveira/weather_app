import 'package:flutter/material.dart';

class TodayForecast extends StatelessWidget {
  /*since this is an stateless component, all attributes will be declared as "final"*/
  final String city, description;
  final double currTemp, minTemp, maxTemp;

  //constructor for the final attributes
  const TodayForecast(
      {super.key,
      required this.city,
      required this.description,
      required this.currTemp,
      required this.minTemp,
      required this.maxTemp});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(padding: EdgeInsets.all(5)),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Column(
              //farenheint switcher
              children: [
                Text("°C / °F"),
                Switch(value: false, onChanged: (valor) {})
              ],
            )
          ],
        ),

        Text(
          city,
          style: TextStyle(fontSize: 30),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //D
            Text(
              '${currTemp.toStringAsFixed(0)}° ',
              style: TextStyle(fontSize: 80),
            ),
            Column(
              children: [
                Text('H: ${minTemp.toStringAsFixed(0)}°', style: TextStyle(fontSize: 18)),
                Text('L: ${maxTemp.toStringAsFixed(0)}°', style: TextStyle(fontSize: 18))
              ],
            ),
          ],
        ),
        Text(description, style: TextStyle(fontSize: 18)),
      ],
    );
  }
}
