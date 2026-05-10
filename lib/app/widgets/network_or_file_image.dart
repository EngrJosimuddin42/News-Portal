import 'dart:io';
import 'package:flutter/material.dart';

class NetworkOrFileImage extends StatelessWidget {
  final String url;
  final double? height;
  final double? width;
  final BoxFit fit;
  final BorderRadius? borderRadius;

  const NetworkOrFileImage({
    super.key,
    required this.url,
    this.height,
    this.width,
    this.fit = BoxFit.cover,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    if (url.isEmpty) return const SizedBox.shrink();

    final image = url.startsWith('http')

        ? Image.network(
      url,  width: width, height: height, fit: fit,
      errorBuilder: (context, error, stackTrace) => _fallback())

        : Image.file(
      File(url), width: width, height: height, fit: fit,
      errorBuilder: (context, error, stackTrace) => _fallback(),
    );

    if (borderRadius != null) {
      return ClipRRect(borderRadius: borderRadius!, child: image);
    }
    return image;
  }

  Widget _fallback() {
    return Container( width: width,  height: height ?? 160,
      color: Colors.grey[900],
      child: const Icon(Icons.image, color: Colors.white24, size: 40),
    );
  }
}