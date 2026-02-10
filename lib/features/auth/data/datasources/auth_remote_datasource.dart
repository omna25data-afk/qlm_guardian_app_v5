import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../models/user_model.dart';

/// Remote data source for authentication
class AuthRemoteDataSource {
  final ApiClient _apiClient;

  AuthRemoteDataSource(this._apiClient);

  /// Login with phone/email and password
  /// Matches Laravel AuthController::login
  Future<UserModel> login(String loginIdentifier, String password) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.login,
        data: {
          'login_identifier': loginIdentifier, // Backend expects this field
          'password': password,
        },
      );

      final data = response.data;

      // Token is at root level, user is nested
      final token = data['token'] ?? data['access_token'];
      final userData = data['user'] as Map<String, dynamic>?;
      final guardianData = data['guardian'] as Map<String, dynamic>?;

      if (userData == null) {
        throw AuthException('بيانات المستخدم غير متوفرة');
      }

      // Merge token and guardian info into user data for UserModel
      return UserModel.fromJson({
        ...userData,
        'token': token,
        'guardian': guardianData,
      });
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        final message =
            e.response?.data['message'] ?? 'بيانات الدخول غير صحيحة';
        throw AuthException(message);
      }
      if (e.response?.statusCode == 422) {
        final errors = e.response?.data['errors'];
        if (errors != null) {
          throw AuthException(_extractFirstError(errors));
        }
        final message = e.response?.data['message'];
        if (message != null) {
          throw AuthException(message);
        }
      }
      throw AuthException('حدث خطأ في الاتصال: ${e.message}');
    } catch (e) {
      if (e is AuthException) rethrow;
      throw AuthException('حدث خطأ غير متوقع');
    }
  }

  /// Logout
  /// Matches Laravel AuthController::logout
  Future<void> logout() async {
    try {
      await _apiClient.post(ApiEndpoints.logout);
    } catch (_) {
      // Ignore logout errors
    }
  }

  /// Get current user
  Future<UserModel?> getCurrentUser() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.user);
      return UserModel.fromJson(response.data);
    } catch (_) {
      return null;
    }
  }

  String _extractFirstError(Map<String, dynamic> errors) {
    for (final value in errors.values) {
      if (value is List && value.isNotEmpty) {
        return value.first.toString();
      }
    }
    return 'خطأ في البيانات المدخلة';
  }
}

/// Auth exception
class AuthException implements Exception {
  final String message;
  AuthException(this.message);

  @override
  String toString() => message;
}
