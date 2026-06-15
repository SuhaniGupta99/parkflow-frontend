import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'booking_screen.dart';
import '../../models/listing_model.dart';
import '../../providers/auth_provider.dart';
import '../../services/listing_service.dart';
import '../auth/login_screen.dart';
import 'qr_scanner_screen.dart';
import 'my_bookings_screen.dart';
class CustomerHomeScreen extends StatefulWidget {
  const CustomerHomeScreen({
    super.key,
  });

  @override
  State<CustomerHomeScreen> createState() =>
      _CustomerHomeScreenState();
}

class _CustomerHomeScreenState
    extends State<CustomerHomeScreen> {

  final ListingService listingService =
      ListingService();

  List<ListingModel> listings = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    loadListings();
  }

  Future<void> loadListings() async {
    try {
      final response =
          await listingService.getAllListings();

      final data =
          response.data as List;

      setState(() {
        listings = data
            .map(
              (item) =>
                  ListingModel.fromJson(item),
            )
            .toList();

        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Find Parking",
        ),
        actions: [

  IconButton(
    icon: const Icon(
      Icons.receipt_long,
    ),
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) =>
              const MyBookingsScreen(),
        ),
      );
    },
  ),
  

          IconButton(
            icon:
                const Icon(Icons.logout),
            onPressed: () async {

              await Provider.of<AuthProvider>(
                context,
                listen: false,
              ).logout();

              if (!context.mounted) return;

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      const LoginScreen(),
                ),
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(
              child:
                  CircularProgressIndicator(),
            )
          : ListView.builder(
              padding:
                  const EdgeInsets.all(16),
              itemCount: listings.length,
              itemBuilder:
                  (context, index) {

                final listing =
                    listings[index];

                return Card(
                  margin:
                      const EdgeInsets.only(
                    bottom: 16,
                  ),
                  elevation: 3,
                  child: Padding(
                    padding:
                        const EdgeInsets.all(
                      16,
                    ),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment
                              .start,
                      children: [

                        Text(
                          listing.title,
                          style:
                              const TextStyle(
                            fontSize: 20,
                            fontWeight:
                                FontWeight
                                    .bold,
                          ),
                        ),

                        const SizedBox(
                          height: 8,
                        ),

                        Text(
                          listing.address,
                        ),

                        const SizedBox(
                          height: 8,
                        ),

                        Text(
                          "₹${listing.hourlyRate}/hour",
                        ),

                        Text(
                          "Available Spaces: ${listing.availableSpaces}",
                        ),

                        const SizedBox(
                          height: 12,
                        ),

                        SizedBox(
                          width:
                              double.infinity,
                          child:
                              ElevatedButton(
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
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}