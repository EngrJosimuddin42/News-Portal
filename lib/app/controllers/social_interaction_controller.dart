import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:news_break/app/models/comment_source.dart';
import 'package:share_plus/share_plus.dart';
import '../models/comment_model.dart';
import '../models/news_model.dart';
import '../modules/trends/comments/comments_sheet.dart';
import '../routes/app_pages.dart';
import '../widgets/app_snackbar.dart';
import 'auth/auth_controller.dart';
import 'auth/auth_helper.dart';
import 'me/settings/settings_controller.dart';
import 'reels/comment_controller.dart';

class SocialInteractionController extends GetxController {
  static SocialInteractionController get to => Get.find();

  final likedIds = <String>{}.obs;
  final dislikedIds = <String>{}.obs;
  final savedIds = <String>{}.obs;
  final blockedSources = <String>{}.obs;
  final hiddenIds = <String>{}.obs;
  final reportedIds = <String>{}.obs;
  final joinedCommunityIds = <int>{}.obs;
  final Map<String, RxInt> reactionCounts = {};
  final reactions = <String, String>{}.obs;
  final Map<dynamic, RxInt> commentCounts = {};
  final Map<String, bool> followedPublishers = {};
  final Map<int, int> _baseFollowerCounts = {};
  final ValueNotifier<int> followNotifier = ValueNotifier<int>(0);
  final followerCounts = <int, String>{}.obs;
  final followingCount = 0.obs;
  final followersCount = 0.obs;
  final blockedTopics = <String>{}.obs;
  final blockedAuthors = <String>{}.obs;
  final commentList = <CommentModel>[].obs;
  final savedNewsItems = <NewsModel>[].obs;
  final userPosts = <NewsModel>[].obs;
  final likedNewsMap = <String, NewsModel>{}.obs;
  final commentedNewsItems = <NewsModel>[].obs;
  var likedComments = <String>[].obs;
  var dislikedComments = <String>[].obs;
  var savedItems = <String>[].obs;
  var selectedReason = Rxn<String>();
  var isReportSubmitted = false.obs;
  var reportContentId = 0.obs;
  var reportContentType = ''.obs;

  void selectReason(String reason) => selectedReason.value = reason;
  bool isCommentLiked(String id) => likedComments.contains(id);
  bool isCommentDisliked(String id) => dislikedComments.contains(id);

  // Auth check
  bool get isLoggedIn => AuthController.to.user.value != null;
  String get userName => AuthController.to.user.value?.name ?? '';



  // LIKE
  void toggleLike(NewsModel news, {String type = 'news'}) {
    if (!AuthHelper.checkLogin()) return;
    final key = _getEffectiveKey(news.id, news.author, type);
    final mapKey = '${type}_${news.id}';

    if (likedIds.contains(key)) {
      likedIds.remove(key);
      likedNewsMap.remove(mapKey);
    } else {
      likedIds.add(key);
      dislikedIds.remove(key);
      likedNewsMap[mapKey] = news;
    }
    likedIds.refresh();
    likedNewsMap.refresh();
  }


  bool isLiked(NewsModel news, {String type = 'news'}) {
    final key = _getEffectiveKey(news.id, news.author, type);
    return likedIds.contains(key);
  }

  void likeComment(String id) {
    if (!likedComments.contains(id)) {
      likedComments.add(id);
      dislikedComments.remove(id);
    }
  }

  void toggleCommentLike(CommentModel comment) {
    if (!AuthHelper.checkLogin()) return;

    final String id = comment.id.toString();

    if (likedComments.contains(id)) {

      likedComments.remove(id);
      comment.likes--;
    } else {
      likedComments.add(id);
      dislikedComments.remove(id);
      comment.likes++;
    }
    if (Get.isRegistered<CommentController>()) {
      Get.find<CommentController>().commentsList.refresh();
    }
  }

  int getAdjustedLikes(String commentId, int originalLikes) {
    if (isCommentLiked(commentId)) {
      return originalLikes + 1;
    } else if (isCommentDisliked(commentId) && originalLikes > 0) {
      return originalLikes - 1;
    }
    return originalLikes;
  }

  String getAdjustedNewsLikes(NewsModel news, {String type = 'news'}) {
    int currentLikes = _parseStatCount(news.likes);
    if (isLiked(news, type: type)) {
      return formatCount(currentLikes + 1);
    }
    return formatCount(currentLikes);
  }

