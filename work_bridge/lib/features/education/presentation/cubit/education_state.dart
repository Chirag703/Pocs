import 'package:equatable/equatable.dart';

abstract class EducationState extends Equatable {
  const EducationState();

  @override
  List<Object?> get props => [];
}

class EducationInitial extends EducationState {
  const EducationInitial();
}

class EducationStep1Saved extends EducationState {
  final String degreeType;
  final String course;
  final String university;
  final String startYear;
  final String endYear;
  final String grade;
  final bool isGradeCgpa;
  final bool currentlyStudying;

  const EducationStep1Saved({
    required this.degreeType,
    required this.course,
    required this.university,
    required this.startYear,
    required this.endYear,
    required this.grade,
    required this.isGradeCgpa,
    required this.currentlyStudying,
  });

  @override
  List<Object?> get props => [
        degreeType,
        course,
        university,
        startYear,
        endYear,
        grade,
        isGradeCgpa,
        currentlyStudying,
      ];
}

class EducationSaved extends EducationState {
  const EducationSaved();
}
