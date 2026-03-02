class User {
  final String id;
  final String phone;
  final String name;
  final String email;
  final String? dateOfBirth;
  final String? gender;
  final String? jobTitle;
  final String? company;
  final int? experienceYears;
  final List<String> skills;
  final String? resumeUrl;

  const User({
    required this.id,
    required this.phone,
    required this.name,
    required this.email,
    this.dateOfBirth,
    this.gender,
    this.jobTitle,
    this.company,
    this.experienceYears,
    this.skills = const [],
    this.resumeUrl,
  });

  User copyWith({
    String? id,
    String? phone,
    String? name,
    String? email,
    String? dateOfBirth,
    String? gender,
    String? jobTitle,
    String? company,
    int? experienceYears,
    List<String>? skills,
    String? resumeUrl,
  }) {
    return User(
      id: id ?? this.id,
      phone: phone ?? this.phone,
      name: name ?? this.name,
      email: email ?? this.email,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      jobTitle: jobTitle ?? this.jobTitle,
      company: company ?? this.company,
      experienceYears: experienceYears ?? this.experienceYears,
      skills: skills ?? this.skills,
      resumeUrl: resumeUrl ?? this.resumeUrl,
    );
  }
}
