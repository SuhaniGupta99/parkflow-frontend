import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/listing_model.dart';
import '../../providers/auth_provider.dart';
import '../../services/listing_service.dart';

class MyListingsScreen
    extends StatefulWidget {
  const MyListingsScreen({
    super.key,
  });

  @override
  State<MyListingsScreen> createState() =>
      _MyListingsScreenState();
}

class _MyListingsScreenState
    extends State<MyListingsScreen> {

  List<ListingModel> listings = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    loadListings();
  }

  Future<void> loadListings() async {
    try {
      final token =
          Provider.of<AuthProvider>(
        context,
        listen: false,
      ).token!;

      final response =
          await ListingService()
              .getMyListings(token);

      listings =
          (response.data as List)
              .map(
                (item) =>
                    ListingModel.fromJson(
                  item,
                ),
              )
              .toList();
    } catch (e) {
      debugPrint(e.toString());
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text("My Listings"),
      ),
      body: isLoading
          ? const Center(
              child:
                  CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount:
                  listings.length,
              itemBuilder:
                  (context, index) {
                final listing =
                    listings[index];

                return Card(
                  child: ListTile(
                    title:
                        Text(
                      listing.title,
                    ),
                    subtitle:
                        Text(
                      listing.address,
                    ),
                    trailing:
                        Text(
                      "₹${listing.hourlyRate}/hr",
                    ),
                  ),
                );
              },
            ),
    );
  }
}