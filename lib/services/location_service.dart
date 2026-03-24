import 'dart:io';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationService {
  Future<Position> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // check if GPS is enable
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return Future.error("Dịch vụ định vị đang tắt");

    // check permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      // 2nd denied
      if (permission == LocationPermission.denied) {
        return Future.error("Quyền truy cập vị trí bị từ chối");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
        "Quyền truy cập vị trí bị từ chối vĩnh viễn,vào cài đặt để bật lại",
      );
    }

    // get current position
    try {
      return await Geolocator.getCurrentPosition();
    } catch (e) {
      return Future.error("Không thể lấy vị trí,vui lòng kết nối mạng");
    }
  }

  Future<String?> getDistrictName(double lat, double lon, String locale) async {
    await setLocaleIdentifier(locale);

    try {
      final placemarks = await placemarkFromCoordinates(lat, lon);

      if (placemarks.isNotEmpty) {
        final place = placemarks[0];
        return "${place.subAdministrativeArea != null && place.subAdministrativeArea!.isNotEmpty ? "${place.subAdministrativeArea}," : ""} ${place.administrativeArea}";
      }
      return null;
    } on SocketException {
      return Future.error("Không có kết nối mạng");
    } catch (e) {
      return Future.error("Không thể lấy tên khu vực");
    }
  }
}
