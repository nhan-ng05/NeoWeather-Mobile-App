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
    return await Geolocator.getCurrentPosition();
  }

  Future<String?> getDistrictName(double lat, double lon) async {
    await setLocaleIdentifier('vi_VN');

    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lon);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];

        // subAdministrativeArea = Thành Phố ,administrativeArea = Quốc Gia
        return "${place.subAdministrativeArea != null && place.subAdministrativeArea!.isNotEmpty ? "${place.subAdministrativeArea}," : ""} ${place.administrativeArea}";
      }
    } catch (e) {
      print("Lỗi $e");
    }
    return null;
  }
}
