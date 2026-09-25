import 'package:flutter/material.dart';

import '../../theme/app_text_styles.dart';
import '../../theme/app_colors.dart';

class PFSectionTitle extends StatelessWidget {

  final String title;

  final String? actionText;

  final VoidCallback? onTap;

  const PFSectionTitle({
    super.key,
    required this.title,
    this.actionText,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {

    return Row(

      mainAxisAlignment:
          MainAxisAlignment.spaceBetween,

      children: [

        Text(
          title,
          style: AppTextStyles.heading2,
        ),

        if (actionText != null)

          GestureDetector(

            onTap: onTap,

            child: Text(
              actionText!,
              style: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }
}