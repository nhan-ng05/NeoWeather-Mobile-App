import 'package:intl/intl.dart';

class WeatherModel {
  final String? city;
  final String? country;
  final String? temperature;
  final String? humidity;
  final String? description;
  final String? windSpeed;
  final String? icon;
  final String? feelsLike;
  final String? dateTime;

  WeatherModel({
    required this.city,
    required this.country,
    required this.temperature,
    required this.description,
    required this.humidity,
    required this.windSpeed,
    required this.icon,
    required this.feelsLike,
    required this.dateTime,
  });

  // convert json
  factory WeatherModel.fromJson(
    Map<String, dynamic> json,
    bool isVietnamese, {
    bool isForecast = false,
    int timezone = 0,
  }) {
    int dt = json['dt'] ?? 0;

    DateTime cityTime = DateTime.fromMillisecondsSinceEpoch(
      (dt + timezone) * 1000,
      isUtc: true,
    );

    String formattedDate = DateFormat(
      isForecast ? 'HH:mm, d/M, yyyy' : 'EEEE, d MMMM, yyyy',
      isVietnamese ? 'vi_VN' : 'en_US',
    ).format(cityTime);

    return WeatherModel(
      city: isForecast ? null : json["name"],
      country: isForecast ? null : json["sys"]?["country"],
      temperature: json["main"]["temp"].toDouble().round().toString(),
      description: json["weather"][0]["description"],
      humidity: json["main"]["humidity"].toString(),
      windSpeed: json["wind"]["speed"].toString(),
      icon: json["weather"][0]["icon"],
      feelsLike: json["main"]["feels_like"]?.toDouble().round().toString(),
      dateTime: formattedDate,
    );
  }
  // factory WeatherModel.fromJson(
  //   Map<String, dynamic> json, {
  //   bool isForecast = false,
  // }) {
  //   int dt = json['dt'] ?? 0;
  //   int timezone = json['timezone'] ?? 0;

  //   DateTime cityTime = DateTime.fromMillisecondsSinceEpoch(
  //     (dt + timezone) * 1000,
  //     isUtc: true,
  //   );

  //   String formattedDate = DateFormat(
  //     'EEEE, d MMMM, yyyy',
  //     'vi_VN',
  //   ).format(cityTime);

  //   return WeatherModel(
  //     city: isForecast ? null : json["name"],
  //     country: isForecast ? null : json["sys"]?["country"],
  //     temperature: json["main"]["temp"].toDouble().round().toString(),
  //     description: json["weather"][0]["description"],
  //     humidity: json["main"]["humidity"].toString(),
  //     windSpeed: json["wind"]["speed"].toString(),
  //     icon: json["weather"][0]["icon"],
  //     feelsLike: json["main"]["feels_like"]?.toDouble().round().toString(),
  //     dateTime: formattedDate,
  //   );
  // }
}
