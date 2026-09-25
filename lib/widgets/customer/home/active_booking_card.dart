import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

class ActiveBookingCard extends StatelessWidget {

  final Map<String, dynamic> booking;

  final String remainingTime;

  final VoidCallback onExtend;

  final VoidCallback onNavigate;

  const ActiveBookingCard({
    super.key,
    required this.booking,
    required this.remainingTime,
    required this.onExtend,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {

    final bool active =
        booking["status"] == "ACTIVE";
      
    final String parkingName =
    booking["listing_title"] ??
    "Your Parking";

final String status =
    active
        ? "Checked In"
        : "Exit Requested";
    return Container(

     padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(

        color: Colors.white,

        borderRadius:
            AppRadius.large,

        boxShadow:
            AppShadows.card,
      ),

      child: Column(

        crossAxisAlignment:
            CrossAxisAlignment.start,

            children: [

              

                 Row(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [

    Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Text(
            "ACTIVE SESSION",
            style: AppTextStyles.caption.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w700,
              letterSpacing: 1,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            parkingName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.heading2,
          ),
        ],
      ),
    ),

    const SizedBox(width: 16),

    Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [

        const Icon(
          Icons.access_time,
          size: 18,
          color: AppColors.primary,
        ),

        const SizedBox(height: 4),

        Text(
          remainingTime,
          style: AppTextStyles.title.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),

        Text(
          "remaining",
          style: AppTextStyles.caption,
        ),
      ],
    ),
  ],
),

          const SizedBox(
            height: AppSpacing.md,
          ),

          Row(
  children: [

    Icon(
      Icons.circle,
      size: 10,
      color:
          active
              ? Colors.green
              : Colors.orange,
    ),

    const SizedBox(width: 8),

    Text(
      status,
      style: const TextStyle(
        fontWeight:
            FontWeight.w600,
      ),
    ),
  ],
),

          const SizedBox(
            height: AppSpacing.lg,
          ),

      Row(
  children: [

    Expanded(
      child: OutlinedButton.icon(
  style: OutlinedButton.styleFrom(
    minimumSize: const Size(0, 46),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
  ),
        onPressed: onExtend,
        icon: const Icon(
          Icons.add,
        ),
        label: const Text(
          "Extend",
        ),
      ),
    ),

    const SizedBox(width: 12),

    Expanded(
      child: ElevatedButton.icon(
  style: ElevatedButton.styleFrom(
    backgroundColor: AppColors.primary,
    minimumSize: const Size(0, 46),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
  ),
        onPressed: onNavigate,
        icon: const Icon(
          Icons.navigation,
          color: Colors.white,
        ),
        label: const Text(
          "Navigate",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    ),
  ],
),
        ],
      ),
    );
  }
}