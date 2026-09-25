import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/listing_model.dart';
import '../../core/constants/api_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/common/pf_network_image.dart';
import 'booking_screen.dart';

class ParkingDetailsScreen extends StatelessWidget {
  final ListingModel listing;
  final String distance;
  const ParkingDetailsScreen({
    super.key,
    required this.listing,
    required this.distance,
  });

  Future<void> openMaps() async {
    final url = Uri.parse(
      "https://www.google.com/maps/search/?api=1&query=${listing.latitude},${listing.longitude}",
    );

    if (await canLaunchUrl(url)) {
      await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );
    }
  }

  IconData getAmenityIcon(String amenity) {
    switch (amenity) {
      case "CCTV":
        return Icons.videocam;
      case "Covered":
        return Icons.garage;
      case "EV Charging":
        return Icons.ev_station;
      case "Accessible":
        return Icons.accessible;
      case "24x7 Access":
        return Icons.schedule;
      case "Guarded":
        return Icons.security;
      case "Bike Parking":
        return Icons.pedal_bike;
      case "Lighting":
        return Icons.lightbulb;
      case "Car Wash":
        return Icons.local_car_wash;
      case "Valet":
        return Icons.local_parking;
      default:
        return Icons.check_circle;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff8f8f8),
      body: Stack(
        children: [

          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 110),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Stack(
                  children: [

                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(28),
                        bottomRight: Radius.circular(28),
                      ),
                      child: PFNetworkImage(
                        imageUrl: listing.imageUrl == null
                            ? null
                            : ApiConstants.baseUrl + listing.imageUrl!,
                        width: double.infinity,
                        height: 290,
                      ),
                    ),

                    Positioned(
                      top: 48,
                      left: 20,
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ),

                    Positioned(
                      top: 48,
                      right: 20,
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.favorite_border,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                Padding(
                  padding: const EdgeInsets.all(22),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Text(
                        listing.title,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Row(
                        children: [

                          const Icon(
                            Icons.location_on_outlined,
                            size: 18,
                            color: Colors.grey,
                          ),

                          const SizedBox(width: 6),

                          Expanded(
                            child: Text(
                              listing.address,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

Row(
  children: [

    const Icon(
      Icons.near_me_outlined,
      size: 18,
      color: Colors.grey,
    ),

    const SizedBox(width: 6),

    Text(
      distance,
      style: const TextStyle(
        color: Colors.grey,
        fontSize: 15,
      ),
    ),
  ],
),
                      const SizedBox(height: 24),

                      Row(
                        children: [

                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green.shade50,
                              borderRadius:
                                  BorderRadius.circular(30),
                            ),
                            child: Text(
                              "${listing.availableSpaces} Spots Left",
                              style: const TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          const Spacer(),

                          Text(
                            "₹${listing.hourlyRate.toInt()}",
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),

                          const Text(
                            "/hr",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 25),

                      const Text(
                        "Amenities",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                     Padding(
  padding: const EdgeInsets.only(top: 0, bottom: 0),
  child: GridView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),

    itemCount: listing.amenities.length,

    gridDelegate:
        const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 2.5,
    ),

    itemBuilder: (_, index) {
      final amenity = listing.amenities[index];

      return _AmenityCard(
        title: amenity,
        icon: getAmenityIcon(amenity),
      );
    },
  ),
),


 Container(
  padding: const EdgeInsets.all(18),

  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(18),
    boxShadow: const [
      BoxShadow(
        color: Colors.black12,
        blurRadius: 8,
      ),
    ],
  ),

  child: Row(
    children: [

      CircleAvatar(
        radius: 24,
        backgroundColor:
            Colors.green.shade100,

        child: const Icon(
          Icons.person,
          color: AppColors.primary,
        ),
      ),

      const SizedBox(width: 16),

      Expanded(
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            const Text(
              "Managed by",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 13,
              ),
            ),

            const SizedBox(height: 3),

            Text(
              listing.ownerName,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 17,
              ),
            ),
          ],
        ),
      ),

      const Text(
        "Superhost",
        style: TextStyle(
          color: Colors.grey,
          fontWeight: FontWeight.w600,
        ),
      ),
    ],
  ),
),            
 const SizedBox(height: 40),


                      const Text(
                        "About this Spot",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 12),

                      Text(
                        listing.description?.isNotEmpty == true
                            ? listing.description!
                            : "No description provided.",
                        style: const TextStyle(
                          fontSize: 16,
                          height: 1.6,
                        ),
                      ),

                      const SizedBox(height: 30),

                      
                    InkWell(
                        borderRadius:
                            BorderRadius.circular(18),
                        onTap: openMaps,
                        child: Container(
                          padding:
                              const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.circular(
                              18,
                            ),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 8,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [

                              Container(
                                padding:
                                    const EdgeInsets.all(
                                  12,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primary
                                      .withOpacity(.1),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.location_on,
                                  color:
                                      AppColors.primary,
                                ),
                              ),

                              const SizedBox(width: 13),

                              const Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment
                                          .start,
                                  children: [

                                    Text(
                                      "View Entrance Location",
                                      style: TextStyle(
                                        fontSize: 17,
                                        fontWeight:
                                            FontWeight.bold,
                                      ),
                                    ),

                                    SizedBox(height: 4),

                                    Text(
                                      "Open in Google Maps",
                                      style: TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const Icon(
                                Icons.chevron_right,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              child: Container(
                padding:
                    const EdgeInsets.all(18),
                decoration:
                    const BoxDecoration(
                  color: Colors.white,
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(
                      backgroundColor:
                          AppColors.primary,
                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(
                          16,
                        ),
                      ),
                    ),
                    onPressed: () {

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              BookingScreen(
                            listing: listing,
                          ),
                        ),
                      );

                    },
                    child: const Text(
                      "Book Now",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AmenityCard extends StatelessWidget {

  final String title;
  final IconData icon;

  const _AmenityCard({
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {

    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 14,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
  crossAxisAlignment: CrossAxisAlignment.center,
  children: [

    Icon(
      icon,
      color: AppColors.primary,
    ),

    const SizedBox(width: 10),

    Flexible(
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
  ],
),
    );
  }
}