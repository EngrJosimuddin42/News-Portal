import 'package:flutter/material.dart';

class CustomNetworkImage extends StatelessWidget {
  final String imageUrl;
  final double height;
  final double borderRadius;
  final BoxFit fit;

  const CustomNetworkImage({
    super.key,
    required this.imageUrl,
    this.height = 160,
    this.borderRadius = 10,
    this.fit = BoxFit.fitWidth,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Image.network( imageUrl, width: double.infinity, height: height, fit: fit,

        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(height: height,
            color: Colors.grey[100],
            child: const Center(
              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.red)),
          );
        },
        errorBuilder: (context, error, stackTrace) =>
            Container( height: height,  color: Colors.grey[200],
          child: const Icon(Icons.broken_image, color: Colors.grey))),
    );
  }
}