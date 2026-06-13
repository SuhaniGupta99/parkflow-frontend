import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/listing_model.dart';
import '../../providers/auth_provider.dart';
import '../../services/booking_service.dart';

class BookingScreen extends StatefulWidget {
  final ListingModel listing;

  const BookingScreen({
    super.key,
    required this.listing,
  });

  @override
  State<BookingScreen> createState() =>
      _BookingScreenState();
}

class _BookingScreenState
    extends State<BookingScreen> {

  DateTime? startTime;
  DateTime? endTime;

  bool isLoading = false;

  Future<void> createBooking() async {

    if (startTime == null ||
        endTime == null) {
      return;
    }

    try {
      setState(() {
        isLoading = true;
      });

      final token =
          Provider.of<AuthProvider>(
        context,
        listen: false,
      ).token!;
      print("TOKEN: $token");

      await BookingService()
          .createBooking(
        token: token,
        listingId: widget.listing.id,
        startTime: startTime!,
        endTime: endTime!,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            "Booking Created",
          ),
        ),
      );

      Navigator.pop(context);

    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> pickStartTime() async {
    final selected =
        await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      initialDate: DateTime.now(),
    );

    if (selected == null) return;

    setState(() {
      startTime = DateTime(
        selected.year,
        selected.month,
        selected.day,
        10,
      );
    });
  }

  Future<void> pickEndTime() async {
    final selected =
        await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      initialDate: DateTime.now(),
    );

    if (selected == null) return;

    setState(() {
      endTime = DateTime(
        selected.year,
        selected.month,
        selected.day,
        13,
      );
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Book Parking",
        ),
      ),
      body: Padding(
        padding:
            const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [

            Text(
              widget.listing.title,
              style:
                  const TextStyle(
                fontSize: 24,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(
              height: 12,
            ),

            Text(
              "₹${widget.listing.hourlyRate}/hour",
            ),

            const SizedBox(
              height: 20,
            ),

            ElevatedButton(
              onPressed:
                  pickStartTime,
              child: Text(
                startTime == null
                    ? "Select Start Date"
                    : startTime
                        .toString(),
              ),
            ),

            const SizedBox(
              height: 12,
            ),

            ElevatedButton(
              onPressed:
                  pickEndTime,
              child: Text(
                endTime == null
                    ? "Select End Date"
                    : endTime
                        .toString(),
              ),
            ),

            const SizedBox(
              height: 30,
            ),

            SizedBox(
              width:
                  double.infinity,
              child:
                  ElevatedButton(
                onPressed:
                    isLoading
                        ? null
                        : createBooking,
                child: isLoading
                    ? const CircularProgressIndicator()
                    : const Text(
                        "Confirm Booking",
                      ),
              ),
            )
          ],
        ),
      ),
    );
  }
}