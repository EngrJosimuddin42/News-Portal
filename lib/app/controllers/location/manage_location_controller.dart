import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:news_break/app/controllers/auth/auth_controller.dart';
import 'package:news_break/app/widgets/app_snackbar.dart';
import '../../routes/app_pages.dart';

class ManageLocationController extends GetxController {
  final TextEditingController searchController = TextEditingController();
  final MapController mapController = MapController();

  // Reactive Variables
  var isLocationSelected = false.obs;
  var isDarkMode = Get.isDarkMode.obs;
  var currentMapUrl = ''.obs;

  final LatLng center = const LatLng(24.0, 90.0);


  @override
  void onInit() {
    super.onInit();
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

  // map switch
  void toggleMapStyle() {
    isDarkMode.value = !isDarkMode.value;
    currentMapUrl.value = isDarkMode.value
        ? 'https://cartodb-basemaps-{s}.global.ssl.fastly.net/dark_all/{z}/{x}/{y}.png'
        : 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
  }

  void saveBookmark() {
    final bool loggedIn = AuthController.to.isLoggedIn;
    if (!loggedIn) {
      AppSnackbar.warning(
          title: 'Login Required',
          message: 'Please login to save your favorite locations.'
      );
      Get.toNamed(Routes.SIGNIN);
      return;
    }
    if (isLocationSelected.value) {
      AppSnackbar.success(message: "Location added to your bookmarks");
    } else {
      AppSnackbar.error(message: "Please tap on the map or search a location first.");
    }
  }

  void resetToCurrentLocation() {
    mapController.move(center, 7);
    AppSnackbar.success(message: "Back to center location");
  }

  // Search logic
  void searchLocation() async {
    String address = searchController.text.trim();
    if (address.isEmpty) return;

    try {
      List<Location> locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        LatLng target = LatLng(locations.first.latitude, locations.first.longitude);
        mapController.move(target, 12);
        isLocationSelected.value = true;
        FocusScope.of(Get.context!).unfocus();
      }
    } catch (e) {
      AppSnackbar.error(message: "Location not found. Try: City, Country");
    }
  }
}