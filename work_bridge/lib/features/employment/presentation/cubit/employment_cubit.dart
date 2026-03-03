import 'package:flutter_bloc/flutter_bloc.dart';
import 'employment_state.dart';

class EmploymentCubit extends Cubit<EmploymentState> {
  EmploymentCubit() : super(const EmploymentInitial());

  String jobTitle = '';
  String employmentType = '';
  String companyName = '';
  String city = '';
  String workMode = '';
  String joiningDate = '';
  String endDate = '';
  bool currentlyWorking = false;
  String annualCtc = '';

  void saveStep1({
    required String jobTitle,
    required String employmentType,
    required String companyName,
    required String city,
    required String workMode,
    required String joiningDate,
    required String endDate,
    required bool currentlyWorking,
    required String annualCtc,
  }) {
    this.jobTitle = jobTitle;
    this.employmentType = employmentType;
    this.companyName = companyName;
    this.city = city;
    this.workMode = workMode;
    this.joiningDate = joiningDate;
    this.endDate = endDate;
    this.currentlyWorking = currentlyWorking;
    this.annualCtc = annualCtc;
    emit(EmploymentStep1Saved(
      jobTitle: jobTitle,
      employmentType: employmentType,
      companyName: companyName,
      city: city,
      workMode: workMode,
      joiningDate: joiningDate,
      endDate: endDate,
      currentlyWorking: currentlyWorking,
      annualCtc: annualCtc,
    ));
  }

  void saveEmployment({
    required String responsibilities,
    required List<String> skills,
    required String achievements,
    required bool showOnProfile,
  }) {
    emit(const EmploymentSaved());
  }
}
