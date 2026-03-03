import 'package:dio/dio.dart';
import '../constants/api_constants.dart';

/// Centralized HTTP gateway client for all API calls.
/// All services (auth, users) route through this single Dio instance.
class ApiClient {
  ApiClient({Dio? dio}) : _dio = dio ?? _buildDio();

  final Dio _dio;

  static Dio _buildDio() {
    return Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    )..interceptors.addAll([
        _AuthInterceptor(),
        LogInterceptor(
          request: false,
          requestHeader: false,
          responseBody: true,
          error: true,
        ),
      ]);
  }

  // ─── Auth ────────────────────────────────────────────────────────────────

  Future<void> sendOtp(String phoneNumber) async {
    await _dio.post(
      ApiConstants.sendOtp,
      data: {'phone': phoneNumber},
    );
  }

  Future<Map<String, dynamic>?> verifyOtp(
      String phoneNumber, String otp) async {
    final response = await _dio.post(
      ApiConstants.verifyOtp,
      data: {'phone': phoneNumber, 'otp': otp},
    );
    final data = response.data as Map<String, dynamic>?;
    return data;
  }

  Future<void> signOut(String? token) async {
    await _dio.post(
      ApiConstants.signOut,
      options: Options(headers: _bearerHeader(token)),
    );
  }

  // ─── Users ───────────────────────────────────────────────────────────────

  Future<Map<String, dynamic>> createUser(
      Map<String, dynamic> body) async {
    final response = await _dio.post(
      ApiConstants.usersBase,
      data: body,
    );
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getUser(String userId,
      {String? token}) async {
    final response = await _dio.get(
      ApiConstants.userById(userId),
      options: Options(headers: _bearerHeader(token)),
    );
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> updateUser(
      String userId, Map<String, dynamic> body,
      {String? token}) async {
    final response = await _dio.put(
      ApiConstants.userById(userId),
      data: body,
      options: Options(headers: _bearerHeader(token)),
    );
    return response.data as Map<String, dynamic>;
  }

  // ─── Helpers ─────────────────────────────────────────────────────────────

  Map<String, String>? _bearerHeader(String? token) {
    if (token == null || token.isEmpty) return null;
    return {'Authorization': 'Bearer $token'};
  }
}

/// Interceptor that automatically attaches the stored auth token to requests.
class _AuthInterceptor extends Interceptor {
  String? _token;

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) {
    if (_token != null &&
        !options.headers.containsKey('Authorization')) {
      options.headers['Authorization'] = 'Bearer $_token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    handler.next(err);
  }
}
