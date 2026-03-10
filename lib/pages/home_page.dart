import 'package:flutter/material.dart';
import 'package:weather_app/components/app_button.dart';
import 'package:weather_app/components/search_box.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController searchController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();
  String country = "Vietnam";
  String city = "Hanoi";
  String temperature = "36*C";
  String weatherDescription = "Thời tiết hanh khô,nắng nhiều";
  String humidity = "70%";
  String wind = "5 km/h";

  void refreshPage() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.green,
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
            ),

            Expanded(
              child: ListView(
                children: [
                  // country
                  Center(
                    child: Text(
                      country,
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
                      city,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 45,
                      ),
                    ),
                  ),

                  // weather
                  Center(child: Image.asset("assets/sun.gif")),

                  // temperature
                  SizedBox(
                    height: 50,
                    child: Center(
                      child: Text(temperature, style: TextStyle(fontSize: 18)),
                    ),
                  ),

                  // weather description
                  SizedBox(
                    height: 50,
                    child: Center(
                      child: Text(
                        weatherDescription,
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),

                  // humidity / wind
                  SizedBox(
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [Text(humidity), Text(wind)],
                    ),
                  ),
                ],
              ),
            ),

            // refresh button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: AppButton(
                label: "Tải Lại Trang",
                onPressed: refreshPage,
                icon: Icon(Icons.replay),
                iconColor: Colors.white,
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
