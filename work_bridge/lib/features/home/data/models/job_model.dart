import '../../domain/entities/job.dart';

class JobModel extends Job {
  JobModel({
    required super.id,
    required super.title,
    required super.company,
    required super.location,
    required super.type,
    required super.salary,
    required super.postedAt,
    required super.description,
    required super.requiredSkills,
    required super.experience,
    required super.openings,
    super.isSaved,
    super.isApplied,
  });

  factory JobModel.fromJson(Map<String, dynamic> json) {
    return JobModel(
      id: json['id'] as String,
      title: json['title'] as String,
      company: json['company'] as String,
      location: json['location'] as String,
      type: json['type'] as String,
      salary: json['salary'] as String,
      postedAt: json['postedAt'] as String,
      description: json['description'] as String,
      requiredSkills: (json['requiredSkills'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      experience: json['experience'] as String,
      openings: json['openings'] as String,
      isSaved: json['isSaved'] as bool? ?? false,
      isApplied: json['isApplied'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'company': company,
      'location': location,
      'type': type,
      'salary': salary,
      'postedAt': postedAt,
      'description': description,
      'requiredSkills': requiredSkills,
      'experience': experience,
      'openings': openings,
      'isSaved': isSaved,
      'isApplied': isApplied,
    };
  }
}
