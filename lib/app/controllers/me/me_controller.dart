import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news_break/app/theme/app_colors.dart';
import 'package:news_break/app/theme/app_text_styles.dart';
import '../../models/history_model.dart';
import '../../modules/me/settings/settings_view.dart';
import '../auth/auth_controller.dart';
import '../../modules/ai/nbot_sheet.dart';
import '../../modules/me/creator_dashboard_view.dart';
import '../../modules/me/creator_onboard_view.dart';
import '../../modules/me/edit_profile_view.dart';
import '../reels/reels_controller.dart';

class MeController extends GetxController {


  // Check From AuthController
  bool get isLoggedIn => AuthController.to.user.value != null;

  String get userName => AuthController.to.user.value?.name ?? '';

  String get userEmail => AuthController.to.user.value?.email ?? '';

  var selectedChipIndex = 0.obs;
  var selectedContentChipIndex = 0.obs;
  var currentLabel = 'Last 7 days'.obs;
  var currentDateRange = 'Mar 25 - Mar 31'.obs;
  var selectedDashboardTab = 0.obs;

  final selectedTab = 0.obs;
  final hasHistory = true.obs;
  final isCreator = false.obs;
  final loggedInTabs = ['Content', 'Reactions', 'Saved', 'History'];
  final loggedOutTabs = ['Saved', 'History'];
  final ReelsController _reelsController = Get.find<ReelsController>();


  void updateChip(int index) => selectedChipIndex.value = index;

  void updateContentChip(int index) => selectedContentChipIndex.value = index;

  void onBecomeCreator() => Get.to(() => const CreatorOnboardView());

  void onCreatorDashboard() => Get.to(() => const CreatorDashboardView());

  void onCompleteProfile() => Get.to(() => const EditProfileView());

  void onLogin() => Get.toNamed('/signin');

  void onLogout() => AuthController.to.logout();

  void onSettings() => Get.to(() => const SettingsView());

  void deleteSingleHistoryItem(String id) {
    historyItems.removeWhere((item) => item.id == id);
    if (historyItems.isEmpty) hasHistory.value = false;
  }

  void clearFullHistory() {
    historyItems.clear();
    hasHistory.value = false;
  }

  void completeOnboarding() {
    isCreator.value = true;
    selectedTab.value = 0;
    update();
  }

  bool get isProfileComplete {
    final user = AuthController.to.user.value;
    if (user != null) {
      return (user.name.isNotEmpty ) &&
          (user.username?.isNotEmpty ?? false) &&
          (user.email.isNotEmpty ) &&
          (user.bio?.isNotEmpty ?? false) &&
          (user.website?.isNotEmpty ?? false) &&
          (user.birthYear?.isNotEmpty ?? false) &&
          (user.gender?.isNotEmpty ?? false);
    }
    return false;
  }


  void selectStat(int index, bool isEngagement) {
    if (isEngagement) {
      for (var i = 0; i < engagementStats.length; i++) {
        engagementStats[i]['isSelected'] = (i == index);
      }
      engagementStats.refresh();
    } else {
      for (var i = 0; i < followerStats.length; i++) {
        followerStats[i]['isSelected'] = (i == index);
      }
      followerStats.refresh();
    }
  }

  void updateDateRange(String label, String sub) {
    currentLabel.value = label;
    currentDateRange.value = sub;
  }

