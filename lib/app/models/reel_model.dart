import 'package:timeago/timeago.dart' as timeago;

class ReelModel {
  int? id;
  final String type = 'reel';
  String imageUrl;
  final String? videoUrl;
  String userProfileImage;
  String userName;
  String description;
  String? source;
  String? location;
  String? userSince;
  String totalPosts;
  String totalViews;
  String totalFollowers;
  int likes;
  int comments;
  int shares;
  bool isFollowing;
  bool isLiked;
  final DateTime createdAt;
  final List<Map<String, String>> userVideos;
  final List<Map<String, String>> userReactions;

  ReelModel({
    this.id,
    this.imageUrl = '',
    this.videoUrl,
    this.userName = '',
    this.userProfileImage = '',
    this.description = '',
    this.source,
    this.location,
    this.userSince,
    this.totalPosts = '0',
    this.totalViews = '0',
    this.totalFollowers = '0',
    this.likes = 0,
    this.comments = 0,
    this.shares = 0,
    this.isFollowing = false,
    this.isLiked = false,
    DateTime? createdAt,
    this.userVideos = const [],
    this.userReactions = const [],
  }): createdAt = createdAt ?? DateTime.now();

  String get formattedTime => timeago.format(createdAt, locale: 'en_short');
}