import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

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
        "key": dotenv.env['WINDY_WEATHER_API_KEY']
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      List<dynamic> tempKelvin = data['temp-surface'];
      final double maxTemp =
          tempKelvin.reduce((curr, next) => curr < next ? curr : next);
      final double minTemp =
          tempKelvin.reduce((curr, next) => curr > next ? curr : next);

      //obtain timeStamps list
      List<int> timeStamps = List.from(data['ts']);

      //search the closest time stamp from now
      final int currTimestamp = DateTime.now().millisecondsSinceEpoch;
      int closestTimestampFromNow = timeStamps[0];

      closestTimestampFromNow = timeStamps.reduce((closest, timestampValue) =>
          ((timestampValue - currTimestamp).abs() <
                  (closest - currTimestamp).abs())
              ? timestampValue
              : closest);

      //get the currtent temperature using the index of the closest time stamp from now
      double currTemp = tempKelvin[timeStamps.indexOf(closestTimestampFromNow)];

      print('currTimestamp: ${DateTime.fromMicrosecondsSinceEpoch(currTimestamp)}');
      print('closestTimestampFromNow : ${DateTime.fromMicrosecondsSinceEpoch(closestTimestampFromNow)}');

      return {
        'tempKelvin': tempKelvin,
        'minTemp': minTemp,
        'currTemp': currTemp,
        'maxTemp': maxTemp
      };
    } else {
      throw Exception('${response.body}');
    }
  }
}
