import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:news_break/app/controllers/auth/auth_controller.dart';
import 'package:news_break/app/controllers/home_controller.dart';
import 'package:news_break/app/widgets/app_snackbar.dart';
import '../../routes/app_pages.dart';

class ManageLocationController extends GetxController {
  final TextEditingController searchController = TextEditingController();
  final MapController mapController = MapController();

  var isLocationSelected = false.obs;
  var isDarkMode = false.obs;
  var currentMapUrl = ''.obs;
  var currentLocationName = ''.obs;
  var selectedLatLng = const LatLng(24.0, 90.0);

  final LatLng center = const LatLng(24.0, 90.0);

  @override
  void onInit() {
    super.onInit();
    isDarkMode.value = Get.isDarkMode;
    currentMapUrl.value = isDarkMode.value
        ? 'https://cartodb-basemaps-{s}.global.ssl.fastly.net/dark_all/{z}/{x}/{y}.png'
        : 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
    _checkIncomingArguments();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  void _checkIncomingArguments() {
    var data = Get.arguments;
    if (data != null && data is Map<String, String>) {
      String? city = data['city'];
      Future.delayed(const Duration(milliseconds: 500), () {
        if (city != null) {
          searchController.text = city;
          searchLocation();
        }
      });
    }
  }

  void toggleMapStyle() {
    isDarkMode.value = !isDarkMode.value;
    currentMapUrl.value = isDarkMode.value
        ? 'https://cartodb-basemaps-{s}.global.ssl.fastly.net/dark_all/{z}/{x}/{y}.png'
        : 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
  }


  void onMapTap(LatLng point) async {
    isLocationSelected.value = true;
    selectedLatLng = point;

    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        point.latitude,
        point.longitude,
      );

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        final name = place.locality?.isNotEmpty == true
            ? place.locality!
            : place.administrativeArea?.isNotEmpty == true
            ? place.administrativeArea!
            : place.country ?? 'Unknown';

        currentLocationName.value = name;
        searchController.text = name;
      }
    } catch (e) {

      final fallback =
          '${point.latitude.toStringAsFixed(4)}, ${point.longitude.toStringAsFixed(4)}';
      searchController.text = fallback;
      currentLocationName.value = fallback;
    }
  }

  void saveBookmark() {
    final bool loggedIn = AuthController.to.isLoggedIn;
    if (!loggedIn) {
      AppSnackbar.warning(
        title: 'Login Required',
        message: 'Please login to save your favorite locations.',
      );
      Get.toNamed(Routes.SIGNIN);
      return;
    }

    if (!isLocationSelected.value) {
      AppSnackbar.error(
          message: "Please tap on the map or search a location first.");
      return;
    }


    final String cityName = currentLocationName.value.isNotEmpty
        ? currentLocationName.value
        : searchController.text.trim();

    if (cityName.isEmpty) {
      AppSnackbar.error(message: "Location name could not be determined.");
      return;
    }

    final homeController = Get.find<HomeController>();
    homeController.addFollowedLocation({'city': cityName, 'zip': ''});
  }

  void resetToCurrentLocation() {
    mapController.move(center, 7);
    isLocationSelected.value = false;
    currentLocationName.value = '';
    searchController.clear();
    AppSnackbar.success(message: "Back to center location");
  }


  void searchLocation() async {
    String address = searchController.text.trim();
    if (address.isEmpty) return;

    try {
      List<Location> locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        final target =
        LatLng(locations.first.latitude, locations.first.longitude);
        selectedLatLng = target;
        mapController.move(target, 12);
        isLocationSelected.value = true;


        List<Placemark> placemarks = await placemarkFromCoordinates(
          target.latitude,
          target.longitude,
        );

        if (placemarks.isNotEmpty) {
          final place = placemarks.first;
          final name = place.locality?.isNotEmpty == true
              ? place.locality!
              : place.administrativeArea?.isNotEmpty == true
              ? place.administrativeArea!
              : place.country ?? address;

          currentLocationName.value = name;
          searchController.text = name;
        }

        FocusScope.of(Get.context!).unfocus();
      }
    } catch (e) {
      AppSnackbar.error(message: "Location not found. Try: City, Country");
    }
  }
}