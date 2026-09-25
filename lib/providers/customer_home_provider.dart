import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../models/listing_model.dart';
import '../services/listing_service.dart';
import '../services/booking_service.dart';

class CustomerHomeProvider extends ChangeNotifier {
  final ListingService _listingService =
      ListingService();

  final BookingService _bookingService =
      BookingService();

  List<ListingModel> _listings = [];

Map<String, dynamic>? _activeBooking;

bool _isLoading = true;
List<ListingModel> get listings =>
    _listings;

Map<String, dynamic>? get activeBooking =>
    _activeBooking;

bool get isLoading =>
    _isLoading;
double? _userLatitude;
double? _userLongitude;

double? get userLatitude => _userLatitude;
double? get userLongitude => _userLongitude;
Future<void> _loadCurrentLocation() async {
  bool serviceEnabled =
      await Geolocator.isLocationServiceEnabled();

  if (!serviceEnabled) return;

  LocationPermission permission =
      await Geolocator.checkPermission();

  if (permission == LocationPermission.denied) {
    permission =
        await Geolocator.requestPermission();
  }

  if (permission ==
          LocationPermission.denied ||
      permission ==
          LocationPermission.deniedForever) {
    return;
  }

  final position =
      await Geolocator.getCurrentPosition();

  _userLatitude = position.latitude;
  _userLongitude = position.longitude;
}
  Future<void> loadListings() async {
  _isLoading = true;

  notifyListeners();
  await _loadCurrentLocation();
  try {
    final response =
        await _listingService
            .getAllListings();

    final data =
        response.data as List;

    _listings = data
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

  _isLoading = false;

  notifyListeners();
}

  Future<void> loadActiveBooking(
    String token,
  ) async {
    try {
      final response =
          await _bookingService
              .getMyBookings(token);

      final bookings =
          response.data as List;

      _activeBooking =
          bookings.cast<Map<String, dynamic>?>().firstWhere(
                (booking) =>
                    booking?["status"] ==
                        "ACTIVE" ||
                    booking?["status"] ==
                        "EXIT_REQUESTED",
                orElse: () => null,
              );

      notifyListeners();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> refresh(
  String token,
) async {
  _isLoading = true;

  notifyListeners();

  await Future.wait([
    loadListings(),
    loadActiveBooking(token),
  ]);

  _isLoading = false;

  notifyListeners();
}

  String get remainingTime {
    if (_activeBooking == null) {
      return "";
    }

    final endTime =
        DateTime.parse(
      _activeBooking!["end_time"],
    );

    final difference =
        endTime.difference(
      DateTime.now(),
    );

    if (difference.isNegative) {
      return "Overstayed";
    }

    final hours =
        difference.inHours;

    final minutes =
        difference.inMinutes % 60;

    return "${hours}h ${minutes}m";
  }
  String getDistance(
  ListingModel listing,
) {
  if (_userLatitude == null ||
      _userLongitude == null) {
    return "--";
  }

  final meters =
      Geolocator.distanceBetween(
    _userLatitude!,
    _userLongitude!,
    listing.latitude,
    listing.longitude,
  );

  if (meters < 1000) {
    return "${meters.round()} m";
  }

  return "${(meters / 1000).toStringAsFixed(1)} km";
}
}