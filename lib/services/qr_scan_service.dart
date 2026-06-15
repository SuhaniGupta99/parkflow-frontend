import 'package:dio/dio.dart';

import '../core/constants/api_constants.dart';

class QRScanService {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
    ),
  );

  Future<Response> scanQR({
    required String token,
    required int bookingId,
    required int listingId,
    required String qrType,
    required double latitude,
    required double longitude,
  }) async {
    return await dio.post(
      "/qr/scan",
      data: {
        "booking_id": bookingId,
        "listing_id": listingId,
        "qr_type": qrType,
        "latitude": latitude,
        "longitude": longitude,
      },
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
        },
      ),
    );
  }
}