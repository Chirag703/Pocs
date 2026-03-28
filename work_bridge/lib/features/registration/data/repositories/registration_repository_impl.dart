import '../../domain/repositories/registration_repository.dart';

/// Dummy-data implementation — no API calls are made.
class RegistrationRepositoryImpl implements RegistrationRepository {
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
    await Future.delayed(const Duration(seconds: 2));
  }
}
