abstract class RegistrationRepository {
  /// Register a new user with the collected data.
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
  });
}
