import 'package:get/get.dart';

class DiscoverAppController extends GetxController {
  var appsList = <Map<String, String>>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchDiscoverApps();
  }

  void fetchDiscoverApps() async {
    try {
      isLoading.value = true;
      await Future.delayed(const Duration(seconds: 1));

      appsList.assignAll([
        {
          'name': 'WeatherNow',
          'subtitle': 'Live radar & storm alerts',
          'imageUrl': 'https://images.unsplash.com/photo-1592210454359-9043f067919b?w=200',
        },
        {
          'name': 'TrafficWatch',
          'subtitle': 'Real-time road conditions',
          'imageUrl': 'https://images.unsplash.com/photo-1545147986-a9d6f210df77?w=200',
        },
        {
          'name': 'EcoAlert',
          'subtitle': 'Air quality & pollution index',
          'imageUrl': 'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?w=200',
        },
        {
          'name': 'EmergencyPlus',
          'subtitle': 'Quick access to emergency help',
          'imageUrl': 'https://images.unsplash.com/photo-1587393820429-aa214cf0ede3?w=200',
        },
        {
          'name': 'CityEvents',
          'subtitle': 'Local events & festivals',
          'imageUrl': 'https://images.unsplash.com/photo-1492684223066-81342ee5ff30?w=200',
        },
      ]);
    } finally {
      isLoading.value = false;
    }
  }
}