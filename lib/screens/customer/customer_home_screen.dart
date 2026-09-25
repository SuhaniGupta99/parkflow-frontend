import 'package:flutter/material.dart';
import '../../providers/auth_provider.dart';
import '../../providers/customer_home_provider.dart';
import 'package:provider/provider.dart';
import '../../widgets/customer/home/home_header.dart';
import '../../widgets/customer/home/saved_places.dart';
import '../../widgets/customer/home/active_booking_card.dart';
import '../../widgets/customer/home/nearby_parking_section.dart';
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



@override
void initState() {
  super.initState();

  WidgetsBinding.instance
      .addPostFrameCallback((_) async {
    final provider =
        Provider.of<CustomerHomeProvider>(
      context,
      listen: false,
    );

    final token =
        Provider.of<AuthProvider>(
      context,
      listen: false,
    ).token!;

   await Future.wait([
  provider.loadListings(),
  provider.loadActiveBooking(token),
]);

if (!mounted) return;
  });
}

  
  @override
  Widget build(
    BuildContext context,
  ) {
    final provider =
    context.watch<CustomerHomeProvider>();
    return Scaffold(
      backgroundColor:
          const Color(0xfff8f8f8),

      body: provider.isLoading
          ? const Center(
              child:
                  CircularProgressIndicator(),
            )
          : SafeArea(
              child:
                  SingleChildScrollView(
                padding:
                    const EdgeInsets.all(
                  20,
                ),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,
                  children: [

                    const HomeHeader(),

                    const SizedBox(
                      height: 30,
                    ),
                    if (provider.activeBooking != null) ...[

  ActiveBookingCard(

    booking: provider.activeBooking!,

    remainingTime:
        provider.remainingTime,

    onExtend: () {

    },

    onNavigate: () {

    },
  ),

  const SizedBox(height: 24),
],
                    const SavedPlaces(),

const SizedBox(
  height: 24,
),

NearbyParkingSection(
  listings: provider.listings,
  distanceBuilder: provider.getDistance,
),

                  ],
                ),
              ),
            ),
    );
  }
}