import 'package:get/get.dart';
import 'package:news_break/app/models/news_model.dart';

class TrendsController extends GetxController {
  static TrendsController get to => Get.find();

  final RxBool isLoading = false.obs;
  final RxString selectedTopic = ''.obs;
  final RxList<NewsModel> filteredNews = <NewsModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    filteredNews.value = allNews.toList();
  }

  @override
  Future<void> refresh() async {
    isLoading.value = true;
    selectedTopic.value = '';
    filteredNews.value = allNews.toList();
    await Future.delayed(const Duration(milliseconds: 500));
    isLoading.value = false;
  }

  void filterByTopic(String topic) {
    selectedTopic.value = topic;
    if (topic.isEmpty) {
      filteredNews.value = allNews.toList();
      return;
    }
    filteredNews.value = allNews.where((n) {
      final q = topic.toLowerCase();
      return n.title.toLowerCase().contains(q) ||
          n.publisherName.toLowerCase().contains(q);
    }).toList();
  }

  void clearFilter() {
    selectedTopic.value = '';
    filteredNews.value = allNews.toList();
  }

  final RxList<NewsModel> allNews = <NewsModel>[
    NewsModel(
      id: 101,
      publisherName: 'shefinds',
      publisherImageUrl: 'https://images.unsplash.com/photo-1587300003388-59208cc962cb?w=800',
      publisherMeta: 'Beverly Hills,CA',
      timeAgo: '6 days ago',
      title: "For seven long years, he served without ever asking for anything in return. His name is Sergeant Diesel...",
      imageUrl: 'https://images.unsplash.com/photo-1587300003388-59208cc962cb?w=800',
      category: 'Pets & Animals',
      author: 'Staff',
      imageCaption: 'Joe sussman / Shutterstock.com',
      body: 'Lorem ipsum dolor sit amet consectetur.',
      secondaryImageUrl: 'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=800',
      likes: '12', comments: '8', shares: '1.5K', reactions: '1.4K',
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
      likes: '10K', comments: '500', shares: '2K', reactions: '5.4K',
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
      likes: '5.4K', comments: '2.3K', shares: '1.5K', reactions: '0',
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
      imageUrl: 'https://images.unsplash.com/photo-1504711434969-e33886168f5c?w=800',
      category: 'World',
      body: 'Full content here...',
      likes: '7.5K', comments: '2.3K', shares: '1.5K', reactions: '5.2K',
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
      likes: '3.2K', comments: '2.3K', shares: '1.5K', reactions: '2.8K',
      author: 'Tech Desk',
      isVerified: true,
    ),
  ].obs;

}