import 'dart:async';
import '../../../../core/data/dummy_data.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';

/// Dummy-data implementation — no API calls are made.
class AuthRepositoryImpl implements AuthRepository {
  User? _currentUser;

  final _users = DummyData.users;

  @override
  Future<void> sendOtp(String phoneNumber) async {
    await Future.delayed(const Duration(seconds: 1));
  }

  @override
  Future<User?> verifyOtp(String phoneNumber, String otp) async {
    await Future.delayed(const Duration(seconds: 1));
    if (otp.length != 6) {
      throw Exception('Invalid OTP');
    }
    final user = _users[phoneNumber];
    if (user != null) {
      _currentUser = user;
    }
    return user;
  }

  @override
  Future<User?> getCurrentUser() async {
    return _currentUser;
  }

  @override
  Future<void> signOut() async {
    _currentUser = null;
  }
}
