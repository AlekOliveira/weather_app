//this is an stateful widget "stful"

import 'package:flutter/material.dart';
import 'package:weather_app/widgets/today_forecast.dart';
import 'package:weather_app/services/windy_point_forecast_api.dart';
// import 'package:weather_app/services/nominatim_reverse_geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/services.dart';

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
    _determinePosition();
  }

  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  Future<void> _loadForecastData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      //Api service layer to dinamically return geocode for cities by string
      // final apiServiceNominatim = NominatimGeocodeApiService();
      // final addresGeocode = await apiServiceNominatim.getAddresGeocode('Londrina');

      Position position;
      try {
        position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
      } catch (e) {
        print(e);
        position = Position(
            latitude: -23.2927,
            longitude: -51.1732,
            accuracy: 0,
            altitude: 0,
            heading: 0,
            speed: 0,
            speedAccuracy: 0,
            timestamp: DateTime.now(),
            floor: 0,
            isMocked: false);
      }

      final apiServiceWindy = WindyPointForecastApiService();
      final forecastData = await apiServiceWindy.getForecastData(
          position.latitude, position.longitude);

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
        body: Container(          
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/background.gif"), fit: BoxFit.fill),
          ),
          child: Column(
              children: [
            _isLoading
                ? Expanded(child: Center(child: CircularProgressIndicator()))
                : TodayForecast(
                    city: "Londrina",
                    minTemp: _forecastData['minTemp'] - 273.15,
                    currTemp: _forecastData['currTemp'] - 273.15,
                    maxTemp: _forecastData['maxTemp'] - 273.15,
                    description: "Mostly Cloudy")
          ])
        ));
  }
}


// TO-DO

// -Retrieve city name and weather description dinamically
// -Chose background image based on weather description
// -Fix the UI collors
// -Add temperature conversion C/F
