import 'package:dio/dio.dart';

import '../core/constants/api_constants.dart';

class VehicleService {

  final Dio dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
    ),
  );

  Future<Response> getMyVehicles(
    String token,
  ) async {

    return await dio.get(
      "/vehicles/my",
      options: Options(
        headers: {
          "Authorization":
              "Bearer $token",
        },
      ),
    );
  }

  Future<Response> saveVehicle({
    required String token,
    required String vehicleType,
    required String makeModel,
    required String licensePlate,
    required bool isElectric,
    required String color,
    required bool isDefault,
  }) async {

    return await dio.post(
      "/vehicles/",
      data: {
        "vehicle_type": vehicleType,
        "make_model": makeModel,
        "license_plate": licensePlate,
        "is_electric": isElectric,
        "color": color,
        "is_default": isDefault,
      },
      options: Options(
        headers: {
          "Authorization":
              "Bearer $token",
        },
      ),
    );
  }

Future<void> updateVehicle({
  required String token,
  required int vehicleId,
  required String vehicleType,
  required String makeModel,
  required String licensePlate,
  required bool isElectric,
  required String color,
  required bool isDefault,
}) async {

  final response = await dio.put(
  "/vehicles/$vehicleId",
    data: {
      "vehicle_type": vehicleType,
      "make_model": makeModel,
      "license_plate": licensePlate,
      "is_electric": isElectric,
      "color": color,
      "is_default": isDefault,
    },
    options: Options(
      headers: {
        "Authorization": "Bearer $token",
      },
    ),
  );

  if (response.statusCode != 200) {
    throw Exception("Failed to update vehicle");
  }
}

 Future<void> deleteVehicle({
  required String token,
  required int vehicleId,
}) async {

  final response = await dio.delete(
    "/vehicles/$vehicleId",
    options: Options(
      headers: {
        "Authorization": "Bearer $token",
      },
    ),
  );

  if (response.statusCode != 200) {
    throw Exception(
      response.data["detail"] ?? "Failed to delete vehicle",
    );
  }
}
}