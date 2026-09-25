import 'package:flutter/material.dart';

import '../../theme/app_radius.dart';

class PFNetworkImage extends StatelessWidget {
  final String? imageUrl;
  final double height;
  final double width;

  const PFNetworkImage({
    super.key,
    required this.imageUrl,
    required this.height,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null || imageUrl!.isEmpty) {
      return ClipRRect(
        borderRadius: AppRadius.large,
        child: Container(
          height: height,
          width: width,
          color: Colors.grey.shade300,
          child: const Center(
            child: Icon(
              Icons.local_parking,
              size: 45,
            ),
          ),
        ),
      );
    }

    return ClipRRect(
      borderRadius: AppRadius.large,
      child: Image.network(
        imageUrl!,
        height: height,
        width: width,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          debugPrint("IMAGE LOAD ERROR");
          debugPrint("URL: $imageUrl");
          debugPrint(error.toString());

          return Container(
            height: height,
            width: width,
            color: Colors.grey.shade300,
            child: const Center(
              child: Icon(
                Icons.local_parking,
                size: 45,
              ),
            ),
          );
        },
      ),
    );
  }
}