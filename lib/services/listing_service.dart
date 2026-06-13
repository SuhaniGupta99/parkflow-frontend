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
}