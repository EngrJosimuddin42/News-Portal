import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news_break/app/controllers/search_page_controller.dart';
import 'package:news_break/app/theme/app_assets.dart';
import 'package:news_break/app/widgets/app_snackbar.dart';
import '../models/comment_model.dart';
import '../models/news_model.dart';
import '../models/reel_model.dart';
import 'auth/auth_controller.dart';
import '../routes/app_pages.dart';
import '../modules/ai/nbot_sheet.dart';
import '../modules/location/choose_location_sheet.dart';
import '../modules/location/manage_location_view.dart';
import '../modules/search/search_page_view.dart';
import 'me/settings/settings_controller.dart';

class HomeController extends GetxController {

  // Tab & Navigation State
  final RxList<String> tabs = <String>['reactions', 'for_you', 'local', 'local_tv', 'entertainment', 'sports', 'food', 'health'].obs;
  final RxInt selectedTabIndex = 1.obs;
  final RxInt selectedNavIndex = 0.obs;

  //  Weather State
  var isLoading = false.obs;
  var isHourly = true.obs;
  var currentTemp = "44°F".obs;
  var weatherCondition = "Cloudy".obs;
  var rainProbability = "71%".obs;
  var weatherIcon =AppAssets.cloudyIcon.obs;
  var lowHighTemp = "30°/40°".obs;
  var sunriseTime = "4:48 AM ".obs;
  var sunsetTime = "5:48 PM".obs;
  var chartData = <double>[0.06, 0.02, 0.04, 0.03, 0.08, 0.02, 0.05].obs;
  final RxList<double> rainBarData = [0.06, 0.02, 0.04, 0.03, 0.08, 0.02, 0.05].obs;
  final selectedDayIndex = (DateTime.now().weekday % 7).obs;
  final currentDate = DateTime.now().obs;

// Location State
  final selectedLocation = Rxn<Map<String, String>>();
  final tempLocation = Rxn<Map<String, String>>();
  var isLocationLoading = false.obs;
  var currentAddress = "".obs;
  String get locationTitle => selectedLocation.value?['city'] ?? 'choose_location'.tr;
  var followedLocations = <Map<String, String>>[].obs;

// Search & UI State
  final TextEditingController searchController = TextEditingController();
  var isSearching = false.obs;
  var searchQuery = "".obs;
  var showAd = true.obs;

  // Lists & Comments
  final RxList<CommentModel> commentsList = <CommentModel>[].obs;
  final RxBool isCommentsLoading = false.obs;
  RxList<ReelModel> customReelsForNavigation = <ReelModel>[].obs;
  RxInt customReelsInitialIndex = 0.obs;


  // Auth check
  bool get isLoggedIn => AuthController.to.user.value != null;
  String get userName => AuthController.to.user.value?.name ?? '';

  String get monthAndDay {
    const monthsEn = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    const monthsBn = ['জানু', 'ফেব্রু', 'মার্চ', 'এপ্রিল', 'মে', 'জুন', 'জুলাই', 'আগস্ট', 'সেপ্টে', 'অক্টো', 'নভে', 'ডিসে'];

    final int monthIndex = currentDate.value.month - 1;
    final int day = currentDate.value.day;
    final bool isBengali = SettingsController.to.selectedLanguage.value == 'Bangla';

    if (isBengali) {
      final String bengaliDay = _toBengaliNumber(day.toString());
      return '${monthsBn[monthIndex]} $bengaliDay';
    } else {
      return '${monthsEn[monthIndex]} $day';
    }
  }

  String _toBengaliNumber(String input) {
    const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const bengali = ['০', '১', '২', '৩', '৪', '৫', '৬', '৭', '৮', '৯'];

    for (int i = 0; i < 10; i++) {
      input = input.replaceAll(english[i], bengali[i]);
    }
    return input;
  }

  @override
  void onInit() {
    super.onInit();
    fetchWeatherData();
  }

