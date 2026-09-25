import 'package:flutter/material.dart';

import '../../../models/listing_model.dart';

import '../../../core/widgets/cards/pf_home_parking_card.dart';
import '../../../core/widgets/common/pf_section_title.dart';

import '../../../core/theme/app_spacing.dart';

import '../../../screens/customer/parking_details_screen.dart';

class NearbyParkingSection extends StatelessWidget {

  final List<ListingModel> listings;

final String Function(
  ListingModel,
) distanceBuilder;
  const NearbyParkingSection({
  super.key,
  required this.listings,
  required this.distanceBuilder,
});

  @override
  Widget build(BuildContext context) {

    return Column(

      crossAxisAlignment:
          CrossAxisAlignment.start,

      children: [

        const PFSectionTitle(
  title: "Nearby Parking",
),

        const SizedBox(
          height: AppSpacing.md,
        ),

        SizedBox(
  height: 315,
  child: ListView.separated(
    scrollDirection: Axis.horizontal,
    itemCount: listings.length,
    separatorBuilder: (_, __) =>
        const SizedBox(width: 16),
    itemBuilder: (context, index) {
      final listing = listings[index];

      return PFHomeParkingCard(
  listing: listing,
  distance: distanceBuilder(listing),
  onBook: () {
          Navigator.push(
            context,
            MaterialPageRoute(
             builder: (_) =>
    ParkingDetailsScreen(
      listing: listing,
      distance: distanceBuilder(listing),
    ),
            ),
          );
        },
      );
    },
  ),
),
        
      ],
    );
  }
}