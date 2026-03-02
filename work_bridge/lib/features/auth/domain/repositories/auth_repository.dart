import '../entities/user.dart';

abstract class AuthRepository {
  /// Send OTP to the given phone number.
  Future<void> sendOtp(String phoneNumber);

  /// Verify the OTP. Returns [User] if account exists, null if new number.
  Future<User?> verifyOtp(String phoneNumber, String otp);

  /// Returns the currently authenticated user, or null.
  Future<User?> getCurrentUser();

  /// Sign out the current user.
  Future<void> signOut();
}
