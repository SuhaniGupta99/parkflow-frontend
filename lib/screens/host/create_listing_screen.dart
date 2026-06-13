import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../services/listing_service.dart';

class CreateListingScreen extends StatefulWidget {
  const CreateListingScreen({super.key});

  @override
  State<CreateListingScreen> createState() =>
      _CreateListingScreenState();
}

class _CreateListingScreenState
    extends State<CreateListingScreen> {

  final titleController =
      TextEditingController();

  final addressController =
      TextEditingController();

  final latitudeController =
      TextEditingController();

  final longitudeController =
      TextEditingController();

  final rateController =
      TextEditingController();

  final spacesController =
      TextEditingController();

  final descriptionController =
      TextEditingController();

  bool isLoading = false;

  Future<void> createListing() async {
    try {
      setState(() {
        isLoading = true;
      });

      final token =
          Provider.of<AuthProvider>(
        context,
        listen: false,
      ).token!;

      await ListingService().createListing(
        token: token,
        title: titleController.text,
        address: addressController.text,
        latitude: double.parse(
          latitudeController.text,
        ),
        longitude: double.parse(
          longitudeController.text,
        ),
        hourlyRate: double.parse(
          rateController.text,
        ),
        totalSpaces: int.parse(
          spacesController.text,
        ),
        description:
            descriptionController.text,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            "Listing Created",
          ),
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            "Error: $e",
          ),
        ),
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  Widget buildField(
    String label,
    TextEditingController controller,
  ) {
    return Padding(
      padding:
          const EdgeInsets.only(
        bottom: 12,
      ),
      child: TextField(
        controller: controller,
        decoration:
            InputDecoration(
          labelText: label,
          border:
              const OutlineInputBorder(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text("Create Listing"),
      ),
      body: SingleChildScrollView(
        padding:
            const EdgeInsets.all(16),
        child: Column(
          children: [

            buildField(
              "Title",
              titleController,
            ),

            buildField(
              "Address",
              addressController,
            ),

            buildField(
              "Latitude",
              latitudeController,
            ),

            buildField(
              "Longitude",
              longitudeController,
            ),

            buildField(
              "Hourly Rate",
              rateController,
            ),

            buildField(
              "Total Spaces",
              spacesController,
            ),

            buildField(
              "Description",
              descriptionController,
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed:
                    isLoading
                        ? null
                        : createListing,
                child: isLoading
                    ? const CircularProgressIndicator()
                    : const Text(
                        "Create Listing",
                      ),
              ),
            )
          ],
        ),
      ),
    );
  }
}