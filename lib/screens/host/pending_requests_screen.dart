import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/booking_model.dart';
import '../../providers/auth_provider.dart';
import '../../services/booking_service.dart';

class PendingRequestsScreen
    extends StatefulWidget {
  const PendingRequestsScreen({
    super.key,
  });

  @override
  State<PendingRequestsScreen>
      createState() =>
          _PendingRequestsScreenState();
}

class _PendingRequestsScreenState
    extends State<
        PendingRequestsScreen> {

  List<BookingModel> bookings = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    loadRequests();
  }

  Future<void> loadRequests() async {
    try {
      final token =
          Provider.of<AuthProvider>(
        context,
        listen: false,
      ).token!;

      final response =
          await BookingService()
              .getPendingBookings(
        token,
      );

      final data =
          response.data as List;

      setState(() {
        bookings = data
            .map(
              (item) =>
                  BookingModel.fromJson(
                item,
              ),
            )
            .toList();

        isLoading = false;
      });
    } catch (e) {
      debugPrint(e.toString());

      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> approveBooking(
    int bookingId,
  ) async {
    final token =
        Provider.of<AuthProvider>(
      context,
      listen: false,
    ).token!;

    await BookingService()
        .approveBooking(
      token: token,
      bookingId: bookingId,
    );

    loadRequests();
  }

  Future<void> rejectBooking(
    int bookingId,
  ) async {
    final token =
        Provider.of<AuthProvider>(
      context,
      listen: false,
    ).token!;

    await BookingService()
        .rejectBooking(
      token: token,
      bookingId: bookingId,
    );

    loadRequests();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Pending Requests",
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
                    "No pending requests",
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
                      margin:
                          const EdgeInsets.only(
                        bottom: 12,
                      ),
                      child: Padding(
                        padding:
                            const EdgeInsets.all(
                          12,
                        ),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,
                          children: [

                            Text(
                              "Booking #${booking.id}",
                              style:
                                  const TextStyle(
                                fontWeight:
                                    FontWeight
                                        .bold,
                              ),
                            ),

                            Text(
                              "Listing ID: ${booking.listingId}",
                            ),

                            Text(
                              "Customer ID: ${booking.userId}",
                            ),

                            const SizedBox(
                              height: 12,
                            ),

                            Row(
                              children: [

                                Expanded(
                                  child:
                                      ElevatedButton(
                                    onPressed:
                                        () =>
                                            approveBooking(
                                      booking.id,
                                    ),
                                    child:
                                        const Text(
                                      "Approve",
                                    ),
                                  ),
                                ),

                                const SizedBox(
                                  width: 12,
                                ),

                                Expanded(
                                  child:
                                      ElevatedButton(
                                    onPressed:
                                        () =>
                                            rejectBooking(
                                      booking.id,
                                    ),
                                    child:
                                        const Text(
                                      "Reject",
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}