import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
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
  File? selectedImage;

  final List<String> selectedAmenities = [];

final List<String> availableAmenities = [
  "CCTV",
  "Covered",
  "EV Charging",
  "Accessible",
  "24x7 Access",
  "Guarded",
  "Car Wash",
  "Valet",
  "Bike Parking",
  "Lighting",
];

final ImagePicker picker =
    ImagePicker();
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

      final response =
    await ListingService()
        .createListing(
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

amenities:
    selectedAmenities,
);
if (selectedImage != null) {

  final listingId =
      response.data["id"];

  await ListingService()
      .uploadListingImage(
    token: token,
    listingId: listingId,
    imagePath:
        selectedImage!.path,
  );
}

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

  Future<void> pickImage() async {

  final XFile? image =
      await picker.pickImage(
    source: ImageSource.gallery,
    imageQuality: 80,
  );

  if (image == null) return;

  setState(() {
    selectedImage = File(
      image.path,
    );
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

const Align(
  alignment: Alignment.centerLeft,
  child: Text(
    "Amenities",
    style: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
    ),
  ),
),

const SizedBox(height: 10),

Wrap(
  spacing: 10,
  runSpacing: 10,
  children: availableAmenities.map((amenity) {
    final selected =
        selectedAmenities.contains(
      amenity,
    );

    return FilterChip(
      label: Text(amenity),

      selected: selected,

      onSelected: (value) {
        setState(() {
          if (value) {
            selectedAmenities.add(
              amenity,
            );
          } else {
            selectedAmenities.remove(
              amenity,
            );
          }
        });
      },
    );
  }).toList(),
),

const SizedBox(height: 20),
            const SizedBox(height: 10),

if (selectedImage != null)
  ClipRRect(
    borderRadius:
        BorderRadius.circular(12),
    child: Image.file(
      selectedImage!,
      height: 180,
      width: double.infinity,
      fit: BoxFit.cover,
    ),
  ),

const SizedBox(height: 12),

SizedBox(
  width: double.infinity,
  child: OutlinedButton.icon(
    onPressed: pickImage,
    icon: const Icon(
      Icons.photo,
    ),
    label: const Text(
      "Select Parking Image",
    ),
  ),
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