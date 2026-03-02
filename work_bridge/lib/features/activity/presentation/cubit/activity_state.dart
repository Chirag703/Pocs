import 'package:equatable/equatable.dart';

class AppliedJob {
  final String id;
  final String jobTitle;
  final String company;
  final String location;
  final String appliedDate;
  final String currentStatus; // applied, shortlisted, interview, offered, rejected
  final List<String> timeline;

  const AppliedJob({
    required this.id,
    required this.jobTitle,
    required this.company,
    required this.location,
    required this.appliedDate,
    required this.currentStatus,
    required this.timeline,
  });
}

abstract class ActivityState extends Equatable {
  const ActivityState();

  @override
  List<Object?> get props => [];
}

class ActivityInitial extends ActivityState {
  const ActivityInitial();
}

class ActivityLoading extends ActivityState {
  const ActivityLoading();
}

class ActivityLoaded extends ActivityState {
  final List<AppliedJob> appliedJobs;

  const ActivityLoaded({required this.appliedJobs});

  @override
  List<Object?> get props => [appliedJobs];
}
