class Job {
  final String id;
  final String title;
  final String company;
  final String location;
  final String type; // Full Time, Part Time, Remote
  final String salary;
  final String postedAt;
  final String description;
  final List<String> requiredSkills;
  final String experience;
  final String openings;
  bool isSaved;
  bool isApplied;

  Job({
    required this.id,
    required this.title,
    required this.company,
    required this.location,
    required this.type,
    required this.salary,
    required this.postedAt,
    required this.description,
    required this.requiredSkills,
    required this.experience,
    required this.openings,
    this.isSaved = false,
    this.isApplied = false,
  });

  Job copyWith({
    String? id,
    String? title,
    String? company,
    String? location,
    String? type,
    String? salary,
    String? postedAt,
    String? description,
    List<String>? requiredSkills,
    String? experience,
    String? openings,
    bool? isSaved,
    bool? isApplied,
  }) {
    return Job(
      id: id ?? this.id,
      title: title ?? this.title,
      company: company ?? this.company,
      location: location ?? this.location,
      type: type ?? this.type,
      salary: salary ?? this.salary,
      postedAt: postedAt ?? this.postedAt,
      description: description ?? this.description,
      requiredSkills: requiredSkills ?? this.requiredSkills,
      experience: experience ?? this.experience,
      openings: openings ?? this.openings,
      isSaved: isSaved ?? this.isSaved,
      isApplied: isApplied ?? this.isApplied,
    );
  }
}
