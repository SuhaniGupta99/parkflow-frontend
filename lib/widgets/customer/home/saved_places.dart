import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

class SavedPlaces extends StatelessWidget {
  const SavedPlaces({super.key});

  Widget placeCard(
    IconData icon,
    String title,
  ) {
    return Container(
      width: 96,
height: 118,
      padding: const EdgeInsets.symmetric(
  vertical: 18,
),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadius.large,
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: Column(
  mainAxisAlignment:
      MainAxisAlignment.center,
  children: [

          CircleAvatar(
            radius: 24,
            backgroundColor:
                AppColors.primaryLight,
            child: Icon(
              icon,
              color: AppColors.primary,
            ),
          ),

          const SizedBox(
            height: AppSpacing.sm,
          ),

          Text(
            title,
            style:
                AppTextStyles.body.copyWith(
  fontWeight: FontWeight.w600,
).copyWith(
              color:
                  AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,

      children: [

        Text(
          "Saved Places",
          style:
              AppTextStyles.heading2,
        ),

        const SizedBox(
  height: 20,
),

       SingleChildScrollView(
  scrollDirection: Axis.horizontal,
  child: Row(
    children: [

      placeCard(
        Icons.home_rounded,
        "Home",
      ),

      const SizedBox(width: 16),

      placeCard(
        Icons.work_rounded,
        "Work",
      ),

      const SizedBox(width: 16),

      placeCard(
        Icons.school_rounded,
        "College",
      ),

      const SizedBox(width: 16),

      placeCard(
        Icons.favorite_rounded,
        "Saved",
      ),
    ],
  ),
),
      ],
    );
  }
}