  void onAI() {
    showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const NBotSheet(),
    );
  }

  List<String> get tabs {
    if (!isLoggedIn) return loggedOutTabs;
    if (isCreator.value) {
      return loggedInTabs;
    } else {
      return loggedInTabs.where((tab) => tab != 'Content').toList();
    }
  }

  List get savedReelsData => _reelsController.reelsList
      .where((reel) => _reelsController.savedReels.contains(reel.id))
      .toList();

  void onClearAll(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) =>
          AlertDialog(
            backgroundColor:AppColors.search,
            title: Text('Clear history?', style: AppTextStyles.caption.copyWith(color: AppColors.white)),
            content: Text( 'Are you sure you want to clear your browsing history? This action cannot be undone.',
                style: AppTextStyles.caption.copyWith(color: AppColors.white)),
            actions: [
              TextButton(
                onPressed: () => Get.back(),
                child: Text('Cancel', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.white))),
              TextButton(
                onPressed: () {
                  clearFullHistory();
                  Get.back();
                },
                child: Text('Clear', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.white)),
              ),
            ],
          ),
    );
  }

  final List<Map<String, String>> dateRanges = [
    {'label': 'Last 7 days', 'sub': 'Mar 25 - Mar 31'},
    {'label': 'Last 28 days', 'sub': 'Mar 4 - Mar 31'},
    {'label': 'Last 60 days', 'sub': 'Jan 31 - Mar 31'},
  ];

  var engagementStats = <Map<String, dynamic>>[
    {'label': 'Impressions', 'value': '12.5K', 'percent': '2.4%', 'isSelected': true},
    {'label': 'Likes', 'value': '850', 'percent': '1.2%', 'isSelected': false},
  ].obs;

  var followerStats = <Map<String, dynamic>>[
    {'label': 'Total Followers', 'value': '1,250', 'percent': '5.0%', 'isSelected': true},
    {'label': 'Followers', 'value': '45', 'percent': '0.5%', 'isSelected': false},
  ].obs;

  var historyItems = <HistoryModel>[
    HistoryModel(
      id: '101',
      title: 'FCC chair threatens over Iran war coverage',
      subtitle: 'For seven long years, he served without ever asking for anything in... ',
      source: 'USA TODAY',
      timeAgo: '9hr',
      videoUrl: 'https://www.w3schools.com/html/mov_bbb.mp4',
      thumbnailUrl: 'https://images.unsplash.com/photo-1677442136019-21780ecad995?w=400',
    ),
    HistoryModel(
      id: '102',
      title: 'The future of Artificial Intelligence in 2026: What to expect',
      subtitle: 'For seven long years, he served without ever asking for anything in... ',
      source: 'TechRadar',
      timeAgo: '5h',
      videoUrl: 'https://interactive-examples.mdn.mozilla.net/media/cc0-videos/flower.mp4',
      thumbnailUrl: 'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?w=400',
    ),
    HistoryModel(
      id: '103',
      title: 'SpaceX Starship mission reaches new milestone in Mars journey',
      subtitle: 'For seven long years, he served without ever asking for anything in... ',
      source: 'SpaceNews',
      timeAgo: '12h',
      videoUrl: 'https://www.w3schools.com/html/movie.mp4',
      thumbnailUrl: 'https://images.unsplash.com/photo-1517976487492-5750f3195933?w=400',
    ),
  ].obs;

  var onboardSlides = <Map<String, String>>[
    {
      'imageUrl': 'https://images.unsplash.com/photo-1504703395950-b89145a5425b?w=800',
      'title': 'Read Real News',
      'subtitle': 'Lorem ipsum dolor sit amet consectetur. Tempus consectetur placerat facilisis sed diam malesuada libero interdum. Elit nulla non sit et cursus.',
      'likes': '2.5k',
      'comments': '1.2k',
      'followers': '1.3k',
    },
    {
      'imageUrl': 'https://images.unsplash.com/photo-1540575467063-178a50c2df87?w=800',
      'title': 'Be a Voice',
      'subtitle': 'Lorem ipsum dolor sit amet consectetur. Tempus consectetur placerat facilisis sed diam malesuada libero interdum. Elit nulla non sit et cursus.',
      'likes': '2.5k',
      'comments': '1.2k',
      'followers': '1.3k',
    },
    {
      'imageUrl': 'https://images.unsplash.com/photo-1516321497487-e288fb19713f?w=800',
      'title': 'Capture Moments',
      'subtitle': 'Lorem ipsum dolor sit amet consectetur. Tempus consectetur placerat facilisis sed diam malesuada libero interdum. Elit nulla non sit et cursus.',
      'likes': '2.5k',
      'comments': '1.2k',
      'followers': '1.3k',
    },
  ].obs;
}