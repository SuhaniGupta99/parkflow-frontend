import 'package:dio/dio.dart';

import '../core/constants/api_constants.dart';

class BookingService {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
    ),
  );

  Future<Response> createBooking({
    required String token,
    required int listingId,
    required DateTime startTime,
    required DateTime endTime,
  }) async {
    return await dio.post(
      "/bookings/",
      data: {
        "listing_id": listingId,
        "start_time": startTime.toIso8601String(),
        "end_time": endTime.toIso8601String(),
      },
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
        },
      ),
    );
  }
}