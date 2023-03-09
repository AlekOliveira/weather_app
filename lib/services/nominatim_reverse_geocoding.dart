import 'dart:convert';
import 'package:http/http.dart' as http;

class NominatimGeocodeApiService {
  String _baseUrl =
      'https://nominatim.openstreetmap.org/?addressdetails=1&q=<cityName>&format=json&limit=1';

  Future<Map<String, dynamic>> getAddresGeocode(String cityName) async {
    _baseUrl = _baseUrl.replaceAll('<cityName>', cityName);

    final response = await http.get(Uri.parse(_baseUrl));

    if (response.statusCode == 200) {
      //this api returns a Json List, not a Map

      List<dynamic> jsonData = jsonDecode(response.body);
      Map<String, dynamic> dataMap = Map<String, dynamic>.from(jsonData.first);

      final double lat = double.parse(dataMap['lat'].toString());
      final double lon = double.parse(dataMap['lon'].toString());

      if (lat != null && lon != null) {
        return {'lat': lat, 'lon': lon};
      } else {
        throw FormatException('Could not parse latitude or longitude');
      }
    } else {
      //TO-DO, return device location
      throw Exception("Error while fetching location data");
    }
  }
}
