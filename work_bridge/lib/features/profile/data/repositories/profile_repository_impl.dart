import 'package:dio/dio.dart';
import '../../../auth/domain/entities/user.dart';
import '../../../auth/data/models/user_model.dart';
import '../../../../core/network/api_client.dart';
import '../../domain/repositories/profile_repository.dart';

/// Real implementation — calls https://api.vynce.cloud/api/users
class ProfileRepositoryImpl implements ProfileRepository {
  ProfileRepositoryImpl({
    required ApiClient apiClient,
    required String userId,
    String? authToken,
  })  : _apiClient = apiClient,
        _userId = userId,
        _authToken = authToken;

  final ApiClient _apiClient;
  final String _userId;
  final String? _authToken;

  @override
  Future<User?> getProfile() async {
    try {
      final data =
          await _apiClient.getUser(_userId, token: _authToken);
      return UserModel.fromJson(data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) return null;
      throw Exception(
          e.response?.data?['message'] ?? 'Failed to load profile');
    }
  }

  @override
  Future<void> updateProfile(User user) async {
    try {
      final model = user is UserModel ? user : _toModel(user);
      await _apiClient.updateUser(
        _userId,
        model.toJson(),
        token: _authToken,
      );
    } on DioException catch (e) {
      throw Exception(
          e.response?.data?['message'] ?? 'Failed to update profile');
    }
  }

  @override
  Future<void> uploadResume(String filePath) async {
    try {
      await _apiClient.updateUser(
        _userId,
        {'resumeUrl': filePath},
        token: _authToken,
      );
    } on DioException catch (e) {
      throw Exception(
          e.response?.data?['message'] ?? 'Failed to upload resume');
    }
  }

  @override
  Future<void> toggleResumeVisibility(bool isVisible) async {
    try {
      await _apiClient.updateUser(
        _userId,
        {'resumeVisible': isVisible},
        token: _authToken,
      );
    } on DioException catch (e) {
      throw Exception(
          e.response?.data?['message'] ??
              'Failed to update resume visibility');
    }
  }

  UserModel _toModel(User u) => UserModel(
        id: u.id,
        phone: u.phone,
        name: u.name,
        email: u.email,
        dateOfBirth: u.dateOfBirth,
        gender: u.gender,
        jobTitle: u.jobTitle,
        company: u.company,
        experienceYears: u.experienceYears,
        skills: u.skills,
        resumeUrl: u.resumeUrl,
      );
}
