import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/pages/home_page.dart';
import 'package:weather_app/services/location_service.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  LocationService locationService = LocationService();
  Position position = await locationService.getCurrentLocation();
  await initializeDateFormatting(
    'vi_VN',
    null,
  ).then((_) => runApp(MyApp(position: position)));
}

class MyApp extends StatelessWidget {
  final Position position;
  const MyApp({super.key, required this.position});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Simple Weather App',
      home: HomePage(position: position),
    );
  }
}
