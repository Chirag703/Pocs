import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../domain/repositories/registration_repository.dart';

/// Real implementation — POSTs new user to https://api.vynce.cloud/api/users
class RegistrationRepositoryImpl implements RegistrationRepository {
  RegistrationRepositoryImpl({required ApiClient apiClient})
      : _apiClient = apiClient;

  final ApiClient _apiClient;

  @override
  Future<void> register({
    required String phone,
    required String name,
    required String email,
    required String dateOfBirth,
    required String gender,
    required String jobTitle,
    required int experienceYears,
    required String currentCompany,
    required List<String> skills,
    required String jobType,
    required List<String> preferredCities,
    required int expectedSalaryLpa,
    required String noticePeriod,
  }) async {
    try {
      await _apiClient.createUser({
        'phone': phone,
        'name': name,
        'email': email,
        'dateOfBirth': dateOfBirth,
        'gender': gender,
        'jobTitle': jobTitle,
        'experienceYears': experienceYears,
        'company': currentCompany,
        'skills': skills,
        'jobType': jobType,
        'preferredCities': preferredCities,
        'expectedSalaryLpa': expectedSalaryLpa,
        'noticePeriod': noticePeriod,
      });
    } on DioException catch (e) {
      throw Exception(
          e.response?.data?['message'] ?? 'Registration failed');
    }
  }
}
