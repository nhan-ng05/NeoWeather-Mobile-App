import 'package:flutter/material.dart';
import 'package:weather_app/animations/cloud_icon.dart';
import 'package:weather_app/animations/fog_icon.dart';
import 'package:weather_app/animations/moon_icon.dart';
import 'package:weather_app/animations/rain_icon.dart';
import 'package:weather_app/animations/snow_icon.dart';
import 'package:weather_app/animations/sun_icon.dart';
import 'package:weather_app/animations/thunder_icon.dart';

class WeatherAnimatedIcon extends StatelessWidget {
  final String iconCode;
  final double size;

  const WeatherAnimatedIcon({
    super.key,
    required this.iconCode,
    this.size = 60,
  });

  @override
  Widget build(BuildContext context) {
    switch (iconCode) {
      case "01d":
        return SunIcon(size: size);
      case "01n":
        return MoonIcon(size: size);

      case "02d":
      case "03d":
      case "04d":
        return CloudIcon(size: size);

      case "02n":
      case "03n":
      case "04n":
        return CloudIcon(size: size, isNight: true);

      case "09d":
      case "10d":
      case "09n":
      case "10n":
        return RainIcon(size: size);

      case "11d":
      case "11n":
        return ThunderIcon(size: size);

      case "13d":
      case "13n":
        return SnowIcon(size: size);

      case "50d":
      case "50n":
        return FogIcon(size: size);

      default:
        return Icon(Icons.help_outline, size: size);
    }
  }
}
