import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../services/booking_service.dart';

class ExitRequestsScreen
    extends StatefulWidget {
  const ExitRequestsScreen({
    super.key,
  });

  @override
  State<ExitRequestsScreen>
      createState() =>
          _ExitRequestsScreenState();
}

class _ExitRequestsScreenState
    extends State<ExitRequestsScreen> {

  List requests = [];

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
              .getExitRequests(
        token,
      );

      setState(() {
        requests = response.data;
        isLoading = false;
      });
    } catch (e) {
      debugPrint(
        e.toString(),
      );

      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> confirmExit(
    int bookingId,
  ) async {
    final token =
        Provider.of<AuthProvider>(
      context,
      listen: false,
    ).token!;

    await BookingService()
        .confirmExit(
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
          "Exit Requests",
        ),
      ),
      body: isLoading
          ? const Center(
              child:
                  CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount:
                  requests.length,
              itemBuilder:
                  (context, index) {

                final booking =
                    requests[index];

                return Card(
                  margin:
                      const EdgeInsets.all(
                    12,
                  ),
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
                          "Booking #${booking["id"]}",
                          style:
                              const TextStyle(
                            fontSize: 18,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),

                        const SizedBox(
                          height: 8,
                        ),

                        Text(
                          booking["status"],
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
                              confirmExit(
                                booking["id"],
                              );
                            },
                            child: const Text(
                              "Confirm Exit",
                            ),
                          ),
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