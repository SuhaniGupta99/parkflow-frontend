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

  Future<Response> getMyBookings(
  String token,
) async {
  return await dio.get(
    "/bookings/my",
    options: Options(
      headers: {
        "Authorization":
            "Bearer $token",
      },
    ),
  );
}
Future<Response> getPendingBookings(
  String token,
) async {
  return await dio.get(
    "/bookings/pending",
    options: Options(
      headers: {
        "Authorization":
            "Bearer $token",
      },
    ),
  );
}

Future<Response> getExitRequests(
  String token,
) async {
  return await dio.get(
    "/bookings/exit-requests",
    options: Options(
      headers: {
        "Authorization":
            "Bearer $token",
      },
    ),
  );
}

Future<Response> approveBooking({
  required String token,
  required int bookingId,
}) async {
  return await dio.post(
    "/bookings/$bookingId/approve",
    options: Options(
      headers: {
        "Authorization":
            "Bearer $token",
      },
    ),
  );
}

Future<Response> rejectBooking({
  required String token,
  required int bookingId,
}) async {
  return await dio.post(
    "/bookings/$bookingId/reject",
    options: Options(
      headers: {
        "Authorization":
            "Bearer $token",
      },
    ),
  );
}


Future<Response> confirmExit({
  required String token,
  required int bookingId,
}) async {
  return await dio.post(
    "/bookings/$bookingId/confirm-exit",
    options: Options(
      headers: {
        "Authorization":
            "Bearer $token",
      },
    ),
  );
}

}