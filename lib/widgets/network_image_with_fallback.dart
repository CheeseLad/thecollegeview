import 'package:flutter/material.dart';

class NetworkImageWithFallback extends StatelessWidget {
  final String imageUrl;
  final String fallbackAssetPath;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;

  const NetworkImageWithFallback({
    super.key,
    required this.imageUrl,
    required this.fallbackAssetPath,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    Widget imageWidget = Image.network(
      imageUrl,
      width: width,
      height: height,
      fit: fit,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: borderRadius,
          ),
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: borderRadius,
          ),
          child: Image.asset(
            fallbackAssetPath,
            width: width,
            height: height,
            fit: fit,
            errorBuilder: (context, error, stackTrace) {
              // If even the fallback asset fails, show a placeholder icon
              return Container(
                width: width,
                height: height,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: borderRadius,
                ),
                child: const Icon(
                  Icons.image_not_supported,
                  color: Colors.grey,
                  size: 48,
                ),
              );
            },
          ),
        );
      },
    );

    if (borderRadius != null) {
      return ClipRRect(
        borderRadius: borderRadius!,
        child: imageWidget,
      );
    }

    return imageWidget;
  }
}
