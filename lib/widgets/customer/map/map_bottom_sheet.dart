import 'package:flutter/material.dart';

import '../../../models/listing_model.dart';
import '../../../core/widgets/cards/pf_map_parking_card.dart';

class MapBottomSheet extends StatelessWidget {

  final ScrollController
      scrollController;
  final List<ListingModel> listings;

  final Function(ListingModel) onCardTap;

  final Function(ListingModel) onBook;
final String Function(
  ListingModel,
) distanceBuilder;
  const MapBottomSheet({
  super.key,
  required this.listings,
  required this.scrollController,
  required this.onCardTap,
  required this.onBook,
  required this.distanceBuilder,
});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 470,

        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(28),
          ),
        ),

        child: Column(
          children: [

            const SizedBox(height: 10),

            Container(
              width: 45,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius:
                    BorderRadius.circular(20),
              ),
            ),

            const SizedBox(height: 22),

           const Padding(
  padding: EdgeInsets.symmetric(
    horizontal: 20,
  ),
  child: Align(
    alignment: Alignment.centerLeft,
    child: Text(
      "Available Parking",
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w700,
      ),
    ),
  ),
),

            const SizedBox(height: 10),
            if (listings.isEmpty)
  const Expanded(
    child: Center(
      child: Text(
        "No nearby parking found",
      ),
    ),
  )
else
            Expanded(
              child: ListView.builder(
  controller:
      scrollController,
                scrollDirection: Axis.vertical,
padding: const EdgeInsets.only(
  left: 16,
  right: 16,
  bottom: 8,
),
                itemCount:
                    listings.length,

                itemBuilder:
                    (context, index) {

                  final listing =
                      listings[index];

                  return Padding(
  padding: const EdgeInsets.only(
    bottom: 0.5,
  ),
  child: GestureDetector(

                    onTap: () =>
                        onCardTap(
                      listing,
                    ),

                    child: Padding(
  padding: const EdgeInsets.only(
    bottom: 12,
  ),
  child: PFMapParkingCard(
  listing: listing,

  onBook: () =>
      onBook(listing),

  onNavigate: () {},

  distance: distanceBuilder(listing),
),
  ),
),
                  );
                },
              ),
            ),
          ],
        ),
      
    );
  }
}