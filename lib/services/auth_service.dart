import 'package:dio/dio.dart';
import '../core/constants/api_constants.dart';

class AuthService {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
    ),
  );

  Future register({
    required String fullName,
    required String email,
    required String phoneNumber,
    required String role,
    required String password,
  }) async {
    return await dio.post(
      "/auth/register",
      data: {
        "full_name": fullName,
        "email": email,
        "phone_number": phoneNumber,
        "role": role,
        "password": password,
      },
    );
  }

  Future<Response> login({
    required String email,
    required String password,
  }) async {
    return await dio.post(
      "/auth/login",
      data: {
        "email": email,
        "password": password,
      },
    );
  }

  Future<Response> getMe(String token) async {
    return await dio.get(
      "/auth/me",
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
        },
      ),
    );
  }
}