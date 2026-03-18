import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/models/weather_model.dart';

class WeatherService {
  final String apiKey = "d31d897e26cda6c950d80fc7af5c9a62";

  Future<WeatherModel> getWeatherByCity(String city) async {
    final String url =
        "https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric&lang=vi";
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return WeatherModel.fromJson(json);
    } else {
      // print("Lỗi API: ${response.body}");
      // throw Exception("Failed to load weather");
      return WeatherModel(
        city: null,
        country: null,
        temperature: null,
        description: null,
        humidity: null,
        windSpeed: null,
        icon: null,
        feelsLike: null,
        dateTime: null,
      );
    }
  }

  Future<WeatherModel> getWeatherByPosition(Position position) async {
    final String url =
        "https://api.openweathermap.org/data/2.5/weather?lat=${position.latitude}&lon=${position.longitude}&appid=$apiKey&units=metric&lang=vi";
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return WeatherModel.fromJson(json);
    } else {
      // print("Lỗi API: ${response.body}");
      // throw Exception("Failed to load weather");
      return WeatherModel(
        city: null,
        country: null,
        temperature: null,
        description: null,
        humidity: null,
        windSpeed: null,
        icon: null,
        feelsLike: null,
        dateTime: null,
      );
    }
  }

  Future<Position?> getPositionByCity(String city) async {
    final String url =
        "http://api.openweathermap.org/geo/1.0/direct?q=$city&limit=1&appid=$apiKey";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      if (data.isNotEmpty) {
        final lat = data[0]["lat"];
        final lon = data[0]["lon"];

        return Position(
          latitude: lat,
          longitude: lon,
          timestamp: DateTime.now(),
          accuracy: 0,
          altitude: 0,
          heading: 0,
          speed: 0,
          speedAccuracy: 0,
          altitudeAccuracy: 0,
          headingAccuracy: 0,
        );
      }
    }
    return null;
  }
}
