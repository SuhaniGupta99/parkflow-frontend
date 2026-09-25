import 'package:dio/dio.dart';

import '../core/constants/api_constants.dart';

class ListingService {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
    ),
  );

  Future createListing({
    required String token,
    required String title,
    required String address,
    required double latitude,
    required double longitude,
    required double hourlyRate,
    required int totalSpaces,
    required String description,
    required List<String> amenities,
  }) async {
    return await dio.post(
      "/listings/",
      data: {
        "title": title,
        "address": address,
        "latitude": latitude,
        "longitude": longitude,
        "hourly_rate": hourlyRate,
        "total_spaces": totalSpaces,
        "description": description,
        "amenities": amenities,
      },
      options: Options(
        headers: {
          "Authorization":
              "Bearer $token",
        },
      ),
    );
  }

  Future<Response> getMyListings(
    String token,
  ) async {
    return await dio.get(
      "/listings/my",
      options: Options(
        headers: {
          "Authorization":
              "Bearer $token",
        },
      ),
    );
  }
  Future<Response> getAllListings() async {
  return await dio.get(
    "/listings/",
  );
}
Future<Response> getNearbyListings({
  required double latitude,
  required double longitude,
  double radiusKm = 5,
}) async {
  return await dio.get(
    "/listings/nearby",
    queryParameters: {
      "latitude": latitude,
      "longitude": longitude,
      "radius_km": radiusKm,
    },
  );
}
Future<Response> uploadListingImage({
  required String token,
  required int listingId,
  required String imagePath,
}) async {

  FormData formData = FormData.fromMap({
    "image": await MultipartFile.fromFile(
      imagePath,
    ),
  });

  return await dio.post(
    "/listings/$listingId/image",
    data: formData,
    options: Options(
      headers: {
        "Authorization":
            "Bearer $token",
      },
    ),
  );
}
}