import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news_break/app/controllers/home_controller.dart';
import 'package:news_break/app/controllers/reels/trends_controller.dart';

class SearchPageController extends GetxController {
  final searchController = TextEditingController();
  final filterController = TextEditingController();

  var query = ''.obs;
  var selectedItem = ''.obs;
  var filteredResult = <String>[].obs;
  final RxList<String> trendingItems = <String>[].obs;


  String source = 'home'; // 'home' or 'trends'

  @override
  void onInit() {
    super.onInit();
    loadItems();
    filteredResult.assignAll(trendingItems);

    filterController.addListener(() => _performFilter(filterController.text));
    searchController.addListener(() {
      query.value = searchController.text;
      _performFilter(searchController.text);
    });
  }

  void loadItems() {
    List<String> items = [];

    if (source == 'trends' && Get.isRegistered<TrendsController>()) {
      items = Get.find<TrendsController>().allNews.map((n) => n.title).toList();

    } else if (source == 'home' && Get.isRegistered<HomeController>()) {
      final h = Get.find<HomeController>();
      final tabIndex = h.selectedTabIndex.value;

      final tabNews = switch (tabIndex) {
        0 => h.reactionsNews,
        1 => h.forYouNews,
        2 => h.localNews,
        3 => h.localTvNews,
        4 => h.entertainmentNews,
        5 => h.sportsNews,
        6 => h.foodNews,
        7 => h.healthNews,
        _ => h.forYouNews,
      };

      items = tabNews.map((n) => n.title).toList();
    }

    trendingItems.assignAll(items);
    filteredResult.assignAll(items);
  }

  void _performFilter(String text) {
    if (text.isEmpty) {
      filteredResult.assignAll(trendingItems);
    } else {
      filteredResult.assignAll(
        trendingItems
            .where((item) => item.toLowerCase().contains(text.toLowerCase()))
            .toList(),
      );
    }
  }

  void selectItem(String item) {
    selectedItem.value = item;
    Get.back();

    if (source == 'trends' && Get.isRegistered<TrendsController>()) {
      Get.find<TrendsController>().filterByTopic(item);

    } else if (source == 'home' && Get.isRegistered<HomeController>()) {
      final h = Get.find<HomeController>();
      final tabIndex = h.selectedTabIndex.value;

      final tabNews = switch (tabIndex) {
        0 => h.reactionsNews,
        1 => h.forYouNews,
        2 => h.localNews,
        3 => h.localTvNews,
        4 => h.entertainmentNews,
        5 => h.sportsNews,
        6 => h.foodNews,
        7 => h.healthNews,
        _ => h.forYouNews,
      };

      final filtered = tabNews
          .where((n) => n.title.toLowerCase().contains(item.toLowerCase()))
          .toList();

      tabNews.assignAll(filtered);
    }
  }

  void clearSearch() {
    searchController.clear();
    filterController.clear();
    query.value = '';
    filteredResult.assignAll(trendingItems);
  }

  @override
  void onClose() {
    searchController.dispose();
    filterController.dispose();
    super.onClose();
  }
}