import 'dart:async';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/user_model.dart';

/// Mock implementation — replace with real API/Firebase calls.
class AuthRepositoryImpl implements AuthRepository {
  User? _currentUser;

  // Simulated registered users store
  final Map<String, UserModel> _users = {
    '9876543210': UserModel(
      id: 'u1',
      phone: '9876543210',
      name: 'Rahul Sharma',
      email: 'rahul@example.com',
      jobTitle: 'Software Engineer',
      company: 'TechCorp',
      experienceYears: 3,
      skills: ['Flutter', 'Dart', 'Firebase'],
    ),
  };

  @override
  Future<void> sendOtp(String phoneNumber) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    // In production: call backend / Firebase Auth
  }

  @override
  Future<User?> verifyOtp(String phoneNumber, String otp) async {
    await Future.delayed(const Duration(seconds: 1));
    // Mock: any 6-digit OTP is accepted
    if (otp.length != 6) {
      throw Exception('Invalid OTP');
    }
    final user = _users[phoneNumber];
    if (user != null) {
      _currentUser = user;
    }
    return user; // null means new user
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
