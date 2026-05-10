import 'package:timeago/timeago.dart' as timeago;

class UserModel {
  final String name;
  final String? username;
  final String? publisherMeta;
  final String email;
  final String? bio;
  final String? website;
  final String? gender;
  final String? birthYear;
  String? profileImageUrl;
  final String? location;
  final String? timeAgo;
  final bool isHighlighted;
  final DateTime createdAt;
  String get userName => username ?? name;
  String get userProfileImage => profileImageUrl ?? '';
  List<Map<String, String>> get userReactions => [];


  UserModel({
    required this.name,
    this.username,
    this.publisherMeta,
    required this.email,
    this.bio,
    this.website,
    this.gender,
    this.birthYear,
    this.profileImageUrl,
    this.location,
    this.timeAgo,
    this.isHighlighted = false,
    DateTime? createdAt,
  }): createdAt = createdAt ?? DateTime.now();

  String get formattedTime => timeago.format(createdAt, locale: 'en_short');
}