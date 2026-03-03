import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/user_model.dart';

/// Real implementation — calls https://api.vynce.cloud/api/auth
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({required ApiClient apiClient})
      : _apiClient = apiClient;

  final ApiClient _apiClient;
  User? _currentUser;
  String? _authToken;

  @override
  Future<void> sendOtp(String phoneNumber) async {
    try {
      await _apiClient.sendOtp(phoneNumber);
    } on DioException catch (e) {
      throw Exception(
          e.response?.data?['message'] ?? 'Failed to send OTP');
    }
  }

  @override
  Future<User?> verifyOtp(String phoneNumber, String otp) async {
    try {
      final data = await _apiClient.verifyOtp(phoneNumber, otp);
      if (data == null) return null;

      // API returns token + user (or null user for new number)
      _authToken = data['token'] as String?;
      final userJson = data['user'] as Map<String, dynamic>?;
      if (userJson == null) return null; // new user — needs registration

      final user = UserModel.fromJson(userJson);
      _currentUser = user;
      return user;
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;
      if (statusCode == 404) return null; // user not found → new user
      throw Exception(
          e.response?.data?['message'] ?? 'OTP verification failed');
    }
  }

  @override
  Future<User?> getCurrentUser() async => _currentUser;

  @override
  Future<void> signOut() async {
    try {
      await _apiClient.signOut(_authToken);
    } on DioException {
      // Ignore sign-out errors; clear local state regardless
    } finally {
      _currentUser = null;
      _authToken = null;
    }
  }

  /// Exposes the auth token so other repositories can use it.
  String? get authToken => _authToken;
}
