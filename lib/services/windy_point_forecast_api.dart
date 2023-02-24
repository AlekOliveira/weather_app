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
        "key": ""
      }),
    );

    if (response.statusCode == 200) {
      /*200: everything went as expected
        204: the selected model does not feature any of the requested parameters
        400: invalid request, error in the body’s description
        500: unexpected error (normally it should not occur - can happen e.g. when our back ends cannot return data)*/
      return jsonDecode(response.body);
    } else {
      throw Exception("Error while fetching forecast data");
    }
  }
}
