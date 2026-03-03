class ApiConstants {
  ApiConstants._();

  static const String baseUrl = 'https://api.vynce.cloud';

  // Auth service
  static const String authBase = '/api/auth';
  static const String sendOtp = '$authBase/send-otp';
  static const String verifyOtp = '$authBase/verify-otp';
  static const String signOut = '$authBase/sign-out';

  // User service
  static const String usersBase = '/api/users';

  static String userById(String id) => '$usersBase/$id';
}
