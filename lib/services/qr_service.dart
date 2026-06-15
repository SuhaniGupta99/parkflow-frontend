import 'package:dio/dio.dart';

import '../core/constants/api_constants.dart';

class QRService {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
    ),
  );

  Future<Response> generateQR(
    int listingId,
  ) async {
    return await dio.post(
      "/qr/generate/$listingId",
    );
  }
}