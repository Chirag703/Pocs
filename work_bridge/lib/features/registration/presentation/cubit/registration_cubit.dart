import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/registration_repository.dart';
import 'registration_state.dart';

class RegistrationCubit extends Cubit<RegistrationState> {
  final RegistrationRepository _repo;

  // Collected form data across steps
  String phone = '';
  String name = '';
  String email = '';
  String dateOfBirth = '';
  String gender = '';
  String jobTitle = '';
  int experienceYears = 0;
  String currentCompany = '';
  List<String> skills = [];
  String jobType = '';
  List<String> preferredCities = [];
  int expectedSalaryLpa = 0;
  String noticePeriod = '';

  RegistrationCubit(this._repo) : super(const RegistrationInitial());

  void saveStep1({
    required String phone,
    required String name,
    required String email,
    required String dateOfBirth,
    required String gender,
  }) {
    this.phone = phone;
    this.name = name;
    this.email = email;
    this.dateOfBirth = dateOfBirth;
    this.gender = gender;
    emit(const RegistrationStep1Saved());
  }

  void saveStep2({
    required String jobTitle,
    required int experienceYears,
    required String currentCompany,
    required List<String> skills,
  }) {
    this.jobTitle = jobTitle;
    this.experienceYears = experienceYears;
    this.currentCompany = currentCompany;
    this.skills = List<String>.from(skills);
    emit(const RegistrationStep2Saved());
  }

  Future<void> submitRegistration({
    required String jobType,
    required List<String> preferredCities,
    required int expectedSalaryLpa,
    required String noticePeriod,
  }) async {
    this.jobType = jobType;
    this.preferredCities = List<String>.from(preferredCities);
    this.expectedSalaryLpa = expectedSalaryLpa;
    this.noticePeriod = noticePeriod;

    emit(const RegistrationLoading());
    try {
      await _repo.register(
        phone: phone,
        name: name,
        email: email,
        dateOfBirth: dateOfBirth,
        gender: gender,
        jobTitle: jobTitle,
        experienceYears: experienceYears,
        currentCompany: currentCompany,
        skills: skills,
        jobType: jobType,
        preferredCities: preferredCities,
        expectedSalaryLpa: expectedSalaryLpa,
        noticePeriod: noticePeriod,
      );
      emit(const RegistrationSuccess());
    } catch (e) {
      emit(RegistrationError(message: e.toString()));
    }
  }
}
