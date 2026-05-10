import 'package:timeago/timeago.dart' as timeago;

class SocialsModel {
  final int id;
  final String type = 'social';
  final String category;
  final String author;
  final String userImageUrl;
  final String text;
  final String publisherName;
  final String timeAgo;
  final List<String> imageUrls;
  final String likes;
  final String comments;
  final String shares;
  final DateTime createdAt;

  SocialsModel({
    required this.id,
    this.category = 'Social',
    required this.author,
    required this.userImageUrl,
    required this.text,
    required this.publisherName,
    required this.timeAgo,
    required this.imageUrls,
    this.likes = '5',
    this.comments = '3',
    this.shares = '2',
    DateTime? createdAt,
  }): createdAt = createdAt ?? DateTime.now();

  String get formattedTime => timeago.format(createdAt, locale: 'en_short');
}