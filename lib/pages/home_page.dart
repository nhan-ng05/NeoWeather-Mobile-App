import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:weather_app/animations/weather_animated_icon.dart';
import 'package:weather_app/components/search_box.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/services/location_service.dart';
import 'package:weather_app/services/weather_service.dart';
import 'package:weather_icons/weather_icons.dart';

class HomePage extends StatefulWidget {
  // final Position position;
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isFahrenheit = false;
  bool isVietnamese = true;
  late Position? position;
  Widget exceptionMessage = Text("");
  bool isLoading = true;
  final LocationService locationService = LocationService();
  late String? currentPosition;
  final WeatherService weatherService = WeatherService();
  List forecast = [];
  WeatherModel weatherModel = WeatherModel(
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
  final TextEditingController searchController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();

  double convertTemp(double celsius, bool isFahrenheit) {
    if (isFahrenheit) {
      return double.parse(((celsius * 9 / 5) + 32).toStringAsFixed(1));
    }
    return double.parse(celsius.toStringAsFixed(1));
  }

  Future<void> _loadData({String city = ""}) async {
    // trigger animation
    setState(() {
      isLoading = true;
      exceptionMessage = handlingException(1);
    });

    try {
      // get position
      if (city != "") {
        position = await weatherService.getPositionByCity(city);
      } else {
        position = await locationService.getCurrentLocation();
      }
      await initializeDateFormatting('vi_VN', null);

      // get administration && ministration
      currentPosition = await locationService.getDistrictName(
        position!.latitude,
        position!.longitude,
        isVietnamese ? "vi_VN" : "en_US",
      );

      // get weather forecast
      forecast = await weatherService.getForecast(
        position!.latitude,
        position!.longitude,
        isVietnamese ? "vi" : "en",
      );

      // get position
      WeatherModel loadWeatherModel = await weatherService.getWeatherByPosition(
        position!,
        isVietnamese ? "vi" : "en",
      );
      if (mounted) {
        if (loadWeatherModel.city == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Center(
                child: Text("Không tìm thấy thành phố bạn nhập!"),
              ),
            ),
          );
        }
      }

      // reload state
      setState(() {
        weatherModel = loadWeatherModel;
      });
    } on SocketException catch (e) {
      setState(() {
        exceptionMessage = handlingException(2, text: e.message);
      });
      return;
    } on HttpException catch (e) {
      setState(() {
        exceptionMessage = handlingException(2, text: e.message);
      });
      return;
    } catch (e) {
      setState(() {
        exceptionMessage = handlingException(2, text: "$e");
      });
      return;
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  // String getIconUrl(String icon) {
  //   String url = "assets/$icon.gif";
  //   switch (icon) {
  //     case "04n":
  //       return "assets/04d.gif";
  //     case "03n":
  //       return "assets/03d.gif";
  //     case "13n":
  //       return "assets/13d.gif";
  //   }
  //   print("Chưa có icon mã: $icon");
  //   return url;
  // }

  Future<void> findCity(String? city) async {
    if (city == null) return;
    try {
      WeatherModel loadWeatherModel = await weatherService.getWeatherByCity(
        city,
        isVietnamese ? "vi" : "en",
      );
      if (mounted) {
        if (loadWeatherModel.city == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Center(
                child: Text("Không tìm thấy thành phố bạn nhập!"),
              ),
            ),
          );
        }
      }
      Position? searchPosition = await weatherService.getPositionByCity(city);
      if (searchPosition != null) {
        currentPosition = await locationService.getDistrictName(
          searchPosition.latitude,
          searchPosition.longitude,
          isVietnamese ? "vi_VN" : "en_US",
        );
        forecast = await weatherService.getForecast(
          searchPosition.latitude,
          searchPosition.longitude,
          isVietnamese ? "vi" : "en",
        );
      } else {
        currentPosition = null;
        forecast = [];
      }
      setState(() {
        weatherModel = loadWeatherModel;
      });
    } catch (e) {
      print("Lỗi: $e");
    }
  }

  String capitalize(String word) {
    if (word.isEmpty) return word;
    return word[0].toUpperCase() + word.substring(1);
  }

  String capitalizeSentence(String sentence) {
    return sentence.split(' ').map((word) => capitalize(word)).join(' ');
  }

  Widget handlingException(int type, {String text = ""}) {
    if (type == 1) {
      return SizedBox(
        width: 150,
        height: 150,
        child: CircularProgressIndicator(color: Colors.black),
      );
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 100,
          child: Icon(
            Icons.wifi_rounded,
            color: Colors.grey.shade500,
            size: 70.0,
          ),
        ),
        Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.grey.shade500,
            fontWeight: FontWeight.w500,
            fontSize: 20,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: Colors.blue.shade100),
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.cloud, size: 40, color: Colors.blue),
              ),
              accountName: Text(
                isVietnamese ? "Ứng dụng Thời tiết" : "Weather App",
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              accountEmail: Text(
                isVietnamese
                    ? "Dữ liệu lấy từ OpenWeatherMap"
                    : "Data from OpenWeatherMap",
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.thermostat),
              title: Text(isVietnamese ? "Đơn vị: °F" : "Unit: °F"),
              trailing: Switch(
                value: isFahrenheit,
                onChanged: (value) {
                  setState(() {
                    isFahrenheit = value;
                  });
                },
              ),
            ),
            ListTile(
              leading: const Icon(Icons.language),
              title: Text(isVietnamese ? "Ngôn ngữ: VN" : "Language: EN"),
              trailing: Switch(
                value: isVietnamese,
                onChanged: (value) {
                  setState(() {
                    isVietnamese = value;

                    // keep current Position when user search
                    _loadData(city: searchController.text);
                  });
                },
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 100,
        title: SearchBox(
          controller: searchController,
          focusNode: searchFocusNode,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
          readOnly: false,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.blue.shade100,
            hintText: isVietnamese
                ? "Nhập Tên Thành Phố"
                : "Enter the city name",
            hintStyle: TextStyle(color: Colors.grey.shade600),
            // prefixIcon: const Icon(Icons.search, color: Colors.blue),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide.none,
            ),
          ),
          textAlign: TextAlign.center,
          obscureText: false,
          onSubmitted: findCity,
        ),
      ),
      body: isLoading
          ? RefreshIndicator(
              onRefresh: _loadData,
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: Center(child: exceptionMessage),
                ),
              ),
            )
          : RefreshIndicator(
              onRefresh: _loadData,
              child: ListView(
                physics: AlwaysScrollableScrollPhysics(),
                children: [
                  // position
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Icon(
                            Icons.place,
                            color: Colors.blue.shade700,
                            size: 24,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            currentPosition ?? "Không Có Thông Tin Địa Điểm",
                            textAlign: TextAlign
                                .center, // Rất quan trọng khi xuống dòng
                            style: TextStyle(
                              color: Colors.blue.shade700,
                              fontWeight: FontWeight.w800,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Datetime
                  Center(
                    child: Text(
                      weatherModel.dateTime ?? "Không Có Thông Tin Thời Gian",
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),

                  // weather icon
                  Center(
                    child: weatherModel.icon == null
                        ? const Padding(
                            padding: EdgeInsets.symmetric(vertical: 70),
                            child: SizedBox(
                              height: 250,
                              width: 250,
                              child: CircularProgressIndicator(
                                color: Colors.black,
                              ),
                            ),
                          )
                        : SizedBox(
                            height: 400,
                            child: Center(
                              child: WeatherAnimatedIcon(
                                iconCode: weatherModel.icon!,
                                size: 300,
                              ),
                            ),

                            // child: Image.asset(
                            //   getIconUrl(weatherModel.icon!),
                            //   height: 200,
                            // ),
                          ),
                  ),

                  // temperature
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          weatherModel.temperature != null
                              ? "${convertTemp(weatherModel.temperature!, isFahrenheit)} "
                              : "-- ",
                          style: TextStyle(
                            color: Colors.blue.shade700,
                            fontSize: 32,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          isFahrenheit ? "°F" : "°C",
                          style: TextStyle(
                            color: Colors.blue.shade700,
                            fontSize: 32,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // description
                  Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 10, bottom: 20),
                      child: Text(
                        capitalizeSentence(
                          weatherModel.description ??
                              "Không Có Thông Tin Mô Tả",
                        ),
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ),
                  ),

                  // humidity & wind speed & feels like
                  Padding(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 25),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: Colors.blue.shade100,
                      ),

                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // humidity
                            Expanded(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Icon(WeatherIcons.rain, size: 25),
                                  const SizedBox(height: 6),
                                  Text(
                                    "${weatherModel.humidity ?? "--"} %",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    isVietnamese ? "Độ Ẩm" : "Humidity",
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // wind speed
                            Expanded(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Icon(WeatherIcons.cloudy_windy, size: 25),
                                  const SizedBox(height: 6),
                                  Text(
                                    "${weatherModel.windSpeed ?? "--"} m/s",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    isVietnamese ? "Tốc Độ Gió" : "Wind Speed",
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // feels like
                            Expanded(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Icon(WeatherIcons.thermometer, size: 25),
                                  const SizedBox(height: 6),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        weatherModel.feelsLike != null
                                            ? "${convertTemp(weatherModel.feelsLike!, isFahrenheit)} "
                                            : "-- ",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        isFahrenheit ? "°F" : "°C",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    isVietnamese
                                        ? "Cảm Thấy Như"
                                        : "Feels Like",
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // title
                  Padding(
                    padding: const EdgeInsets.only(top: 30, left: 20),
                    child: Text(
                      isVietnamese ? "Dự báo thời tiết" : "Weather Forecast",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade700,
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  // forecast list
                  Padding(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: SizedBox(
                      height: 170,
                      // width: 300,
                      child: forecast.isEmpty
                          ? Center(
                              child: SizedBox(
                                height: 100,
                                width: 100,
                                child: CircularProgressIndicator(
                                  color: Colors.black,
                                ),
                              ),
                            )
                          : ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: forecast.length,
                              itemBuilder: (context, index) {
                                final WeatherModel item = forecast[index];

                                return Container(
                                  width: 180,
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.blue.shade100,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(item.dateTime ?? "--"),

                                      // Image.asset(
                                      //   getIconUrl(item.icon ?? ""),
                                      //   height: 40,
                                      // ),
                                      WeatherAnimatedIcon(
                                        iconCode: item.icon!,
                                        size: 70,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            item.temperature == null
                                                ? "--"
                                                : "${convertTemp(item.temperature!, isFahrenheit)}",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                          Text(
                                            isFahrenheit ? " °F" : " °C",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                    ),
                  ),

                  // spacing
                  const SizedBox(height: 30),
                ],
              ),
            ),
    );
  }
}
