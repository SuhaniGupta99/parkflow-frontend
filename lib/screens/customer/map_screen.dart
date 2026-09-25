import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'booking_screen.dart';
import '../../models/listing_model.dart';
import '../../services/listing_service.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../widgets/customer/map/map_bottom_sheet.dart';
import 'package:geolocator/geolocator.dart';
import '../../widgets/customer/map/map_filter_bar.dart';
import '../../widgets/customer/map/current_location_button.dart';
import '../../widgets/customer/map/map_search_bar.dart';
import '../../widgets/customer/map/parking_marker.dart';
import 'parking_details_screen.dart';
class MapScreen extends StatefulWidget {
  const MapScreen({
    super.key,
  });

  @override
  State<MapScreen> createState() =>
      _MapScreenState();
}

class _MapScreenState
    extends State<MapScreen> {
      List<ListingModel> listings = [];
List<ListingModel> filteredListings = [];

ListingModel? selectedListing;

bool isLoading = true;

String selectedFilter = "Nearest";

double? userLatitude;
double? userLongitude;
  final MapController mapController =
    MapController();
  final PanelController panelController =
    PanelController();
final TextEditingController searchController =
    TextEditingController();

  
Future<void> navigateToParking(
  ListingModel listing,
) async {

  final url = Uri.parse(
    "https://www.google.com/maps/dir/?api=1"
    "&destination=${listing.latitude},${listing.longitude}"
    "&travelmode=driving",
  );

  if (await canLaunchUrl(url)) {
    await launchUrl(
      url,
      mode:
          LaunchMode.externalApplication,
    );
  }
}

double calculateDistance(
  double lat,
  double lng,
) {
  if (userLatitude == null ||
      userLongitude == null) {
    return 0;
  }

  return Geolocator.distanceBetween(
        userLatitude!,
        userLongitude!,
        lat,
        lng,
      ) /
      1000;
}
String getDistanceString(
  ListingModel listing,
) {
  final distance = calculateDistance(
    listing.latitude,
    listing.longitude,
  );

  if (distance < 1) {
    return "${(distance * 1000).round()} m";
  }

  return "${distance.toStringAsFixed(1)} km";
}
void searchListings(
  String query,
) {

  if (query.isEmpty) {

    setState(() {
      filteredListings = List.from(listings);
    });

    return;
  }

  setState(() {

    filteredListings =
        listings.where(
      (listing) {

        return listing.title
                .toLowerCase()
                .contains(
                  query.toLowerCase(),
                ) ||
            listing.address
                .toLowerCase()
                .contains(
                  query.toLowerCase(),
                );
      },
    ).toList();
  });
}
@override
void initState() {
  super.initState();

  getCurrentLocation();
}

Future<void> getCurrentLocation() async {

  bool serviceEnabled =
      await Geolocator
          .isLocationServiceEnabled();

  if (!serviceEnabled) {
    return;
  }

  LocationPermission permission =
      await Geolocator
          .checkPermission();

  if (permission ==
      LocationPermission.denied) {

    permission =
        await Geolocator
            .requestPermission();
  }

  if (permission ==
          LocationPermission.denied ||
      permission ==
          LocationPermission.deniedForever) {
    return;
  }

  final position =
      await Geolocator
          .getCurrentPosition();

  setState(() {
  userLatitude = position.latitude;
  userLongitude = position.longitude;
});

 

  await loadNearbyListings();

  print(
    "USER LOCATION: "
    "$userLatitude , "
    "$userLongitude",
  );
}

Future<void> loadNearbyListings() async {
  try {

    print("Calling nearby API");

    final response =
        await ListingService()
            .getNearbyListings(
      latitude: userLatitude!,
      longitude: userLongitude!,
      radiusKm: 10,
    );

    print("Nearby response received");
    for (final item in response.data) {
  debugPrint(item.toString());
}

    final data =
        response.data as List;

    setState(() {

  listings = data
      .map(
        (item) =>
            ListingModel.fromJson(
              item,
            ),
      )
      .toList();

  filteredListings = List.from(listings);

  isLoading = false;
});
    WidgetsBinding.instance.addPostFrameCallback((_) {
  mapController.move(
    LatLng(
      userLatitude!,
      userLongitude!,
    ),
    15,
  );
});

    print(
      "Nearby listings count: ${listings.length}",
    );

  } catch (e) {

    print("NEARBY API ERROR:");
    print(e);

    setState(() {
      isLoading = false;
    });
  }
}
@override
void dispose() {
  searchController.dispose();
  super.dispose();
}
  @override
  Widget build(BuildContext context) {
   
    if (isLoading) {
      return const Scaffold(
        body: Center(
          child:
              CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
  body: SafeArea(
    child: SlidingUpPanel(

      controller: panelController,

      minHeight: 110,

      maxHeight:
    MediaQuery.of(context)
            .size
            .height *
        0.78,

      borderRadius:
          const BorderRadius.vertical(
        top: Radius.circular(28),
      ),

      panelBuilder:
          (scrollController) {

        return MapBottomSheet(
          listings: filteredListings,

          scrollController:
              scrollController,

          distanceBuilder: getDistanceString,
          onCardTap: (listing) {

           setState(() {
  selectedListing = listing;
});

            mapController.move(
              LatLng(
                listing.latitude,
                listing.longitude,
              ),
              17,
            );
            panelController.close();
          },

          onBook: (listing) {

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) =>
          ParkingDetailsScreen(
        listing: listing,
        distance: getDistanceString(listing),
      ),
    ),
  );

},
        );
      },

      body: Stack(
  children: [

    FlutterMap(
      mapController: mapController,
      options: const MapOptions(
        initialCenter: LatLng(
          28.6139,
          77.2090,
        ),
        initialZoom: 12,
      ),
      children: [

        TileLayer(
          urlTemplate:
              'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName:
              'com.example.parkflow_frontend',
        ),

        MarkerLayer(
          markers: [

            if (userLatitude != null &&
                userLongitude != null)
              Marker(
                point: LatLng(
                  userLatitude!,
                  userLongitude!,
                ),
                width: 50,
                height: 50,
                child: const Icon(
                  Icons.my_location,
                  color: Colors.blue,
                  size: 40,
                ),
              ),

            ...filteredListings.map(
  (listing) {

    final bool isSelected =
    selectedListing?.id ==
        listing.id;

    return Marker(
      point: LatLng(
        listing.latitude,
        listing.longitude,
      ),

      width: isSelected ? 70 : 60,
      height: isSelected ? 70 : 60,

      child: GestureDetector(
        onTap: () {
         setState(() {
  selectedListing = listing;
});

          mapController.move(
            LatLng(
              listing.latitude,
              listing.longitude,
            ),
            17,
          );
           panelController.close();
        },

        child: ParkingMarker(
          price: listing.hourlyRate,
          selected: isSelected,
        ),
      ),
    );
  },
),
          ],
        ),
      ],
    ),

    // Search Bar

   MapSearchBar(
  controller: searchController,
  onChanged: searchListings,
),
MapFilterBar(
  selectedFilter: selectedFilter,
  onSelected: (title) {
  setState(() {
    selectedFilter = title;

    if (title == "Nearest") {
      filteredListings.sort(
        (a, b) => calculateDistance(
          a.latitude,
          a.longitude,
        ).compareTo(
          calculateDistance(
            b.latitude,
            b.longitude,
          ),
        ),
      );
    } else if (title == "Cheapest") {
      filteredListings.sort(
        (a, b) => a.hourlyRate.compareTo(
          b.hourlyRate,
        ),
      );
    } else {
      filteredListings.sort(
        (a, b) => b.availableSpaces.compareTo(
          a.availableSpaces,
        ),
      );
    }
  });
},
),
    // Bottom Sheet
CurrentLocationButton(
  onPressed: () {
    if (userLatitude != null &&
        userLongitude != null) {
      mapController.move(
        LatLng(
          userLatitude!,
          userLongitude!,
        ),
        15,
      );
    }
  },
),

                 ],
  ),
),
  ),
);
  }
}