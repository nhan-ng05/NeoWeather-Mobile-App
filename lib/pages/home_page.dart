import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:weather_app/components/app_button.dart';
import 'package:weather_app/components/search_box.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/services/weather_service.dart';
import 'package:weather_icons/weather_icons.dart';

class HomePage extends StatefulWidget {
  // final WeatherModel weatherModel;
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final WeatherService weatherService = WeatherService();
  WeatherModel weatherModel = WeatherModel(
    city: null,
    country: null,
    temperature: null,
    description: null,
    humidity: null,
    windSpeed: null,
    icon: null,
  );
  final TextEditingController searchController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();

  void refreshPage() {}

  void findCity(String? city) async {
    if (city == null) return;
    WeatherModel loadWeatherModel = await weatherService.getWeather(city);
    setState(() {
      weatherModel = loadWeatherModel;
    });
  }

  String getIconUrl(String icon) {
    String url = "assets/$icon.gif";
    switch (icon) {
      case "03n" && "04n":
        icon = "04d";
        return url;
      case "09n":
        icon = "09n";
        return url;
      case "13n":
        icon = "13d";
        return url;
    }
    return url;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.only(left: 20, right: 20, top: 60, bottom: 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // search box
            SearchBox(
              controller: searchController,
              focusNode: searchFocusNode,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
              readOnly: false,
              decoration: InputDecoration(
                hintText: "Nhập Tên Thành Phố",
                hintStyle: TextStyle(color: Colors.grey.shade500),

                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.blue, width: 2),
                ),

                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.blue, width: 2),
                ),
              ),
              textAlign: TextAlign.center,
              obscureText: false,
              onSubmitted: findCity,
            ),

            Expanded(
              child: ListView(
                children: [
                  // country
                  Center(
                    child: Text(
                      weatherModel.country ?? "No Info . . .",
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),

                  // city
                  Center(
                    child: Text(
                      weatherModel.city ?? "Finding . . .",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 45,
                      ),
                    ),
                  ),

                  // weather icon
                  Padding(
                    padding: EdgeInsets.only(top: 50, bottom: 50),
                    child: Center(
                      child: weatherModel.icon == null
                          ? const SizedBox(
                              height: 200,
                              width: 200,
                              child: CircularProgressIndicator(
                                strokeWidth: 5.0,
                                color: Colors.black,
                              ),
                            )
                          : Image.asset(getIconUrl(weatherModel.icon!)),
                    ),
                  ),

                  // temperature
                  SizedBox(
                    height: 50,
                    child: Center(
                      child: Text(
                        weatherModel.temperature ?? "Không Có Thông Tin",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),

                  // weather description
                  SizedBox(
                    height: 50,
                    child: Center(
                      child: Text(
                        weatherModel.description ?? "Không Có Mô Tả Thời Tiết",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),

                  // humidity / wind
                  Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: SizedBox(
                      height: 100,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.only(left: 20, right: 20),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.blue.shade200,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Humidity",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Icon(WeatherIcons.humidity),
                                    ],
                                  ),
                                  weatherModel.humidity == null
                                      ? Padding(
                                          padding: EdgeInsets.only(
                                            top: 10,
                                            bottom: 10,
                                          ),
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2.5,
                                            color: Colors.black,
                                          ),
                                        )
                                      : Text(weatherModel.humidity!),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.only(left: 20, right: 20),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.blue.shade200,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Wind Speed",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Icon(WeatherIcons.windy),
                                    ],
                                  ),
                                  weatherModel.windSpeed == null
                                      ? Padding(
                                          padding: EdgeInsets.only(
                                            top: 10,
                                            bottom: 10,
                                          ),
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2.5,
                                            color: Colors.black,
                                          ),
                                        )
                                      : Text("${weatherModel.windSpeed!} m/s"),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // refresh button
            // SizedBox(
            //   width: double.infinity,
            //   height: 50,
            //   child: AppButton(
            //     label: "Tải Lại Trang",
            //     onPressed: refreshPage,
            //     icon: Icon(Icons.replay),
            //     iconColor: Colors.white,
            //     foregroundColor: Colors.white,
            //     backgroundColor: Colors.blue,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