  //  DISLIKE
  void toggleDislike(int id, {String type = 'news'}) {
    if (!AuthHelper.checkLogin()) return;
    final key = '${type}_$id';
    if (dislikedIds.contains(key)) {
      dislikedIds.remove(key);
    } else {
      dislikedIds.add(key);
      likedIds.remove(key);
    }

  }

  bool isDisliked(dynamic id, {String type = 'news'}) =>
      dislikedIds.contains('${type}_$id');

  void dislikeComment(String id) {
    if (!dislikedComments.contains(id)) {
      dislikedComments.add(id);
      likedComments.remove(id);
    }
  }

  void toggleCommentDislike(String id) {
    if (dislikedComments.contains(id)) {
      dislikedComments.remove(id);
    } else {
      dislikedComments.add(id);
      likedComments.remove(id);
    }
  }


  // SAVE
  void toggleSave(int id, {String type = 'news'}) {
    if (!AuthHelper.checkLogin()) return;
    final key = '${type}_$id';
    if (savedIds.contains(key)) {
      savedIds.remove(key);
      AppSnackbar.success(message: 'Removed from saved');
    } else {
      savedIds.add(key);
      AppSnackbar.success(message: 'Saved successfully');
    }
  }

  void onSaveNews(NewsModel news) {
    if (!isLoggedIn) {
      Get.toNamed(Routes.SIGNIN);
      return;
    }
    final key = 'news_${news.id}';
    if (savedIds.contains(key)) {
      savedIds.remove(key);
      savedNewsItems.removeWhere((n) => n.id == news.id);
      AppSnackbar.success(message: 'Removed from bookmarks');
    } else {
      savedIds.add(key);
      savedNewsItems.add(news);
      AppSnackbar.success(message: 'News saved to your bookmarks');
    }
  }

  bool isSaved(int id, {String type = 'news'}) =>
      savedIds.contains('${type}_$id');


  // FOLLOW
  void toggleFollow(dynamic item) {
    if (!AuthHelper.checkLogin()) return;

    String name = "";
    int? newsId;

    if (item is NewsModel) {
      name = item.publisherName;
      newsId = item.id;
    } else if (item is CommentModel) {
      name = item.userName;
    } else {
      name = item.publisherName ?? item.userName ?? "";
    }

    if (name.isEmpty) return;

    if (item is NewsModel) initFollowerCount(item);

    if (followedPublishers[name] == true) {
      followedPublishers[name] = false;
      item.isFollowing = false;
      followingCount.value--;
      if (newsId != null) {
        final base = _baseFollowerCounts[newsId]!;
        followerCounts[newsId] = formatCount(base);
      }
      AppSnackbar.success(message: 'Unfollowed $name');
    } else {
      followedPublishers[name] = true;
      item.isFollowing = true;
      followingCount.value++;
      if (newsId != null) {
        final base = _baseFollowerCounts[newsId]!;
        followerCounts[newsId] = formatCount(base + 1);
      }
      AppSnackbar.success(message: 'Following $name');
    }

    followNotifier.value++;

    if (Get.isRegistered<CommentController>()) {
      Get.find<CommentController>().commentsList.refresh();
    }
  }

  void initFollowerCount(NewsModel news) {
    if (!_baseFollowerCounts.containsKey(news.id)) {
      _baseFollowerCounts[news.id] = _parseStatCount(news.totalFollowers?.toString() ?? '0');
      followerCounts[news.id] = news.totalFollowers ?? '0';
    }
  }


  bool isFollowing(String publisherName) =>
      followedPublishers[publisherName] == true;


  void onFollow(String publisher) {
    if (!isLoggedIn) Get.toNamed(Routes.SIGNIN);
  }

  void onDismiss(String publisher) {}

  void onFollowPeople(int index) {
    if (!isLoggedIn) {
      Get.toNamed(Routes.SIGNIN);
      return;
    }
    suggestedPeople[index]['isFollowing'] = !suggestedPeople[index]['isFollowing'];
    suggestedPeople.refresh();
  }

  void onDismissPeople(int index) {
    suggestedPeople.removeAt(index);
  }


