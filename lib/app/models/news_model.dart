import 'package:timeago/timeago.dart' as timeago;

class NewsModel {
  final int id;
  final String type = 'news';
  final String category;
  final String title;
  final String subtitle;
  final String author;
  final String timeAgo;
  final String publisherName;
  final String publisherMeta;
  final String? publisherType;
  String? totalFollowers;
  final String publisherImageUrl;
  final String imageUrl;
  final String? secondaryImageUrl;
  final String? secondarySubtitle;
  final String? videoUrl;
  final String imageCaption;
  final String body;
  final String likes;
  final String comments;
  final String shares;
  final String reactions;
  final bool isVerified;
  bool isFollowing;
  final DateTime createdAt;

  NewsModel({
    required this.id,
    required this.category,
    required this.title,
    this.subtitle = '',
    required this.author,
    required this.timeAgo,
    required this.publisherName,
    required this.publisherMeta,
    this.publisherType,
    this.totalFollowers = '0',
    this.publisherImageUrl = 'assets/images/publisher.png',
    required this.imageUrl,
    this.secondaryImageUrl,
    this.secondarySubtitle,
    this.videoUrl,
    this.imageCaption = '',
    required this.body,
    this.likes = '20',
    this.comments = '15',
    this.shares = '10',
    this.reactions = '5',
    this.isVerified = true,
    this.isFollowing = false,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  // timeago formatted string
  String get formattedTime => timeago.format(createdAt, locale: 'en_short');
}