import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class SocialUtilityController extends GetxController {
  static SocialUtilityController get to => Get.find();

  final RxString gifSearchQuery = ''.obs;
  final RxnString selectedGifUrl = RxnString();
  var selectedTags = <String>[].obs;
  final RxBool isGifPickerMode = false.obs;

  final TextEditingController commentTextController = TextEditingController();
  final Rx<File?> selectedImage = Rx<File?>(null);
  final Rx<Uint8List?> selectedImageBytes = Rx<Uint8List?>(null);


  String get tagsText => selectedTags.join(' ');


  List<String> get filteredGifImages {
    if (gifSearchQuery.value.isEmpty) return gifImages;
    return gifImages
        .where((url) => url.toLowerCase()
        .contains(gifSearchQuery.value.toLowerCase()))
        .toList();
  }


  void clearTags() => selectedTags.clear();

  void clearSelectedGif() => selectedGifUrl.value = null;

  void addEmoji(String emoji, TextEditingController textController) {
    textController.text += emoji; }

  void toggleTag(String tag) {
    if (selectedTags.contains(tag)) {
      selectedTags.remove(tag);
    } else {
      selectedTags.add(tag);
    }
  }

  void selectGif(String url) {
    selectedGifUrl.value = url;
    selectedImage.value = null;
    selectedImageBytes.value = null;
    gifSearchQuery.value = '';
    if (Get.isBottomSheetOpen ?? false) Get.back();
  }

  void clearAllMedia() {
    selectedImage.value = null;
    selectedImageBytes.value = null;
    selectedGifUrl.value = null;
    gifSearchQuery.value = '';
  }


  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final bytes = await image.readAsBytes();
      selectedImageBytes.value = bytes;
      selectedImage.value = kIsWeb ? null : File(image.path);
      selectedGifUrl.value = null;
    }
  }


  // Emoji & Reactions
  final List<String> reactions =  ['❤️', '😂', '😮', '😍', '😢', '🔥', '👏', '🙌', '👍', '💯', '✨', '🙏', '😊', '😡', '❤️‍🔥', 'ℹ️'];

  // Tags Logic (Hashtags)
  final List<String> trendingTags = ['#News', '#Tech', '#Flutter', '#Bangladesh', '#Breaking', '#Politics', '#Sports', '#Entertainment', '#Health', '#Food', '#Travel', '#Weather',];

  // Gift Images
  final List<String> gifImages = [
    'https://images.unsplash.com/photo-1482961674540-0b0e8363a005?w=200',
    'https://images.unsplash.com/photo-1484406566174-9da000fda645?w=200',
    'https://images.unsplash.com/photo-1543466835-00a7907e9de1?w=200',
    'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200',
    'https://images.unsplash.com/photo-1617854818583-09e7f077a156?w=200',
    'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200',
    'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=200',
    'https://images.unsplash.com/photo-1441986300917-64674bd600d8?w=200',
    'https://images.unsplash.com/photo-1490750967868-88df5691cc13?w=200',
  ];

}