  // parse
  int _parseStatCount(String count) {
    count = count.toLowerCase().replaceAll(',', '');
    if (count.contains('k')) {
      return (double.parse(count.replaceAll('k', '')) * 1000).toInt();
    } else if (count.contains('m')) {
      return (double.parse(count.replaceAll('m', '')) * 1000000).toInt();
    }
    return int.tryParse(count) ?? 0;
  }


  String _toBengaliNumber(String input) {
    const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const bengali = ['০', '১', '২', '৩', '৪', '৫', '৬', '৭', '৮', '৯'];
    for (int i = 0; i < 10; i++) {
      input = input.replaceAll(english[i], bengali[i]);
    }
    return input;
  }


  String formatCount(int count) {
    String result;
    if (count >= 1000000) {
      double formatted = count / 1000000;
      result = '${formatted.toStringAsFixed(formatted.truncateToDouble() == formatted ? 0 : 1)}m';
    } else if (count >= 1000) {
      double formatted = count / 1000;
      result = '${formatted.toStringAsFixed(formatted.truncateToDouble() == formatted ? 0 : 1)}k';
    } else {
      result = count.toString();
    }

    if (Get.find<SettingsController>().selectedLanguage.value == 'Bangla') {
      return _toBengaliNumber(result);
    }
    return result;
  }


  //  BLOCK
  void blockSource(String publisherName) {
    if (!AuthHelper.checkLogin()) return;
    blockedSources.add(publisherName);

    if (Get.isRegistered<CommentController>()) {
      Get.find<CommentController>().commentsList.removeWhere((c) => c.userName == publisherName);
      Get.find<CommentController>().commentsList.refresh();
    }
    AppSnackbar.success(message: 'Blocked $publisherName');
  }

  void blockUser(String userName) {
    if (!AuthHelper.checkLogin()) return;
    blockedSources.add(userName);
    if (Get.isRegistered<CommentController>()) {
      final commentCtrl = Get.find<CommentController>();
      commentCtrl.commentsList.removeWhere((c) => c.userName == userName);
      commentCtrl.commentsList.refresh();
    }
    if (Get.isOverlaysOpen) Get.back();
    AppSnackbar.success(message: 'Content from $userName hidden');
  }


  bool isBlocked(String publisherName) =>
      blockedSources.contains(publisherName);


  // HIDE
  void hideContent(int id, {String type = 'news'}) {
    final key = '${type}_$id';
    hiddenIds.add(key);
    AppSnackbar.success(message: 'Content hidden from your feed');
  }

  void showLessAboutAuthor(String author) {
    blockedAuthors.add(author);
    AppSnackbar.success(message: "We'll show you fewer stories about $author.");
  }

  void showLessAboutTopic(String topic) {
    blockedTopics.add(topic);
    AppSnackbar.success(message: "We'll show you fewer stories about $topic.");
  }

  bool isHidden(int id, {String type = 'news'}) =>
      hiddenIds.contains('${type}_$id');


  //  REPORT
  void openReport(int id, String type) {
    reportContentId.value = id;
    reportContentType.value = type;
    selectedReason.value = null;
    isReportSubmitted.value = false;
  }

  void resetReport() {
    selectedReason.value = null;
    isReportSubmitted.value = false;
  }

  void submitReport() {
    if (selectedReason.value == null) return;
    final key = '${reportContentType.value}_${reportContentId.value}';
    reportedIds.add(key);
    isReportSubmitted.value = true;
  }

  bool isReported(int id, {String type = 'news'}) =>
      reportedIds.contains('${type}_$id');


  // ── SHARE
  Future<void> share({
    required int id,
    required String title,
    required String type, // 'news' | 'reel' | 'post'
  }) async {
    final String url = 'https://newsbreak.com/$type/$id';
    await Share.share('$title\n$url');
  }

  void onSharePressed(NewsModel news) async {
    await Share.share(
      'Check out this news: ${news.title}\nRead more at: ${news.imageUrl}',
      subject: news.title,
    );
  }

  void shareContent(String id, {required String type}) async {
    String message = "Check out this $type on News Break!";
    String url = "https://newsbreak.com/$type/$id";
    await Share.share('$message\n$url');
  }


