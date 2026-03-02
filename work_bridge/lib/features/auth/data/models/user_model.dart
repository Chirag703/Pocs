import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.phone,
    required super.name,
    required super.email,
    super.dateOfBirth,
    super.gender,
    super.jobTitle,
    super.company,
    super.experienceYears,
    super.skills,
    super.resumeUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      phone: json['phone'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      dateOfBirth: json['dateOfBirth'] as String?,
      gender: json['gender'] as String?,
      jobTitle: json['jobTitle'] as String?,
      company: json['company'] as String?,
      experienceYears: json['experienceYears'] as int?,
      skills: (json['skills'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      resumeUrl: json['resumeUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phone': phone,
      'name': name,
      'email': email,
      'dateOfBirth': dateOfBirth,
      'gender': gender,
      'jobTitle': jobTitle,
      'company': company,
      'experienceYears': experienceYears,
      'skills': skills,
      'resumeUrl': resumeUrl,
    };
  }
}
