class ClipModel {
  final String title;
  final String subtitle;
  final String imageUrl;
  String userProfileImage;

   ClipModel({
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    this.userProfileImage = '',
  });
}