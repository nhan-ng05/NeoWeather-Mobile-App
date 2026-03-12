class WeatherModel {
  final String? city;
  final String? country;
  final String? temperature;
  final String? humidity;
  final String? description;
  final String? windSpeed;
  final String? icon;

  WeatherModel({
    required this.city,
    required this.country,
    required this.temperature,
    required this.description,
    required this.humidity,
    required this.windSpeed,
    required this.icon,
  });

  // convert json
  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      city: json["name"],
      country: json["sys"]["country"],
      temperature: json["main"]["temp"].toString(),
      description: json["weather"][0]["description"],
      humidity: json["main"]["humidity"].toString(),
      windSpeed: json["wind"]["speed"].toString(),
      icon: json["weather"][0]["icon"],
    );
  }
}
