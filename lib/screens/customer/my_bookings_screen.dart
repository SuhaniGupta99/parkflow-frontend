import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'qr_scanner_screen.dart';
import '../../models/booking_model.dart';
import '../../providers/auth_provider.dart';
import '../../services/booking_service.dart';

class MyBookingsScreen extends StatefulWidget {
  const MyBookingsScreen({super.key});

  @override
  State<MyBookingsScreen> createState() =>
      _MyBookingsScreenState();
}

class _MyBookingsScreenState
    extends State<MyBookingsScreen> {

  List<BookingModel> bookings = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    loadBookings();
  }

  Future<void> loadBookings() async {
    try {
      final token =
          Provider.of<AuthProvider>(
        context,
        listen: false,
      ).token!;

      final response =
          await BookingService()
              .getMyBookings(token);

      final data =
          response.data as List;

      setState(() {
        bookings = data
            .map(
              (item) =>
                  BookingModel.fromJson(item),
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

  Color getStatusColor(
    String status,
  ) {
    switch (status) {
      case "PENDING":
        return Colors.orange;

      case "CONFIRMED":
        return Colors.green;

      case "REJECTED":
        return Colors.red;

      case "ACTIVE":
        return Colors.blue;

      case "EXIT_REQUESTED":
        return Colors.purple;

      case "COMPLETED":
        return Colors.grey;

      default:
        return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "My Bookings",
        ),
      ),
      body: isLoading
          ? const Center(
              child:
                  CircularProgressIndicator(),
            )
          : bookings.isEmpty
              ? const Center(
                  child: Text(
                    "No bookings found",
                  ),
                )
              : ListView.builder(
                  padding:
                      const EdgeInsets.all(
                    16,
                  ),
                  itemCount:
                      bookings.length,
                  itemBuilder:
                      (context, index) {

                    final booking =
                        bookings[index];

                    return Card(
  margin: const EdgeInsets.only(
    bottom: 12,
  ),
  elevation: 2,
  child: Padding(
    padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [

        Text(
          "Booking #${booking.id}",
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 8),

        Text(
          "Listing ID: ${booking.listingId}",
          style: const TextStyle(
            fontSize: 16,
          ),
        ),

        const SizedBox(height: 8),

        Text(
          booking.status,
          style: TextStyle(
            color: getStatusColor(
              booking.status,
            ),
            fontWeight:
                FontWeight.bold,
            fontSize: 16,
          ),
        ),
        if (booking.status == "COMPLETED")
  Padding(
    padding: const EdgeInsets.only(
      top: 8,
    ),
    child: Text(
      "Final Cost: ₹${booking.totalCost.toStringAsFixed(2)}",
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    ),
  ),
        const SizedBox(height: 12),

        if (booking.status ==
            "CONFIRMED")
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        QRScannerScreen(
                      bookingId:
                          booking.id,
                    ),
                  ),
                );
              },
              child: const Text(
                "Scan Entry QR",
              ),
            ),
          ),

        if (booking.status ==
            "ACTIVE")
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        QRScannerScreen(
                      bookingId:
                          booking.id,
                    ),
                  ),
                );
              },
              child: const Text(
                "Scan Exit QR",
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