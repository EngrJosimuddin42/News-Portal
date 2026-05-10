import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/help_center_model.dart';

class HelpCenterController extends GetxController {
  final TextEditingController searchController = TextEditingController();

  var displayArticles = <HelpArticle>[].obs;
  var displayCategories = <HelpCategory>[].obs;
  var sections = <Map<String, String>>[].obs;
  var isLoading = true.obs;



  @override
  void onInit() {
    super.onInit();
    displayArticles.assignAll(promotedArticles);
    displayCategories.assignAll(categories);
    fetchHelpSections();
  }

  void runSearch(String query) {
    if (query.isEmpty) {
      displayArticles.assignAll(promotedArticles);
      displayCategories.assignAll(categories);
      fetchHelpSections();
    } else {
      String q = query.toLowerCase();
      displayArticles.assignAll(
        promotedArticles
            .where((a) => a.title.toLowerCase().contains(q))
            .toList());
      displayCategories.assignAll(
        categories
            .where((c) => c.name.toLowerCase().contains(q))
            .toList());
      sections.assignAll(
          sections.where((s) =>
          s['title']!.toLowerCase().contains(q) ||
              s['body']!.toLowerCase().contains(q)
          ).toList()
      );
    }
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  final List<HelpCategory> categories = [
    HelpCategory(name: 'Advertising', isClickable: true),
    HelpCategory(name: 'Publishers', isClickable: true),
    HelpCategory(name: 'Reading News', isClickable: true),
    HelpCategory(name: 'Comments and Notification', isClickable: true),
    HelpCategory(name: 'Account, Profile, and Privacy', isClickable: true),
    HelpCategory(name: 'Contact Us', isClickable: true),
  ];

  final List<HelpArticle> promotedArticles = [
    HelpArticle(title: 'How to create an advertiser account'),
    HelpArticle(title: 'Scale Faster. Reach Higher. Accelerate with Premium Inventory (MSP) this February'),
    HelpArticle(title: 'Premium Partners (MSP) Overview'),
    HelpArticle(title: 'Why is the article not loading?'),
    HelpArticle(title: 'How do I request the removal of an article?'),
    HelpArticle(title: 'How do I contact News Break?'),
  ];

  void fetchHelpSections() async {
    try {
      isLoading.value = true;
      await Future.delayed(const Duration(milliseconds: 500));

      sections.assignAll([
        {
          'title': 'How to get started',
          'body': 'Lorem ipsum dolor sit amet consectetur. Nulla mauris etiam risus at congue. Cursus odio nunc quis congue magna integer enim fringilla.',
        },
        {
          'title': 'Creating a profile',
          'body': 'Lorem ipsum dolor sit amet consectetur. Nulla mauris etiam risus at congue. Cursus odio nunc quis congue magna integer enim fringilla.',
        },
        {
          'title': 'Troubleshooting',
          'body': 'Lorem ipsum dolor sit amet consectetur. Nulla mauris etiam risus at congue. Cursus odio nunc quis congue magna integer enim fringilla.',
        },
        {
          'title': 'App Campaigns',
          'body': 'Lorem ipsum dolor sit amet consectetur. Nulla mauris etiam risus at congue. Cursus odio nunc quis congue magna integer enim fringilla.',
        },
      ]);
    } finally {
      isLoading.value = false;
    }
  }

}