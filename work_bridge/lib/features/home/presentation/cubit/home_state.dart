import 'package:equatable/equatable.dart';
import '../../domain/entities/job.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {
  const HomeInitial();
}

class HomeLoading extends HomeState {
  const HomeLoading();
}

class HomeLoaded extends HomeState {
  final List<Job> jobs;
  final String activeFilter;
  final int applicationsCount;
  final int profileViews;
  final int savedCount;

  const HomeLoaded({
    required this.jobs,
    this.activeFilter = 'All',
    this.applicationsCount = 0,
    this.profileViews = 0,
    this.savedCount = 0,
  });

  HomeLoaded copyWith({
    List<Job>? jobs,
    String? activeFilter,
    int? applicationsCount,
    int? profileViews,
    int? savedCount,
  }) {
    return HomeLoaded(
      jobs: jobs ?? this.jobs,
      activeFilter: activeFilter ?? this.activeFilter,
      applicationsCount: applicationsCount ?? this.applicationsCount,
      profileViews: profileViews ?? this.profileViews,
      savedCount: savedCount ?? this.savedCount,
    );
  }

  @override
  List<Object?> get props => [jobs, activeFilter, applicationsCount, profileViews, savedCount];
}

class HomeError extends HomeState {
  final String message;

  const HomeError({required this.message});

  @override
  List<Object?> get props => [message];
}