  Future<void> fetchWeatherData() async {
    try {
      isLoading.value = true;
      await Future.delayed(const Duration(seconds: 1));
      String apiCondition = "Rainy";
      currentTemp.value = "28°C";
      rainProbability.value = "71%";
      lowHighTemp.value = "25°/30°";
      updateWeatherIcon(apiCondition);
      chartData.value = [0.05, 0.08, 0.03, 0.09, 0.04, 0.07, 0.02];
    } catch (e) {
      debugPrint("Weather fetch error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> onRefresh() async {
    await fetchWeatherData();
    await detectGPSLocation();
  }


  void toggleHourlyView(bool value) {
    isHourly.value = value;
    chartData.value = value
        ? [0.06, 0.02, 0.04, 0.03, 0.08, 0.02, 0.05]
        : [0.09, 0.05, 0.07, 0.02, 0.06, 0.08, 0.04];
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  void cancelSearch() {
    searchController.clear();
    searchQuery.value = '';
    isSearching.value = false;
  }

  void clearSearch() {
    searchController.clear();
    searchQuery.value = "";
    isSearching.value = false;
  }

  void onTryAgain() {}

  void selectDay(int index) { selectedDayIndex.value = index;}

  void onNavTap(int index) { selectedNavIndex.value = index;}

  void onTabTap(int index) { selectedTabIndex.value = index;}

  void onEditTabs() => Get.toNamed(Routes.EDIT_TABS, arguments: tabs);

  void onManageLocation() { Get.to(() => const ManageLocationView());}

  void onSearchTap() => isSearching.value = true;

  void setLocation(Map<String, String> location) { selectedLocation.value = location;}

  void onSearchChanged(String val) { searchQuery.value = val;}

  void onSearch() {
    Get.delete<SearchPageController>(force: true);
    final ctrl = Get.put(SearchPageController());
    ctrl.source = 'home';
    ctrl.loadItems();
    Get.to(() => const SearchPageView());
  }

  void confirmLocationSelection() {
    if (tempLocation.value != null) {
      selectedLocation.value = tempLocation.value;
    }
  }

  void selectLocationFromSearch(Map<String, String> loc) {
    tempLocation.value = loc;
    selectedLocation.value = loc;
    cancelSearch();
  }

  void onCreatePost() {
    if (isLoggedIn) {
      Get.toNamed(Routes.CREATE_POST);
    } else {
      Get.toNamed(Routes.SIGNIN);
    }
  }

  void onAI() {
    showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(Get.context!).size.width,
        maxHeight: MediaQuery.of(Get.context!).size.height * 0.84,
      ),
      builder: (_) => const NBotSheet(),
    );
  }

  void onChooseLocation() {
    Get.bottomSheet(
      const ChooseLocationSheet(),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      settings: const RouteSettings(arguments: {'isFromSettings': false}),
    );
  }

  void hideNews(NewsModel news) {
    reactionsNews.remove(news);
    forYouNews.remove(news);
    localNews.remove(news);
    localTvNews.remove(news);
    entertainmentNews.remove(news);
    sportsNews.remove(news);
    foodNews.remove(news);
    healthNews.remove(news);
    beautyNews.remove(news);
    weatherNews.remove(news);
    update();
    AppSnackbar.success(message: 'News hidden from your feed');}


  Future<void> detectGPSLocation() async {
    try {
      isLocationLoading.value = true;
      await Future.delayed(const Duration(seconds: 2));
      Map<String, String> detectedLoc = { 'city': 'Dhaka, Bangladesh', 'zip': '1212'};
      setLocation(detectedLoc);

      AppSnackbar.success(message: "Location updated via GPS");
    } catch (e) {
      AppSnackbar.error(message: "Could not fetch location");
    } finally {
      isLocationLoading.value = false;
    }
  }


  List<Map<String, String>> get filteredLocations {
    if (searchQuery.value.isEmpty) return [];
    return allLocations.where((loc) {
      final city = loc['city']!.toLowerCase();
      final zip = loc['zip']!.toLowerCase();
      final query = searchQuery.value.toLowerCase();
      return city.contains(query) || zip.contains(query);
    }).toList();
  }

  void addFollowedLocation(Map<String, String> loc) {
    bool exists = followedLocations.any((l) => l['city'] == loc['city']);
    if (!exists) {
      followedLocations.add(loc);
      AppSnackbar.success(message: "${loc['city']} added to followed locations");
    } else {
      AppSnackbar.warning(title: 'Already Added', message: "${loc['city']} is already in your list");
    }
  }

  void addUserPost({
    required String text,    String? imageUrl,
    String? location,
    String? videoUrl,
    bool isReel = false,
  }) {
    final user = AuthController.to.user.value;

    final postLocation = location?.isNotEmpty == true
        ? location!
        : (user?.location?.isNotEmpty == true ? user!.location! : '');

    final newNews = NewsModel(
      id: DateTime.now().millisecondsSinceEpoch,
      category: isReel ? 'Reel' : 'General',
      title: text,
      author: user?.name ?? 'Me',
      publisherName: user?.name ?? 'Me',
      publisherMeta: postLocation,
      timeAgo: 'Just now',
      imageUrl: imageUrl ?? '',
      videoUrl: videoUrl,
      body: text,
      publisherImageUrl: user?.profileImageUrl ?? '',
    );

    reactionsNews.insert(0, newNews);
    forYouNews.insert(0, newNews);

    update();
  }


  // Weather Condition Mapper Function

  void updateWeatherIcon(String condition) {
    weatherCondition.value = condition;

    switch (condition.toLowerCase()) {
      case 'cloudy': weatherIcon.value = AppAssets.cloudyIcon; break;
      case 'rainy': weatherIcon.value = AppAssets.rainyIcon; break;
      case 'sunny':
      case 'clear': weatherIcon.value = AppAssets.sunnyIcon; break;
      case 'storm': weatherIcon.value = AppAssets.stormIcon; break;
      default: weatherIcon.value = AppAssets.cloudyIcon;
    }
  }

  // Reactions Tab
  final RxList<NewsModel> reactionsNews = <NewsModel>[
    NewsModel(
      id: 101,
      publisherName: 'shefinds',
      publisherImageUrl: 'https://images.unsplash.com/photo-1587300003388-59208cc962cb?w=800',
      publisherMeta: 'Beverly Hills,CA',
      timeAgo: '6 days ago',
      title: "For seven long years, he served without ever asking for anything in return. His name is Sergeant Diesel...",
      imageUrl: 'https://images.unsplash.com/photo-1470071459604-3b5ec3a7fe05?w=400',
      category: 'Pets & Animals',
      author: 'Staff',
      imageCaption: 'Joe sussman / Shutterstock.com',
      body: 'Lorem ipsum dolor sit amet consectetur. Fames quisque feugiat fermentum dictum nulla netus cras pellentesque. ',
      secondaryImageUrl: 'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=800',
      secondarySubtitle: 'Reach more than 40 million users across the U.S. and engage with your target audience at the right moment.',
      likes: '12',
      comments: '8',
      shares: '1.5K',
      reactions: '1.4K',
      isVerified: true,
    ),
    NewsModel(
      id: 999999,
      publisherName: 'Bingo Fun',
      publisherImageUrl: 'https://images.unsplash.com/photo-1587300003388-59208cc962cb?w=800',
      publisherMeta: 'Sponsored',
      publisherType: 'Ad',
      totalFollowers: '1.2M',
      timeAgo: 'Now',
      title: "Bingo Fun Ad - Play and Win exciting prizes today!",
      imageUrl: 'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?w=800',
      category: 'Promotion',
      author: 'Bingo Team',
      body: 'This is an advertisement content...',
      likes: '10K',
      comments: '500',
      shares: '2K',
      reactions: '5.4K',
      isVerified: true,
      videoUrl: 'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
    ),
    NewsModel(
      id: 102,
      publisherName: 'ESPN',
      publisherMeta: 'Partner publisher · New York, NY',
      timeAgo: '3h',
      title: "NBA Playoffs: Underdog Team Clinches Surprising Victory...",
      imageUrl: 'https://images.unsplash.com/photo-1546519638-68e109498ffc?w=800',
      category: 'Sports',
      body: 'Full content here...',
      likes: '5.4K',
      comments: '2.3K',
      shares: '1.5K',
      reactions: '0',
      author: 'Sports Desk',
      videoUrl: 'https://www.learningcontainer.com/wp-content/uploads/2020/05/sample-mp4-file.mp4',
      isVerified: true,
    ),
    NewsModel(
      id: 103,
      publisherName: 'BBC News',
      publisherMeta: 'Partner publisher · London, UK',
      timeAgo: '1d',
      title: "World Leaders Gather for Emergency Climate Summit...",
      imageUrl: 'https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=400',
      category: 'World',
      body: 'Full content here...',
      likes: '7.5K',
      comments: '2.3K',
      shares: '1.5K',
      reactions: '5.2K',
      author: 'Global Team',
      isVerified: true,
    ),
    NewsModel(
      id: 104,
      publisherName: 'TechCrunch',
      publisherMeta: 'Partner publisher · San Francisco, CA',
      timeAgo: '5h',
      title: "Apple Announces Revolutionary AI Features Coming to iPhone...",
      imageUrl: 'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=800',
      category: 'Technology',
      body: 'Full content here...',
      likes: '3.2K',
      comments: '2.3K',
      shares: '1.5K',
      reactions: '2.8K',
      author: 'Tech Desk',
      isVerified: true,
    ),
  ].obs;


  // For You News List
  final RxList<NewsModel> forYouNews = <NewsModel>[
    NewsModel(
      id: 101,
      publisherName: 'shefinds',
      publisherType: 'Partner publisher.',
      publisherMeta: 'Beverly Hills, CA',
      totalFollowers: '500',
      imageUrl: 'https://images.unsplash.com/photo-1495020689067-958852a7765e?w=800',
      category: 'OPINION',
      author: 'Staff',
      timeAgo: '19h',
      title: 'Best Concert In The Town',
      subtitle: "'The View' Fans Think Whoopi Goldberg Has 'Lost Her Mind'...",
      imageCaption: 'Joe sussman / Shutterstock.com',
      body: 'Lorem ipsum dolor sit amet consectetur. Fames quisque feugiat fermentum dictum nulla netus cras pellentesque. ',
      secondaryImageUrl: 'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=800',
      secondarySubtitle: 'Reach more than 40 million users across the U.S. and engage with your target audience at the right moment.',
      reactions: '25',
      likes: '14',
      comments: '4',
    ),
    NewsModel(
      id: 999999,
      publisherName: 'Bingo Fun',
      publisherImageUrl: 'https://images.unsplash.com/photo-1587300003388-59208cc962cb?w=800',
      publisherMeta: 'Sponsored',
      publisherType: 'Ad',
      totalFollowers: '1.2M',
      timeAgo: 'Now',
      title: "Bingo Fun Ad - Play and Win exciting prizes today!",
      imageUrl: 'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?w=800',
      category: 'Promotion',
      author: 'Bingo Team',
      body: 'This is an advertisement content...',
      likes: '10K',
      comments: '500',
      shares: '2K',
      reactions: '5.4K',
      isVerified: true,
      videoUrl: 'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
    ),
    NewsModel(
      id: 102,
      publisherName: 'Variety',
      publisherType: 'Partner publisher.',
      publisherMeta: 'Beverly Hills, CA',
      totalFollowers: '1.2M',
      imageUrl: 'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?w=800',
      category: 'ENTERTAINMENT',
      author: 'Staff',
      timeAgo: '3h',
      title: 'Best Concert In The Town',
      subtitle: 'Grammy-Winning Artist Announces Surprise Album Drop and World Tour Starting Next Month',
      body: 'Full news content here...',
      reactions: '3.4K',
      likes: '5.6K',
      comments: '2.2K',
    ),
    NewsModel(
      id: 103,
      publisherName: 'ESPN',
      publisherType: 'Partner publisher.',
      publisherMeta: 'Los Angeles, CA',
      totalFollowers: '5.1M',
      imageUrl: 'https://images.unsplash.com/photo-1546519638-68e109498ffc?w=800',
      category: 'SPORTS',
      timeAgo: '6h',
      title: 'Best Concert In The Town',
      author: 'Entertainment Desk',
      subtitle: 'NBA Playoffs: Underdog Team Clinches Surprising Victory in Game 7 Overtime Thriller',
      body: 'Full news content here...',
      reactions: '8.9K',
      likes: '12.4K',
      comments: '7.8K',
    ),
    NewsModel(
      id: 104,
      publisherName: 'Healthline',
      publisherType: 'Partner publisher.',
      publisherMeta: 'New York, NY',
      totalFollowers: '2.7M',
      imageUrl: 'https://images.unsplash.com/photo-1476480862126-209bfaa8edc8?w=800',
      category: 'HEALTH',
      author: 'Sports Desk',
      timeAgo: '9h',
      title: 'Best Concert In The Town',
      subtitle: 'New Study Reveals the Surprising Link Between Sleep Quality and Long-Term Cardiovascular Health',
      body: 'Full news content here...',
      reactions: '4.3K',
      likes: '7.2K',
      comments: '3.1K',
    ),
  ].obs;

  // Local Clips List
  final RxList<ReelModel> forYouClips = <ReelModel>[
    ReelModel(
      id: 3,
      imageUrl: 'https://images.unsplash.com/photo-1677442136019-21780ecad995?w=400',
      videoUrl: 'https://media.w3.org/2010/05/sintel/trailer.mp4',
      userProfileImage: 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=200',
      userName: 'Play Time',
      description: 'Love for animals',
      source: '3month',
      location: 'Chicago, USA',
      userSince: 'Mar 2026',
      totalPosts: '45',
      totalViews: '12k',
      totalFollowers: '1.5k',
      likes: 2500,
      comments: 3500,
      shares: 1200,
      isFollowing: false,
      isLiked: false,
      userVideos: [
        {'id': 'v1','imageUrl': 'https://images.unsplash.com/photo-1517694712202-14dd9538aa97?w=400','videoUrl': 'https://www.w3schools.com/html/mov_bbb.mp4', 'title': 'Coding Life', 'views': '2.5k'},
        {'id': 'v2','imageUrl': 'https://images.unsplash.com/photo-1501785888041-af3ef285b470?w=400','videoUrl': 'https://interactive-examples.mdn.mozilla.net/media/cc0-videos/flower.mp4', 'title': 'Beautiful Nature', 'views': '1.1k'},
        {'id': 'v3','imageUrl': 'https://images.unsplash.com/photo-1470071459604-3b5ec3a7fe05?w=400','videoUrl': 'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4', 'title': 'Morning Walk', 'views': '850'},
        {'id': 'v4','imageUrl': 'https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=400','videoUrl': 'https://media.w3.org/2010/05/sintel/trailer.mp4', 'title': 'Forest Adventure', 'views': '3.2k'},
      ],
      userReactions: [
        {'id': 'r1','imageUrl': 'https://images.unsplash.com/photo-1498050108023-c5249f4df085?w=200','videoUrl': 'https://www.w3schools.com/html/movie.mp4', 'title': 'Laptop Review', 'time': 'Tuesday 11:30 AM'},
        {'id': 'r2','imageUrl': 'https://images.unsplash.com/photo-1511379938547-c1f69419868d?w=200','videoUrl': 'https://media.w3.org/2010/05/sintel/trailer.mp4', 'title': 'Music Studio', 'time': 'Wednesday 8:00 PM'},
        {'id': 'r3','imageUrl': 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=200','videoUrl': 'https://interactive-examples.mdn.mozilla.net/media/cc0-videos/flower.mp4', 'title': 'Profile Portrait', 'time': 'Thursday 4:15 PM'},
        {'id': 'r4','imageUrl': 'https://images.unsplash.com/photo-1461749280684-dccba630e2f6?w=200','videoUrl': 'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4', 'title': 'Web Development', 'time': 'Monday 9:05 AM'},
      ],
    ),
    ReelModel(
      id: 4,
      imageUrl: 'https://images.unsplash.com/photo-1477959858617-67f85cf4f1df?w=400',
      videoUrl: 'https://interactive-examples.mdn.mozilla.net/media/cc0-videos/flower.mp4',
      userProfileImage: 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=200',
      userName: 'City Life',
      description: 'Urban stories',
      source: '3month',
      location: 'Chicago, USA',
      userSince: 'Mar 2026',
      totalPosts: '45',
      totalViews: '12k',
      totalFollowers: '1.5k',
      likes: 2500,
      comments: 3500,
      shares: 1200,
      isFollowing: false,
      isLiked: false,
      userVideos: [
        {'id': 'v1','imageUrl': 'https://images.unsplash.com/photo-1517694712202-14dd9538aa97?w=400','videoUrl': 'https://www.w3schools.com/html/mov_bbb.mp4', 'title': 'Coding Life', 'views': '2.5k'},
        {'id': 'v2','imageUrl': 'https://images.unsplash.com/photo-1501785888041-af3ef285b470?w=400','videoUrl': 'https://interactive-examples.mdn.mozilla.net/media/cc0-videos/flower.mp4', 'title': 'Beautiful Nature', 'views': '1.1k'},
        {'id': 'v3','imageUrl': 'https://images.unsplash.com/photo-1470071459604-3b5ec3a7fe05?w=400','videoUrl': 'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4', 'title': 'Morning Walk', 'views': '850'},
        {'id': 'v4','imageUrl': 'https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=400','videoUrl': 'https://media.w3.org/2010/05/sintel/trailer.mp4', 'title': 'Forest Adventure', 'views': '3.2k'},
      ],
      userReactions: [
        {'id': 'r1','imageUrl': 'https://images.unsplash.com/photo-1498050108023-c5249f4df085?w=200','videoUrl': 'https://www.w3schools.com/html/movie.mp4', 'title': 'Laptop Review', 'time': 'Tuesday 11:30 AM'},
        {'id': 'r2','imageUrl': 'https://images.unsplash.com/photo-1511379938547-c1f69419868d?w=200','videoUrl': 'https://media.w3.org/2010/05/sintel/trailer.mp4', 'title': 'Music Studio', 'time': 'Wednesday 8:00 PM'},
        {'id': 'r3','imageUrl': 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=200','videoUrl': 'https://interactive-examples.mdn.mozilla.net/media/cc0-videos/flower.mp4', 'title': 'Profile Portrait', 'time': 'Thursday 4:15 PM'},
        {'id': 'r4','imageUrl': 'https://images.unsplash.com/photo-1461749280684-dccba630e2f6?w=200','videoUrl': 'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4', 'title': 'Web Development', 'time': 'Monday 9:05 AM'},
      ],
    ),
    ReelModel(
      id: 5,
      imageUrl: 'https://images.unsplash.com/photo-1448375240586-882707db888b?w=400',
      videoUrl: 'https://www.w3schools.com/html/movie.mp4',
      userProfileImage: 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=200',
      userName: 'Nature Walk',
      description: 'Explore outdoors',
      source: '3month',
      location: 'Chicago, USA',
      userSince: 'Mar 2026',
      totalPosts: '45',
      totalViews: '12k',
      totalFollowers: '1.5k',
      likes: 2500,
      comments: 3500,
      shares: 1200,
      isFollowing: false,
      isLiked: false,
      userVideos: [
        {'id': 'v1','imageUrl': 'https://images.unsplash.com/photo-1517694712202-14dd9538aa97?w=400','videoUrl': 'https://www.w3schools.com/html/mov_bbb.mp4', 'title': 'Coding Life', 'views': '2.5k'},
        {'id': 'v2','imageUrl': 'https://images.unsplash.com/photo-1501785888041-af3ef285b470?w=400','videoUrl': 'https://interactive-examples.mdn.mozilla.net/media/cc0-videos/flower.mp4', 'title': 'Beautiful Nature', 'views': '1.1k'},
        {'id': 'v3','imageUrl': 'https://images.unsplash.com/photo-1470071459604-3b5ec3a7fe05?w=400','videoUrl': 'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4', 'title': 'Morning Walk', 'views': '850'},
        {'id': 'v4','imageUrl': 'https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=400','videoUrl': 'https://media.w3.org/2010/05/sintel/trailer.mp4', 'title': 'Forest Adventure', 'views': '3.2k'},
      ],
      userReactions: [
        {'id': 'r1','imageUrl': 'https://images.unsplash.com/photo-1498050108023-c5249f4df085?w=200','videoUrl': 'https://www.w3schools.com/html/movie.mp4', 'title': 'Laptop Review', 'time': 'Tuesday 11:30 AM'},
        {'id': 'r2','imageUrl': 'https://images.unsplash.com/photo-1511379938547-c1f69419868d?w=200','videoUrl': 'https://media.w3.org/2010/05/sintel/trailer.mp4', 'title': 'Music Studio', 'time': 'Wednesday 8:00 PM'},
        {'id': 'r3','imageUrl': 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=200','videoUrl': 'https://interactive-examples.mdn.mozilla.net/media/cc0-videos/flower.mp4', 'title': 'Profile Portrait', 'time': 'Thursday 4:15 PM'},
        {'id': 'r4','imageUrl': 'https://images.unsplash.com/photo-1461749280684-dccba630e2f6?w=200','videoUrl': 'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4', 'title': 'Web Development', 'time': 'Monday 9:05 AM'},
      ],
    ),
  ].obs;


  // Local Tab
  final RxList<NewsModel> localNews = <NewsModel>[
    NewsModel(
      id: 101,
      publisherName: 'Daily news',
      publisherImageUrl: 'https://images.unsplash.com/photo-1546519638-68e109498ffc?w=800',
      publisherType: 'BBC publisher',
      publisherMeta: 'UnitedKingdom, ARMY',
      totalFollowers: '833.3K',
      imageUrl: 'https://images.unsplash.com/photo-1588681664899-f142ff2dc9b1?w=800',
      category: 'New York',
      author: 'Local Desk',
      timeAgo: '19h',
      title: 'Best Concert In The Town',
      subtitle: "'The View' Fans Think Whoopi Goldberg Has 'Lost Her Mind' After She Suggests Donald Trump's Iran War Is A Distraction From Nancy Guthrie...",
      body: 'Full news content here...',
      videoUrl: 'https://www.learningcontainer.com/wp-content/uploads/2020/05/sample-mp4-file.mp4',
      reactions: '11',
      likes: '18',
      comments: '4',
      isVerified: true,
    ),
    NewsModel(
      id: 102,
      publisherName: 'Daily news',
      publisherImageUrl: 'https://images.unsplash.com/photo-1546519638-68e109498ffc?w=800',
      publisherType: 'Partner publisher',
      publisherMeta: 'New York, NY',
      totalFollowers: '833.3K',
      imageUrl: 'https://images.unsplash.com/photo-1557804506-669a67965ba0?w=800',
      category: 'New York',
      author: 'News Team',
      timeAgo: '2h',
      title: 'Best Concert In The Town',
      subtitle: 'Local TV Coverage: Major Event Unfolds Across the City as Thousands Gather for Historic Moment',
      body: 'Full news content here...',
      reactions: '2.1K',
      likes: '3.4K',
      comments: '1.8K',
      isVerified: true,
    ),
  ].obs;


  // Local Tv Tab
  final RxList<NewsModel> localTvNews = <NewsModel>[
    NewsModel(
      id: 101,
      publisherName: 'Daily news',
      publisherType: 'Partner publisher',
      publisherMeta: 'New York, NY',
      totalFollowers: '833.3K',
      imageUrl: 'https://images.unsplash.com/photo-1585829365295-ab7cd400c167?w=800',
      category: 'New York',
      author: 'Local Desk',
      timeAgo: '19h',
      title: 'Best Concert In The Town',
      subtitle: "'The View' Fans Think Whoopi Goldberg Has 'Lost Her Mind' After She Suggests Donald Trump's Iran War Is A Distraction From Nancy Guthrie...",
      body: 'News detail content here...',
      reactions: '7',
      likes: '35',
      comments: '13',
      isVerified: true,
    ),
    NewsModel(
      id: 102,
      publisherName: 'Daily news',
      publisherType: 'Partner publisher',
      publisherMeta: 'New York, NY',
      totalFollowers: '833.3K',
      imageUrl: 'https://images.unsplash.com/photo-1540575467063-178a50c2df87?w=800',
      category: 'New York',
      author: 'News Team',
      timeAgo: '2h',
      title: 'Best Concert In The Town',
      subtitle: 'Local TV Coverage: Major Event Unfolds Across the City...',
      body: 'News detail content here...',
      reactions: '2.1K',
      likes: '3.4K',
      comments: '1.8K',
      isVerified: true,
    ),
  ].obs;

// Entertainment Tab
  final RxList<NewsModel> entertainmentNews = <NewsModel>[
    NewsModel(
      id: 101,
      publisherName: 'shefinds',
      publisherType: 'Partner publisher.',
      publisherMeta: 'Beverly Hills,CA',
      totalFollowers: '833.3K',
      imageUrl: 'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=800',
      category: 'OPINION',
      author: 'Hollywood Desk',
      timeAgo: '6 days ago',
      title: 'Best Concert In The Town',
      subtitle: 'The View Fans Think Whoopi Goldberg Has Lost Her Mind After She Suggests Donald Trump`s Iran War Is A Distraction From Nancy Guthrie...',
      body: 'Full news content...',
      reactions: '45',
      likes: '33',
      comments: '15',
    ),
    NewsModel(
      id: 999999,
      publisherName: 'Bingo Fun',
      publisherImageUrl: 'https://images.unsplash.com/photo-1587300003388-59208cc962cb?w=800',
      publisherMeta: 'Sponsored',
      publisherType: 'Ad',
      totalFollowers: '1.2M',
      timeAgo: 'Now',
      subtitle: 'Best Concert In The Town',
      title: "Bingo Fun Ad - Play and Win exciting prizes today!",
      imageUrl: 'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?w=800',
      category: 'Promotion',
      author: 'Bingo Team',
      body: 'This is an advertisement content...',
      likes: '10K',
      comments: '500',
      shares: '2K',
      reactions: '5.4K',
      isVerified: true,
      videoUrl: 'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
    ),
    NewsModel(
      id: 102,
      publisherName: 'shefinds',
      publisherType: 'Partner publisher.',
      publisherMeta: 'Partner publisher.',
      totalFollowers: '833.3K',
      imageUrl: 'https://images.unsplash.com/photo-1514525253161-7a46d19cd819?w=800',
      category: 'ENTERTAINMENT',
      author: 'Variety Desk',
      timeAgo: '2h',
      subtitle: 'Best Concert In The Town',
      title: 'Hollywood Stars React to the Latest Box Office Surprises...',
      body: 'Full news content...',
      reactions: '980',
      likes: '2.1K',
      comments: '1.8K',
    ),
    NewsModel(
      id: 103,
      publisherName: 'Variety',
      publisherType: 'Partner publisher.',
      publisherMeta: 'Entertainment Network',
      totalFollowers: '1.2M',
      imageUrl: 'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?w=800',
      category: 'MUSIC',
      author: 'Staff',
      timeAgo: '5h',
      title: 'Best Concert In The Town',
      subtitle: 'Grammy-Winning Artist Announces Surprise Album Drop...',
      body: 'Full news content...',
      reactions: '3.4K',
      likes: '5.6K',
      comments: '2.2K',
    ),
    NewsModel(
      id: 104,
      publisherName: 'Entertainment Weekly',
      publisherType: 'Partner publisher.',
      publisherMeta: 'Media Partner',
      totalFollowers: '900K',
      imageUrl: 'https://images.unsplash.com/photo-1489599849927-2ee91cede3ba?w=800',
      category: 'MOVIES',
      author: 'EW Staff',
      timeAgo: '8h',
      title: 'Best Concert In The Town',
      subtitle: 'Exclusive: First Look at the Most Anticipated Sequel...',
      body: 'Full news content...',
      reactions: '2.7K',
      likes: '4.1K',
      comments: '3.3K',
    ),
  ].obs;



  // Sports Tab
  final RxList<NewsModel> sportsNews = <NewsModel>[
    NewsModel(
      id: 101,
      publisherName: 'shefinds',
      publisherType: 'Partner publisher',
      publisherMeta: 'Partner publisher',
      totalFollowers: '833.3K',
      imageUrl: 'https://images.unsplash.com/photo-1560272564-c83b66b1ad12?w=800',
      category: 'OPINION',
      author: 'Sports Desk',
      timeAgo: '19h',
      title: 'Best Concert In The Town',
      subtitle: "'The View' Fans Think Whoopi Goldberg Has 'Lost Her Mind'...",
      body: 'Full content here...',
      reactions: '51',
      likes: '70K',
      comments: '27K',
    ),
    NewsModel(
      id: 102,
      publisherName: 'shefinds',
      publisherType: 'Partner publisher',
      publisherMeta: 'Partner publisher',
      totalFollowers: '833.3K',
      imageUrl: 'https://images.unsplash.com/photo-1534787238916-9ba6764efd4f?w=800',
      category: 'CYCLING',
      author: 'Staff',
      timeAgo: '3h',
      title: 'Best Concert In The Town',
      subtitle: 'Professional Cyclist Breaks World Record in Time Trial Event...',
      body: 'Full content here...',
      reactions: '654',
      likes: '1.2K',
      comments: '876',
    ),
    NewsModel(
      id: 103,
      publisherName: 'ESPN',
      publisherType: 'Partner publisher',
      publisherMeta: 'Global Sports Network',
      totalFollowers: '5.1M',
      imageUrl: 'https://images.unsplash.com/photo-1546519638-68e109498ffc?w=800',
      category: 'BASKETBALL',
      author: 'ESPN Staff',
      timeAgo: '6h',
      subtitle: 'Best Concert In The Town',
      title: 'NBA Playoffs: Underdog Team Clinches Surprising Victory...',
      body: 'Full content here...',
      reactions: '8.9K',
      likes: '12.4K',
      comments: '7.8K',
    ),
    NewsModel(
      id: 104,
      publisherName: 'Sports Illustrated',
      publisherType: 'Partner publisher',
      publisherMeta: 'Media Partner',
      totalFollowers: '2.3M',
      imageUrl: 'https://images.unsplash.com/photo-1574629810360-7efbbe195018?w=800',
      category: 'FOOTBALL',
      author: 'SI Staff',
      timeAgo: '10h',
      title: 'Best Concert In The Town',
      subtitle: 'Transfer Window: Top Club Confirms Signing of Star Striker...',
      body: 'Full content here...',
      reactions: '5.2K',
      likes: '9.1K',
      comments: '4.4K',
    ),
  ].obs;

  // Food Tab
  final RxList<NewsModel> foodNews = <NewsModel>[
    NewsModel(
      id: 101,
      publisherName: 'shefinds',
      publisherType: 'Partner publisher',
      publisherMeta: 'Global Food Network',
      totalFollowers: '833.3K',
      imageUrl: 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=800',
      category: 'OPINION',
      author: 'Nutrition Desk',
      timeAgo: '19h',
      title: 'Best Concert In The Town',
      subtitle: "'The View' Fans Think Whoopi Goldberg Has 'Lost Her Mind'...",
      body: 'Full content here...',
      reactions: '37',
      likes: '88',
      comments: '64',
    ),
    NewsModel(
      id: 102,
      publisherName: 'shefinds',
      publisherType: 'Partner publisher',
      publisherMeta: 'Partner publisher',
      totalFollowers: '833.3K',
      imageUrl: 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=800',
      category: 'NUTRITION',
      author: 'Staff',
      timeAgo: '4h',
      title: 'Best Concert In The Town',
      subtitle: '10 Superfoods That Nutritionists Swear By for Boosting Energy...',
      body: 'Full content here...',
      reactions: '1.1K',
      likes: '2.3K',
      comments: '1.5K',
    ),
    NewsModel(
      id: 103,
      publisherName: 'Bon Appétit',
      publisherType: 'Partner publisher',
      publisherMeta: 'Partner publisher',
      totalFollowers: '1.8M',
      imageUrl: 'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=800',
      category: 'RECIPE',
      author: 'Nutrition Desk',
      timeAgo: '7h',
      title: 'Best Concert In The Town',
      subtitle: 'This One-Pan Mediterranean Chicken Recipe Will Completely Transform...',
      body: 'Full content here...',
      reactions: '3.2K',
      likes: '6.7K',
      comments: '2.1K',
    ),
    NewsModel(
      id: 104,
      publisherName: 'Food Network',
      publisherType: 'Partner publisher',
      publisherMeta: 'Top Publisher',
      totalFollowers: '3.4M',
      imageUrl: 'https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=800',
      category: 'TRENDS',
      author: 'Staff',
      timeAgo: '11h',
      title: 'Best Concert In The Town',
      subtitle: "2025's Hottest Food Trends: From Fermented Delights to Globally-Inspired...",
      body: 'Full content here...',
      reactions: '2.8K',
      likes: '4.5K',
      comments: '3.0K',
    ),
  ].obs;

  // Health Tab
  final RxList<NewsModel> healthNews = <NewsModel>[
    NewsModel(
      id: 101,
      publisherName: 'shefinds',
      publisherType: 'Partner publisher',
      publisherMeta: 'Partner publisher',
      totalFollowers: '833.3K',
      imageUrl: 'https://images.unsplash.com/photo-1476480862126-209bfaa8edc8?w=800',
      category: 'OPINION',
      author: 'Health Desk',
      timeAgo: '19h',
      title: 'Best Concert In The Town',
      subtitle: "'The View' Fans Think Whoopi Goldberg Has 'Lost Her Mind'...",
      body: 'Full content here...',
      reactions: '42',
      likes: '101',
      comments: '52',
    ),
    NewsModel(
      id: 102,
      publisherName: 'shefinds',
      publisherType: 'Partner publisher',
      publisherMeta: 'Partner publisher',
      totalFollowers: '833.3K',
      imageUrl: 'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=800',
      category: 'FITNESS',
      author: 'Fitness Coach',
      timeAgo: '2h',
      title: 'Best Concert In The Town',
      subtitle: 'Morning Running Groups Are Changing Lives...',
      body: 'Full content here...',
      reactions: '2.1K',
      likes: '3.8K',
      comments: '1.9K',
    ),
    NewsModel(
      id: 103,
      publisherName: 'Healthline',
      publisherType: 'Partner publisher',
      publisherMeta: 'Health Partner',
      totalFollowers: '2.7M',
      imageUrl: 'https://images.unsplash.com/photo-1505576399279-565b52d4ac71?w=800',
      category: 'WELLNESS',
      author: 'WebMD Staff',
      timeAgo: '5h',
      title: 'Best Concert In The Town',
      subtitle: 'New Study Reveals the Surprising Link Between Sleep Quality...',
      body: 'Full content here...',
      reactions: '4.3K',
      likes: '7.2K',
      comments: '3.1K',
    ),
    NewsModel(
      id: 104,
      publisherName: 'WebMD',
      publisherType: 'Partner publisher',
      publisherMeta: 'Verified Medical News',
      totalFollowers: '1.9M',
      imageUrl: 'https://images.unsplash.com/photo-1490645935967-10de6ba17061?w=800',
      category: 'NUTRITION',
      author: 'Dr. Smith',
      timeAgo: '9h',
      title: 'Best Concert In The Town',
      subtitle: 'Doctors Are Now Recommending This Simple Daily Habit...',
      body: 'Full content here...',
      reactions: '6.1K',
      likes: '9.4K',
      comments: '5.5K',
    ),
  ].obs;


// Beauty Tab
  final RxList<NewsModel> beautyNews = <NewsModel>[
    NewsModel(
      id: 101,
      publisherName: 'shefinds',
      publisherMeta: 'Partner publisher',
      publisherType: 'Partner publisher',
      totalFollowers: '833.3K',
      imageUrl: 'https://images.unsplash.com/photo-1570172619644-dfd03ed5d881?w=800',
      category: 'OPINION',
      author: 'Shefinds Staff',
      timeAgo: '19h',
      title: 'Best Concert In The Town',
      subtitle: "'The View' Fans Think Whoopi Goldberg Has 'Lost Her Mind'...",
      body: 'Full content here...',
      reactions: '38',
      likes: '99',
      comments: '22',
    ),
    NewsModel(
      id: 102,
      publisherName: 'shefinds',
      publisherMeta: 'Partner publisher',
      publisherType: 'Partner publisher',
      totalFollowers: '833.3K',
      imageUrl: 'https://images.unsplash.com/photo-1596462502278-27bfdc403348?w=800',
      category: 'MAKEUP',
      timeAgo: '3h',
      author: 'Beauty Desk',
      title: 'Best Concert In The Town',
      subtitle: 'The Best Drugstore Makeup Dupes...',
      body: 'Full content here...',
      reactions: '3.7K',
      likes: '8.2K',
      comments: '4.6K',
    ),
    NewsModel(
      id: 103,
      publisherName: 'Allure',
      publisherMeta: 'Partner publisher',
      publisherType: 'Partner publisher',
      totalFollowers: '2.1M',
      imageUrl: 'https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?w=800',
      category: 'SKINCARE',
      author: 'Beauty Desk',
      timeAgo: '6h',
      title: 'Best Concert In The Town',
      subtitle: 'Dermatologists Reveal the One Ingredient...',
      body: 'Full content here...',
      reactions: '5.4K',
      likes: '10.1K',
      comments: '6.3K',
    ),
    NewsModel(
      id: 104,
      publisherName: 'Vogue Beauty',
      publisherMeta: 'Partner publisher',
      publisherType: 'Partner publisher',
      totalFollowers: '4.6M',
      imageUrl: 'https://images.unsplash.com/photo-1487412947147-5cebf100ffc2?w=800',
      category: 'TRENDS',
      author: 'Beauty Desk',
      timeAgo: '12h',
      title: 'Best Concert In The Town',
      subtitle: "Spring 2025's Biggest Beauty Trends...",
      body: 'Full content here...',
      reactions: '7.8K',
      likes: '14.3K',
      comments: '8.9K',
    ),
  ].obs;


  // Weather Tab
  final RxList<NewsModel> weatherNews = <NewsModel>[
    NewsModel(
      id: 101,
      publisherName: 'shefinds',
      publisherType: 'Partner publisher',
      publisherMeta: 'Partner publisher',
      totalFollowers: '833.3K',
      imageUrl: 'https://images.unsplash.com/photo-1601297183305-6df142704ea2?w=800',
      category: 'OPINION',
      author: 'Staff',
      timeAgo: '19h',
      title: 'Best Concert In The Town',
      subtitle: "'The View' Fans Think Whoopi Goldberg Has 'Lost Her Mind' After She Suggests Donald Trump's Iran War Is A Distraction From Nancy Guthrie...",
      body: 'Full news content here...',
      reactions: '44',
      likes: '420',
      comments: '43',
    ),
    NewsModel(
      id: 102,
      publisherName: 'Weather Channel',
      publisherType: 'Partner publisher',
      publisherMeta: 'Global Weather Network',
      totalFollowers: '3.2M',
      imageUrl: 'https://images.unsplash.com/photo-1561484930-998b6a7b22e8?w=800',
      category: 'FORECAST',
      author: 'Meteorologist Desk',
      timeAgo: '4h',
      title: 'Best Concert In The Town',
      subtitle: 'El Niño Pattern Expected to Bring Above-Average Temperatures to Much of the Country Through Summer',
      body: 'Full news content here...',
      reactions: '2.3K',
      likes: '3.9K',
      comments: '1.4K',
    ),
    NewsModel(
      id: 103,
      publisherName: 'AccuWeather',
      publisherType: 'Partner publisher',
      publisherMeta: 'Climate Expert Partner',
      totalFollowers: '1.5M',
      imageUrl: 'https://images.unsplash.com/photo-1530908295418-a12e326966ba?w=800',
      category: 'CLIMATE',
      author: 'Climate Desk',
      timeAgo: '8h',
      title: 'Best Concert In The Town',
      subtitle: 'Record-Breaking Heat Wave Sweeps Across Southern States — Tips for Staying Cool and Healthy During Extreme Temperatures',
      body: 'Full news content here...',
      reactions: '4.7K',
      likes: '6.8K',
      comments: '3.2K',
    ),
  ].obs;

  // Extended Daily Weather
  final RxList<Map<String, String>> weatherDays = <Map<String, String>>[
    {'day': 'Today', 'icon': AppAssets.cloudyIcon,'temp': '30°/40°'},
    {'day': '04/11', 'icon': AppAssets.sunnyIcon, 'temp': '30°/40°'},
    {'day': '04/10', 'icon': AppAssets.sunnyIcon, 'temp': '30°/40°'},
    {'day': '04/09', 'icon': AppAssets.stormIcon, 'temp': '30°/40°'},
    {'day': '04/08', 'icon': AppAssets.sunnyIcon, 'temp': '30°/40°'},
    {'day': '04/07', 'icon': AppAssets.sunnyIcon, 'temp': '30°/40°'},
    {'day': '04/06', 'icon': AppAssets.stormIcon, 'temp': '30°/40°'},
  ].obs;



  // Weather Forecast Data
  final RxList<Map<String, String>> hourlyForecast = <Map<String, String>>[
    {'time': 'Now', 'icon': AppAssets.cloudyIcon, 'temp': '30°'},
    {'time': '03AM', 'icon': AppAssets.nightIcon, 'temp': '30°'},
    {'time': '04AM', 'icon': AppAssets.nightIcon, 'temp': '30°'},
    {'time': '05AM', 'icon': AppAssets.cloudyIcon, 'temp': '30°'},
    {'time': '06AM', 'icon': AppAssets.stormIcon, 'temp': '30°'},
  ].obs;

  final RxList<Map<String, String>> dailyForecast = <Map<String, String>>[
    {'time': 'Today', 'icon': AppAssets.cloudyIcon, 'temp': '30°/40°'},
    {'time': 'Mon', 'icon': AppAssets.sunnyIcon, 'temp': '28°/38°'},
    {'time': 'Tue', 'icon': AppAssets.sunriseIcon, 'temp': '25°/35°'},
    {'time': 'Wed', 'icon': AppAssets.stormIcon,'temp': '22°/32°'},
    {'time': 'Thu', 'icon': AppAssets.sunnyIcon, 'temp': '27°/37°'},
  ].obs;

  final List<Map<String, String>> allLocations = [
    {'city': 'New York City', 'zip': 'NY, 100002'},
    {'city': 'Los Angeles', 'zip': 'CA, 90001'},
    {'city': 'Chicago', 'zip': 'IL, 60601'},
    {'city': 'Houston', 'zip': 'TX, 77001'},
    {'city': 'San Francisco', 'zip': 'CA, 94105'},
  ];

}
