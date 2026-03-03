import 'package:flutter_bloc/flutter_bloc.dart';
import 'education_state.dart';

class EducationCubit extends Cubit<EducationState> {
  EducationCubit() : super(const EducationInitial());

  String degreeType = '';
  String course = '';
  String university = '';
  String startYear = '';
  String endYear = '';
  String grade = '';
  bool isGradeCgpa = true;
  bool currentlyStudying = false;

  void saveStep1({
    required String degreeType,
    required String course,
    required String university,
    required String startYear,
    required String endYear,
    required String grade,
    required bool isGradeCgpa,
    required bool currentlyStudying,
  }) {
    this.degreeType = degreeType;
    this.course = course;
    this.university = university;
    this.startYear = startYear;
    this.endYear = endYear;
    this.grade = grade;
    this.isGradeCgpa = isGradeCgpa;
    this.currentlyStudying = currentlyStudying;
    emit(EducationStep1Saved(
      degreeType: degreeType,
      course: course,
      university: university,
      startYear: startYear,
      endYear: endYear,
      grade: grade,
      isGradeCgpa: isGradeCgpa,
      currentlyStudying: currentlyStudying,
    ));
  }

  void saveEducation({
    required String achievements,
    required String extraCurricular,
    required List<String> skills,
    required String certificateUrl,
    required bool showOnProfile,
  }) {
    emit(const EducationSaved());
  }
}
