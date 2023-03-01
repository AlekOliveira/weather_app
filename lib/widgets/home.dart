//this is an stateful widget "stful"

import 'package:flutter/material.dart';
import 'package:weather_app/widgets/today_forecast.dart';
import 'package:weather_app/services/windy_point_forecast_api.dart';
import 'package:weather_app/services/nominatim_reverse_geocoding.dart';
import 'package:flutter/foundation.dart';


class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  /* vars with _underscore before the name means that they are private vars*/
  Map<String, dynamic> _forecastData = {};

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadForecastData();
  }

  Future<void> _loadForecastData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final apiServiceWindy = WindyPointForecastApiService();
      final apiServiceNominatim = NominatimGeocodeApiService();

      final addresGeocode = await apiServiceNominatim.getAddresGeocode('Londrina');
      final forecastData = await apiServiceWindy.getForecastData(addresGeocode['lat'], addresGeocode['lon']);
      
      /*
        TO-DO, process all the data to retrieve the following informations:

        Today Forecast
        -weather overall string description
        -current temp
        -lower temp 
        -highest temp


        Hourly Forecast 
        ....

        10Day Forecast
        ...
      */

      //update the private vars states
      setState(() {
        _forecastData = forecastData;
        _isLoading = false;
      });
    } catch (e) {
      print(e);
      setState(() {
        _isLoading = false;
      });
    }
  }

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
              minTemp: 20.0,
              currTemp: 24.0,
              maxTemp: 26.0,
              description: "Mostly Cloudy")
        ],
      ),
    );
  }
}