  // COMMENT
  void openComments(int id, CommentSource source, {String tabType = 'news', String? author, NewsModel? news}) {
    if (!AuthHelper.checkLogin()) return;
    Get.find<CommentController>().loadComments(id, source, tabType: tabType, author: author, news: news);
    showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      constraints: BoxConstraints(maxWidth: MediaQuery.of(Get.context!).size.width),
      builder: (_) => CommentsSheet(id: id, source: source),
    );
  }

  void onCommentPressed(NewsModel news) {
    Get.find<CommentController>().loadComments(news.id, CommentSource.news);
    showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      constraints: BoxConstraints(
          maxWidth: MediaQuery.of(Get.context!).size.width),
      builder: (_) => CommentsSheet(
          id: news.id,
          source: CommentSource.news),
    );
  }

  RxInt getCommentCount(NewsModel news, {String source = 'news'}) {
    final key = _getEffectiveKey(news.id, news.author, source);
    if (!commentCounts.containsKey(key)) {
      int initialCount = _parseStatCount(news.comments);
      commentCounts[key] = initialCount.obs;
    }
    return commentCounts[key]!;
  }


  void incrementCommentCount(dynamic id, {String source = 'news', String? author}) {
    final key = (author != null)
        ? _getEffectiveKey(id, author, source)
        : '${source}_$id';
    if (commentCounts.containsKey(key)) {
      commentCounts[key]!.value++;
    }
  }

  void copyComment(String text) {
    Clipboard.setData(ClipboardData(text: text));
    Get.back();
    AppSnackbar.success(message: 'Copied to clipboard');
  }

  void addCommentedNews(NewsModel news) {
    if (!commentedNewsItems.any((n) => n.id == news.id)) {
      commentedNewsItems.add(news);
    }
  }

  void addComment(CommentModel comment) {
    commentList.add(comment);
    commentList.refresh();
  }

  void addNewsComment(CommentModel comment) {
    commentList.add(comment);
    commentList.refresh();
  }


  // Reaction
  void updateReaction(NewsModel news, String type, String emoji) {
    if (!AuthHelper.checkLogin()) return;
    final key = _getEffectiveKey(news.id, news.author, type);
    reactions[key] = emoji;
  }

  String getSelectedReaction(NewsModel news, {String type = 'news'}) {
    final key = _getEffectiveKey(news.id, news.author, type);
    return reactions[key] ?? '';
  }

  String getMyReaction(dynamic id, String type) {
    return reactions['${type}_$id'] ?? '';
  }


  RxInt getReactionCount(NewsModel news, {String source = 'news'}) {
    final key = _getEffectiveKey(news.id, news.author, source);
    if (!reactionCounts.containsKey(key)) {
      int initialCount = _parseStatCount(news.reactions);
      reactionCounts[key] = initialCount.obs;
    }
    return reactionCounts[key]!;
  }

  void incrementReactionCount(NewsModel news, {String source = 'news'}) {
    final key = _getEffectiveKey(news.id, news.author, source);
    if (!reactionCounts.containsKey(key)) {
      reactionCounts[key] = 0.obs;
    }
    reactionCounts[key]!.value++;
  }


  // JOIN COMMUNITY
  void toggleJoin(int communityId) {
    if (!AuthHelper.checkLogin()) return;
    if (joinedCommunityIds.contains(communityId)) {
      joinedCommunityIds.remove(communityId);
      AppSnackbar.success(message: 'Left socials');
    } else {
      joinedCommunityIds.add(communityId);
      AppSnackbar.success(message: 'Joined socials!');
    }
  }

  bool isJoined(int communityId) =>  joinedCommunityIds.contains(communityId);


  // Other Logic
  String _getEffectiveKey(dynamic newsId, String? author, String source) {
    final currentUser = AuthController.to.user.value?.name ?? 'Me';
    if (author == 'Me' || author == currentUser) {
      return 'user_post_$newsId';
    }
    return '${source}_$newsId';
  }


  final RxList<Map<String, dynamic>> suggestedPeople = [
    {
      'name': 'Catherine',
      'subtitle': 'Daily rising star',
      'isFollowing': false,
      'image': 'assets/images/user1.png'
    },
    {
      'name': 'John Doe',
      'subtitle': 'Tech Enthusiast',
      'isFollowing': false,
      'image': 'assets/images/user2.png'
    },
    {
      'name': 'Amalia Rose',
      'subtitle': 'Flutter Developer',
      'isFollowing': false,
      'image': 'assets/images/user3.png'
    },
  ].obs;

}