import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:news_break/app/controllers/reels/reels_controller.dart';
import 'package:news_break/app/controllers/social_interaction_controller.dart';
import 'package:news_break/app/controllers/social_utility_controller.dart';
import 'package:news_break/app/widgets/app_snackbar.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import '../models/news_model.dart';
import '../modules/create_post/tag_location_sheet.dart';
import '../routes/app_pages.dart';
import 'auth/auth_controller.dart';
import 'home_controller.dart';

//  Post type enum
enum PostType { news, reel, social }

class CreatePostController extends GetxController {
  final TextEditingController textController = TextEditingController();
  final TextEditingController locationSearchController = TextEditingController();
  final utility = Get.find<SocialUtilityController>();

  // ── State
  var selectedLocation = "".obs;
  var isLoading = false.obs;
  var filteredLocations = <Map<String, String>>[].obs;
  var postType = PostType.news.obs;

  final Rx<File?> selectedMedia = Rx<File?>(null);
  final Rx<File?> videoThumbnail = Rx<File?>(null);
  final RxBool isReel = false.obs;

  final ImagePicker _picker = ImagePicker();

  //  Post type getters
  bool get isNewsPost => postType.value == PostType.news;
  bool get isReelPost => postType.value == PostType.reel;
  bool get isSocialPost => postType.value == PostType.social;

  @override
  void onInit() {
    super.onInit();
    resetAll();
    filteredLocations.assignAll(allLocations);
    _handleArguments();
  }


  void _handleArguments() {
    final args = Get.arguments;
    if (args == null) return;

    if (args is File) {
      selectedMedia.value = args;
      if (args.path.toLowerCase().endsWith('.mp4') ||
          args.path.toLowerCase().endsWith('.mov')) {
        postType.value = PostType.reel;
        isReel.value = true;
        generateThumbnail(args.path);
      } else {
        postType.value = PostType.news;
      }
    } else if (args is NewsModel) {
      postType.value = PostType.news;
      textController.text = "${args.title}\n\n";
    } else if (args is String && args == 'social') {
      postType.value = PostType.social;
    }
  }

  @override
  void onClose() {
    textController.dispose();
    locationSearchController.dispose();
    super.onClose();
  }

  Future<void> generateThumbnail(String path) async {
    try {
      final thumbPath = await VideoThumbnail.thumbnailFile(
        video: path,
        imageFormat: ImageFormat.JPEG,
        maxWidth: 300,
        quality: 70,
      );
      if (thumbPath != null) {
        videoThumbnail.value = File(thumbPath);
        videoThumbnail.refresh();
      }
    } catch (e) {
      debugPrint("Thumbnail Error: $e");
    }
  }

  Future<void> onAddMedia() async {
    try {
      final XFile? pickedFile = isReel.value
          ? await _picker.pickVideo(source: ImageSource.gallery, maxDuration: const Duration(seconds: 60))
          : await _picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        selectedMedia.value = File(pickedFile.path);
        if (isReel.value) {
          await generateThumbnail(pickedFile.path);
        } else {
          videoThumbnail.value = null;
        }
      }
    } catch (e) {
      AppSnackbar.error(message: 'Could not pick media: $e');
    }
  }


  //  Post type  validation & submit
  void onPost() async {
    if (!_validate()) return;

    try {
      isLoading.value = true;
      await Future.delayed(const Duration(seconds: 1));

      final mediaUrl = selectedMedia.value?.path
          ?? utility.selectedImage.value?.path
          ?? utility.selectedGifUrl.value;

      final socialCtrl = Get.find<SocialInteractionController>();

        if (isNewsPost) {
        Get.find<HomeController>().addUserPost(
          text: textController.text,
          imageUrl: mediaUrl,
          location: selectedLocation.value,
        );
        socialCtrl.userPosts.add(NewsModel(
          id: DateTime.now().millisecondsSinceEpoch,
          category: 'News',
          title: textController.text,
          author: AuthController.to.user.value?.name ?? '',
          timeAgo: 'Just now',
          publisherName: AuthController.to.user.value?.name ?? '',
          publisherMeta: '',
          imageUrl: mediaUrl ?? '',
          body: textController.text,
        ));
      } else if (isReelPost) {
        Get.find<ReelsController>().addUserReel(
          videoPath: selectedMedia.value!.path,
          thumbnailPath: videoThumbnail.value?.path ?? '',
          text: textController.text,
        );
      }

      final successMsg = _getSuccessMessage();
      utility.clearAllMedia();
      utility.clearTags();
      resetAll();
      Get.until((route) => route.settings.name == Routes.HOME);

      Future.delayed(const Duration(milliseconds: 300), () {
        AppSnackbar.success(message: successMsg);
      });

    } catch (e) {
      AppSnackbar.error(message: 'Something went wrong while uploading.');
    } finally {
      isLoading.value = false;
    }
  }


  //  Type validation
  bool _validate() {
    final hasText = textController.text.trim().isNotEmpty;
    final hasMedia = selectedMedia.value != null ||
        utility.selectedImage.value != null ||
        utility.selectedGifUrl.value != null;

    if (isReelPost) {
      if (selectedMedia.value == null) {
        AppSnackbar.warning(title: 'Video Required', message: 'Please select a video.');
        return false;
      }
    } else {
      if (!hasText && !hasMedia) {
        AppSnackbar.warning(title: 'Empty Post', message: 'Please add some text or media.');
        return false;
      }
    }
    return true;
  }

  //  Type success message
  String _getSuccessMessage() {
    return switch (postType.value) {
      PostType.reel => 'Your reel has been posted!',
      PostType.social => 'Your post has been shared!',
      PostType.news => 'Your news has been shared!',
    };
  }

  // Public reset
  void resetAll() {
    textController.clear();
    selectedMedia.value = null;
    videoThumbnail.value = null;
    selectedLocation.value = '';
    isReel.value = false;
    isLoading.value = false;
    postType.value = PostType.news;
    utility.clearAllMedia();
    utility.clearTags();
  }

  void onBack() {
    resetAll();
    Get.back();
  }

  void onTagLocation() async {
    locationSearchController.clear();
    filteredLocations.assignAll(allLocations);
    final result = await showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      builder: (context) => const TagLocationSheet(),
    );
    if (result != null && result is Map) {
      selectedLocation.value = result['city'] ?? "";
    }
  }

  void filterLocations(String query) {
    if (query.isEmpty) {
      filteredLocations.assignAll(allLocations);
    } else {
      filteredLocations.assignAll(
        allLocations.where((loc) =>
        loc['city']!.toLowerCase().contains(query.toLowerCase()) ||
            loc['zip']!.toLowerCase().contains(query.toLowerCase())),
      );
    }
  }

  final List<Map<String, String>> allLocations = [
    {'city': 'New York City', 'zip': 'NY, 100002'},
    {'city': 'Los Angeles', 'zip': 'CA, 90001'},
    {'city': 'Chicago', 'zip': 'IL, 60601'},
    {'city': 'Houston', 'zip': 'TX, 77001'},
    {'city': 'San Francisco', 'zip': 'CA, 94105'},
  ];
}