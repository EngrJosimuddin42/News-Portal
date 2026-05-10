import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news_break/app/widgets/app_snackbar.dart';
import '../../models/reel_model.dart';
import '../../modules/me/settings/about/legal_view.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/services.dart';
import '../../modules/trends/comments/report_comment_sheet.dart';
import '../auth/auth_controller.dart';
import '../social_interaction_controller.dart';

class ReelsController extends GetxController {

//  Reels Data
  var reelsList = <ReelModel>[].obs;
  var isLoading = true.obs;
  var savedReels = <int>[].obs;
  var currentIndex = 0.obs;
  bool useCustomList = false;
  int initialIndex = 0;
  bool _isSharing = false;


  PageController pageController = PageController();

  final String mediaAccountLabel = 'Media account';
  final String checkOutPrefix = 'Check out ';
  final String sendStoryLabel = 'Send this story';

  SocialInteractionController get _social => Get.find<SocialInteractionController>();

  final Map<String, bool> _followedUsers = {};
  bool isUserFollowing(String userName) => _followedUsers[userName] ?? false;


  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  int _parseStatCount(String count) {
    count = count.toLowerCase().replaceAll(',', '');
    if (count.contains('k')) {
      return (double.parse(count.replaceAll('k', '')) * 1000).toInt();
    } else if (count.contains('m')) {
      return (double.parse(count.replaceAll('m', '')) * 1000000).toInt();
    }
    return int.tryParse(count) ?? 0;
  }


  void incrementComment(int reelId) {
    int index = reelsList.indexWhere((r) => r.id == reelId);
    if (index != -1) {
      reelsList[index].comments++;
      reelsList.refresh();
    }
  }

  void updatePage(int index) {
    currentIndex.value = index;
    if (pageController.hasClients) {
      pageController.jumpToPage(index);
    }
  }

  void toggleLike(int index) {
    reelsList[index].isLiked = !reelsList[index].isLiked;
    reelsList[index].isLiked
        ? reelsList[index].likes++
        : reelsList[index].likes--;

    final key = 'reel_${reelsList[index].id}';
    if (reelsList[index].isLiked) {
      _social.likedIds.add(key);
    } else {
      _social.likedIds.remove(key);
    }

    reelsList.refresh();
  }



  void incrementProfileView(dynamic user) {
    int currentViews = _parseStatCount(user.totalViews.toString());
    currentViews++;
    user.totalViews = _social.formatCount(currentViews);
    reelsList.refresh();
  }

  void toggleFollow(dynamic item) {
    if (item == null) return;
    final String userName = item.userName ?? '';
    if (userName.isEmpty) return;

    final bool currentState = _followedUsers[userName] ?? false;
    _followedUsers[userName] = !currentState;

    final socialCtrl = Get.find<SocialInteractionController>();
    if (!currentState) {
      socialCtrl.followingCount.value++;
    } else {
      socialCtrl.followingCount.value--;
    }

    for (var reel in reelsList) {
      if (reel.userName == userName) {
        reel.isFollowing = !currentState;
        // follower count update
        try {
            int count = _parseStatCount(reel.totalFollowers.toString());
            count = !currentState ? count + 1 : (count > 0 ? count - 1 : 0);
            reel.totalFollowers = _social.formatCount(count);

        } catch (e) {
          debugPrint("ToggleFollow Error: $e");
        }
      }
    }
    reelsList.refresh();
    update();
  }

  int getUserPostCount(String userName) {
    return reelsList.where((r) => r.userName == userName).length;
  }


  void incrementShare(int index) {
    reelsList[index].shares++;
    reelsList.refresh();
  }

  void saveReel(int id) {
    Navigator.of(Get.context!).pop();

    if (savedReels.contains(id)) {
      savedReels.remove(id);
      AppSnackbar.success(message: 'Removed from saved trends');
    } else {
      savedReels.add(id);
      AppSnackbar.success(message: 'Reel saved successfully!');
    }
  }


  void reportComment(int id, BuildContext context) {
    Get.back();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width),
      builder: (context) => const ReportCommentSheet(),
    );
  }

  void openHelpCenter() {
    Get.back();
    Get.to(() => const LegalView(type: LegalType.terms));
  }

  bool hideAuthorContent(String authorName) {
    final loginUserName = Get.find<AuthController>().user.value?.name ?? '';
    if (authorName == loginUserName) {
      AppSnackbar.error(message: "You cannot block yourself!");
      return false;
    }
    reelsList.removeWhere((r) => r.userName == authorName);
    reelsList.refresh();
    return true;
  }


  void onShareOptionTap(int reelId, String platform,
      {String? shareUrl, String? userName}) async {
    if (_isSharing) return;
    _isSharing = true;

    int index = reelsList.indexWhere((r) => r.id == reelId);
    final String url = shareUrl ??
        (index != -1
            ? 'https://newsbreak.com/trends/$reelId'
            : 'https://newsbreak.com/news/$reelId');
    final String author =
        userName ?? (index != -1 ? reelsList[index].userName : '');

    if (platform == 'Copy link') {
      await Clipboard.setData(ClipboardData(text: url));
      if (index != -1) incrementShare(index);
      Get.back();
    } else if (platform == 'More') {
      Get.back();
      await Share.share('Check out this story by $author: $url');
      if (index != -1) incrementShare(index);
    }

    _isSharing = false;
  }


  void addUserReel({
    required String videoPath,
    required String thumbnailPath,
    required String text,
  }) {
    final user = AuthController.to.user.value;
    final String currentUserName = user?.name ?? 'Me';

    final existingReel = reelsList.firstWhereOrNull((r) =>
    r.userName == currentUserName);

    String followers = existingReel?.totalFollowers.toString() ?? "0";
    bool currentlyFollowing = isUserFollowing(currentUserName);

    final newReel = ReelModel(
      id: DateTime
          .now()
          .millisecondsSinceEpoch,
      videoUrl: videoPath,
      imageUrl: thumbnailPath,
      userName: currentUserName,
      userProfileImage: user?.profileImageUrl ?? '',
      description: text,
      totalFollowers: followers,
      isFollowing: currentlyFollowing,
      totalPosts: existingReel?.totalPosts ?? "1",
      likes: 0,
      comments: 0,
      shares: 0,
    );

    reelsList.insert(0, newReel);

    int currentPosts = _parseStatCount(newReel.totalPosts.toString());
    newReel.totalPosts = _social.formatCount(currentPosts + 1);

    reelsList.refresh();

    Future.delayed(const Duration(milliseconds: 100), () {
      if (pageController.hasClients) {
        pageController.jumpToPage(0);
        currentIndex.value = 0;
      }
    });
  }
}