import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../models/news_model.dart';

class PublisherAvatar extends StatelessWidget {
  final double size;
  final String imageUrl;
  final String name;
  final BoxShape shape;

  // NewsModel
  PublisherAvatar.fromNews({
    super.key,
    required NewsModel news,
    this.size = 42.0,
    this.shape = BoxShape.circle,
  })  : imageUrl = news.publisherImageUrl,
        name = news.publisherName;

  // Direct URL (ShareSheet, ReelModel)
  const PublisherAvatar.fromUrl({
    super.key,
    required this.imageUrl,
    required this.name,
    this.size = 42.0,
    this.shape = BoxShape.circle,
  });

  @override
  Widget build(BuildContext context) {
    final borderRadius = shape == BoxShape.circle
        ? BorderRadius.circular(size)
        : BorderRadius.circular(12.r);

    return ClipRRect(
      borderRadius: borderRadius,
      child: SizedBox(
        width: size,
        height: size,
        child: (imageUrl.isNotEmpty && imageUrl.startsWith('http'))
            ? Image.network(
          imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => _buildFallbackAvatar())
            : Image.asset(
          imageUrl.isNotEmpty ? imageUrl : 'assets/images/publisher.png',
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => _buildFallbackAvatar())),
    );
  }

  Widget _buildFallbackAvatar() {
    return Container(
      width: size,
      height: size,
      color: Colors.grey[800],
      alignment: Alignment.center,
      child: Text(name.isNotEmpty ? name[0].toUpperCase() : '?',
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
    );
  }
}