import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:weather_app/models/weather_model.dart';

class WeatherService {
  final String apiKey = "d31d897e26cda6c950d80fc7af5c9a62";

  Future<WeatherModel> getWeather(String city) async {
    final String url =
        "https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric";
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
      );
    }
  }
}
