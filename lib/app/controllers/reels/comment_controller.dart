import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:news_break/app/controllers/reels/reels_controller.dart';
import 'package:news_break/app/controllers/social_interaction_controller.dart';
import '../../models/comment_model.dart';
import '../../models/comment_source.dart';
import '../../models/news_model.dart';
import '../auth/auth_controller.dart';

class CommentController extends GetxController {
  final RxList<CommentModel> commentsList = <CommentModel>[].obs;
  final RxBool isCommentsLoading = false.obs;
  final RxBool isSendingComment = false.obs;

  final TextEditingController commentTextController = TextEditingController();
  final Rx<File?> selectedImage = Rx<File?>(null);
  final Rx<Uint8List?> selectedImageBytes = Rx<Uint8List?>(null);
  final RxnString selectedGifUrl = RxnString();

  final Map<String, List<CommentModel>> _allCommentsCache = {};

  dynamic currentId;
  NewsModel? currentNews;
  CommentSource? currentSource;
  String currentTabType = 'news';
  String? currentAuthor;

  @override
  void onClose() {
    commentTextController.dispose();
    super.onClose();
  }

  void loadComments(dynamic id, CommentSource source,
      {String tabType = 'news', String? author, NewsModel? news}) {
    currentId = id;
    currentSource = source;
    currentTabType = tabType;
    currentAuthor = author;
    currentNews = news;

    final String key = _getCacheKey(id, source, tabType);

    if (_allCommentsCache.containsKey(key) &&
        _allCommentsCache[key]!.isNotEmpty) {
      commentsList.assignAll(_allCommentsCache[key]!);
    } else {
      fetchComments(id, source: source, tabType: tabType);
    }
  }


  String _getCacheKey(dynamic id, CommentSource source, [String tabType = 'news']) {
    return '${source.name}_${tabType}_$id';
  }


  Future<void> submitComment(dynamic id, {String? gifUrl, String? imagePath}) async {
    final String text = commentTextController.text.trim();
    if (text.isEmpty && gifUrl == null && imagePath == null) return;

    isSendingComment.value = true;

    final user = Get.find<AuthController>().user.value;
    final socialCtrl = Get.find<SocialInteractionController>();

    final newComment = CommentModel(
      id: DateTime.now().millisecondsSinceEpoch,
      reelId: (currentSource == CommentSource.reel) ? id : 0,
      newsId: (currentSource == CommentSource.news || currentSource == CommentSource.social) ? id : null,
      userName: user?.name ?? 'Guest',
      location: user?.location ?? 'Online',
      text: text,
      gifUrl: gifUrl,
      imagePath: imagePath,
      userProfileImage: user?.profileImageUrl ?? '',
      likes: 0,
      createdAt: DateTime.now(),
    );

    commentsList.insert(0, newComment);

    if (currentSource == CommentSource.reel) {
      socialCtrl.addComment(newComment);
    } else {
      socialCtrl.addNewsComment(newComment);
    }

    if ((currentSource == CommentSource.news || currentSource == CommentSource.social) && currentNews != null) {      if (!socialCtrl.commentedNewsItems.any((n) => n.id == currentNews!.id)) {
        socialCtrl.commentedNewsItems.add(currentNews!);
      }
    }

    final String key = _getCacheKey(id, currentSource ?? CommentSource.news, currentTabType);
    _allCommentsCache[key] = List.from(commentsList);

    socialCtrl.incrementCommentCount(id, source: currentTabType, author: currentAuthor);

    if (currentSource == CommentSource.reel && Get.isRegistered<ReelsController>()) {
      Get.find<ReelsController>().incrementComment(id);
    }

    commentTextController.clear();
    selectedGifUrl.value = null;
    selectedImage.value = null;
    selectedImageBytes.value = null;
    isSendingComment.value = false;

    FocusManager.instance.primaryFocus?.unfocus();
    Get.back();
  }



  Future<void> fetchComments(dynamic id,
      {CommentSource source = CommentSource.news, String tabType = 'news'}) async {
    try {
      isCommentsLoading(true);
      await Future.delayed(const Duration(milliseconds: 500));

      final dummyComments = [
        CommentModel(
          id: 101,
          reelId: 500,
          userName: 'Joser',
          location: 'New York',
          text: 'I wonder if they order that or not',
          userProfileImage: 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=200',
          likes: 1400,
          createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        ),
        CommentModel(
          id: 102,
          reelId: 600,
          userName: 'Zayan',
          location: 'London',
          text: 'This is a beautiful shot! 🔥',
          userProfileImage: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=200',
          likes: 850,
          createdAt: DateTime.now().subtract(const Duration(hours: 5)),
        ),
      ];

      commentsList.assignAll(dummyComments);

      final String key = _getCacheKey(id, source, tabType);
      _allCommentsCache[key] = List.from(dummyComments);
    } finally {
      isCommentsLoading(false);
    }
  }

  final List<String> reportReasons = [
    'Abusive or hateful',
    'Misleading or spam',
    'Violence or gory',
    'Sexual Content',
    'Minor safety',
    'Dangerous or criminal',
  ];
}