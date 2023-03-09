import 'dart:convert';
import 'package:http/http.dart' as http;

class WindyPointForecastApiService {
  final String _baseUrl = "https://api.windy.com/api/point-forecast/v2";

  Future<Map<String, dynamic>> getForecastData(
      double latitude, double longitude) async {
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "lat": latitude,
        "lon": longitude,
        "model": "gfs",
        "parameters": ["temp", "precip"],
        "key": "LxkX09qmh4dcfy0x16kKBkfMiYBwOmdy"
      }),
    );

    if (response.statusCode == 200) {
      // celsius = (kelvinTemp - 273.15)

      /*200: everything went as expected
        204: the selected model does not feature any of the requested parameters
        400: invalid request, error in the body’s description
        500: unexpected error (normally it should not occur - can happen e.g. when our back ends cannot return data)*/

      final data = jsonDecode(response.body);
      final timeStamps = data['ts'];
      List<dynamic> tempKelvin = data['temp-surface'];
      final double minTemp =
          tempKelvin.reduce((curr, next) => curr < next ? curr : next);
      final double maxTemp =
          tempKelvin.reduce((curr, next) => curr > next ? curr : next);
      List<DateTime> timeData = [];
      timeStamps.forEach((timeStamp) =>
          timeData.add(DateTime.fromMicrosecondsSinceEpoch(timeStamp)));

      return {
        'tempKelvin': tempKelvin,
        'timeData': timeData,
        'minTemp': minTemp,
        'currTemp': 2.0,
        'maxTemp': maxTemp
      };
    } else {
      // return {
      //   'tempKelvin': [100.0, 120.0, 130.0],
      //   'minTemp': 4.0,
      //   'currTemp': 2.0,
      //   'maxTemp': 10.0
      // };

      throw Exception('${response.body}');
    }
  }
}
