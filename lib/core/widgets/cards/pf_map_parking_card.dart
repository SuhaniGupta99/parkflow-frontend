import 'package:flutter/material.dart';

import '../../../models/listing_model.dart';
import '../../constants/api_constants.dart';
import '../../theme/app_colors.dart';

import '../../theme/app_shadows.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_text_styles.dart';

import '../common/pf_network_image.dart';

class PFMapParkingCard extends StatelessWidget {
  final ListingModel listing;

  final VoidCallback onBook;

  final VoidCallback? onNavigate;

  final String? distance;

  const PFMapParkingCard({
    super.key,
    required this.listing,
    required this.onBook,
    this.onNavigate,
    this.distance,
  });

  @override
Widget build(BuildContext context) {
  
  
  debugPrint("-----------------------");
  debugPrint(listing.title);
  debugPrint("Image URL: ${listing.imageUrl}");
  debugPrint("Full URL: ${ApiConstants.baseUrl}${listing.imageUrl}");

  return Container(
    margin: EdgeInsets.zero,
    padding: const EdgeInsets.only(
      left: 8,
    ),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(28),
      boxShadow: AppShadows.card,
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [

        ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: PFNetworkImage(
            imageUrl: listing.imageUrl == null
                ? null
                : ApiConstants.baseUrl +
                    listing.imageUrl!,
            width: 115,
            height: 115,
          ),
        ),

        const SizedBox(width: 2),

        Expanded(
  child: Padding(
    padding: const EdgeInsets.fromLTRB(
      16,
      16,
      10,
      10,
    ),
    child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [

              Text(
                listing.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.title1,
              ),

              const SizedBox(height: 6),

              Row(
                children: [

                  const Icon(
                    Icons.location_on_outlined,
                    size: 15,
                    color: Colors.grey,
                  ),

                  const SizedBox(width: 3),

                  Text(
                    distance ?? "--",
                    style: AppTextStyles.caption,
                  ),

                  const Text(
                    " • ",
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),

                  Text(
                    "₹${listing.hourlyRate.toInt()}/hr",
                    style: AppTextStyles.caption,
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Row(
                children: [

                  Icon(
                    Icons.circle,
                    size: 7,
                    color: listing.availableSpaces > 5
                        ? Colors.green
                        : Colors.orange,
                  ),

                  const SizedBox(width: 8),

                  Expanded(
  child: Text(
  "${listing.availableSpaces} Spots\nAvailable",
  maxLines: 2,
  softWrap: true,
  style: TextStyle(
    fontSize: 12,
    height: 1.3,
    color: listing.availableSpaces <= 5
        ? Colors.orange
        : Colors.green,
    fontWeight: FontWeight.w600,
  ),
),
),

                  const SizedBox(width: 10),

                  OutlinedButton(
                    onPressed: onBook,
                    style: OutlinedButton.styleFrom(
                      foregroundColor:
                          AppColors.primary,
                      side: const BorderSide(
                        color: AppColors.primary,
                      ),
                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(
                          24,
                        ),
                      ),
                      padding:
                          const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 10,
                      ),
                    ),
                    child: const Text(
                      "View Details",
                    ),
                  ),
                ],
              ),
            ],
                   ),
        ),
      ),
    ],
  ),
  );
}
}