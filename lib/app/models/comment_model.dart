import 'dart:typed_data';

class CommentModel {
  final int id;
  final int reelId;
  final int? newsId;
  final String userName;
  final String userProfileImage;
  final String text;
  final String? gifUrl;
  final String? imagePath;
  final String location;
  final DateTime createdAt;
  final Uint8List? imageBytes;
  int likes;
  bool isLiked;
  bool? isFollowing;

  CommentModel({
    required this.id,
    required this.reelId,
    this.newsId,
    required this.userName,
    required this.userProfileImage,
    this.text = '',
    this.gifUrl,
    this.imagePath,
    this.location = '',
    required this.createdAt,
    this.imageBytes,
    this.likes = 0,
    this.isLiked = false,
    this.isFollowing = false,
  });
}