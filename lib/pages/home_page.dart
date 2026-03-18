import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/components/search_box.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/services/location_service.dart';
import 'package:weather_app/services/weather_service.dart';
import 'package:weather_icons/weather_icons.dart';

class HomePage extends StatefulWidget {
  final Position position;
  const HomePage({super.key, required this.position});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = true;
  final LocationService locationService = LocationService();
  late String? currentPosition;
  final WeatherService weatherService = WeatherService();
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

  Future<void> _loadData() async {
    setState(() {
      isLoading = true;
    });

    // get administration && ministration
    currentPosition = await locationService.getDistrictName(
      widget.position.latitude,
      widget.position.longitude,
    );

    // get position
    try {
      WeatherModel loadWeatherModel = await weatherService.getWeatherByPosition(
        widget.position,
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
      setState(() {
        weatherModel = loadWeatherModel;
      });
    } catch (e) {
      print("Lỗi: $e");
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

  String getIconUrl(String icon) {
    String url = "assets/$icon.gif";
    switch (icon) {
      case "04n":
        return "assets/04d.gif";
      case "03n":
        return "assets/03d.gif";
      case "13n":
        return "assets/13d.gif";
    }
    print("Chưa có icon mã: $icon");
    return url;
  }

  Future<void> findCity(String? city) async {
    if (city == null) return;
    try {
      WeatherModel loadWeatherModel = await weatherService.getWeatherByCity(
        city,
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
        );
      } else {
        currentPosition = null;
      }
      setState(() {
        weatherModel = loadWeatherModel;
      });
    } catch (e) {
      print("Lỗi: $e");
    }
  }

  // upper case in every first word letter
  String capitalize(String word) {
    if (word.isEmpty) return word;
    return word[0].toUpperCase() + word.substring(1);
  }

  String capitalizeSentence(String sentence) {
    return sentence.split(' ').map((word) => capitalize(word)).join(' ');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
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
            hintText: "Nhập Tên Thành Phố Muốn Tìm",
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
          ? const Center(child: CircularProgressIndicator())
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
                            child: Image.asset(
                              getIconUrl(weatherModel.icon!),
                              height: 200,
                            ),
                          ),
                  ),

                  // temperature
                  Center(
                    child: Text(
                      weatherModel.temperature != null
                          ? "${weatherModel.temperature}°C"
                          : "-- °C",
                      style: TextStyle(
                        color: Colors.blue.shade700,
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                      ),
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
                                  Text("${weatherModel.humidity ?? "--"} %"),
                                  Text(
                                    "Độ Ẩm",
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
                                  Text("${weatherModel.windSpeed ?? "--"} m/s"),
                                  Text(
                                    "Tốc Độ Gió",
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
                                  Text("${weatherModel.feelsLike ?? "--"} °C"),
                                  Text(
                                    "Cảm Thấy Như",
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
                ],
              ),
            ),
    );
  }
}
