import 'package:flutter/material.dart';

import '../../../models/listing_model.dart';
import '../../constants/api_constants.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_shadows.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_text_styles.dart';

import '../buttons/pf_button.dart';
import '../common/pf_network_image.dart';

class PFHomeParkingCard extends StatelessWidget {
  final ListingModel listing;

  final VoidCallback onBook;

  final String distance;

  const PFHomeParkingCard({
    super.key,
    required this.listing,
    required this.onBook,
    required this.distance,
  });

@override
Widget build(BuildContext context) {
  return Container(
    width: 265,
    margin: const EdgeInsets.only(right: 16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(22),
      boxShadow: AppShadows.card,
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        // IMAGE
        Stack(
          children: [

            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(22),
              ),
              child: PFNetworkImage(
                imageUrl: listing.imageUrl == null
                    ? null
                    : ApiConstants.baseUrl + listing.imageUrl!,
                width: double.infinity,
                height: 145,
              ),
            ),

            
          ],
        ),

        Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Row(
                children: [

                  Expanded(
                    child: Text(
                      listing.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.title,
                    ),
                  ),

                  Text(
                    "₹${listing.hourlyRate.toInt()}/hr",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              Row(
                children: [

                  const Icon(
                    Icons.location_on_outlined,
                    size: 18,
                    color: Colors.black54,
                  ),

                  const SizedBox(width: 4),

                  Text(
                    distance,
                    style: AppTextStyles.body,
                  ),

                  const SizedBox(width: 18),

                  const Icon(
                    Icons.check_circle_outline,
                    size: 18,
                    color: Colors.black54,
                  ),

                  const SizedBox(width: 4),

                  Text(
                    "${listing.availableSpaces} spots left",
                    style: AppTextStyles.body,
                  ),
                ],
              ),

              const SizedBox(height: 18),

              SizedBox(
  width: double.infinity,
  height: 42,
  child: OutlinedButton(
    onPressed: onBook,
    style: OutlinedButton.styleFrom(
      side: const BorderSide(
        color: AppColors.primary,
      ),
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(14),
      ),
    ),
    child: const Text(
      "Book Now",
      style: TextStyle(
        color: AppColors.primary,
        fontWeight: FontWeight.w600,
      ),
    ),
  ),
),
            ],
          ),
        ),
      ],
    ),
  );
}
}