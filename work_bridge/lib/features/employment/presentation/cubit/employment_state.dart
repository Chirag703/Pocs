import 'package:equatable/equatable.dart';

abstract class EmploymentState extends Equatable {
  const EmploymentState();

  @override
  List<Object?> get props => [];
}

class EmploymentInitial extends EmploymentState {
  const EmploymentInitial();
}

class EmploymentStep1Saved extends EmploymentState {
  final String jobTitle;
  final String employmentType;
  final String companyName;
  final String city;
  final String workMode;
  final String joiningDate;
  final String endDate;
  final bool currentlyWorking;
  final String annualCtc;

  const EmploymentStep1Saved({
    required this.jobTitle,
    required this.employmentType,
    required this.companyName,
    required this.city,
    required this.workMode,
    required this.joiningDate,
    required this.endDate,
    required this.currentlyWorking,
    required this.annualCtc,
  });

  @override
  List<Object?> get props => [
        jobTitle,
        employmentType,
        companyName,
        city,
        workMode,
        joiningDate,
        endDate,
        currentlyWorking,
        annualCtc,
      ];
}

class EmploymentSaved extends EmploymentState {
  const EmploymentSaved();
}
