import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/job_repository.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final JobRepository _jobRepository;

  HomeCubit(this._jobRepository) : super(const HomeInitial());

  Future<void> loadJobs({String filter = 'All'}) async {
    emit(const HomeLoading());
    try {
      final jobs = await _jobRepository.getRecommendedJobs(filter: filter);
      final savedCount = jobs.where((j) => j.isSaved).length;
      final appliedCount = jobs.where((j) => j.isApplied).length;
      emit(HomeLoaded(
        jobs: jobs,
        activeFilter: filter,
        applicationsCount: appliedCount,
        profileViews: 24,
        savedCount: savedCount,
      ));
    } catch (e) {
      emit(HomeError(message: e.toString()));
    }
  }

  Future<void> toggleSave(String jobId) async {
    final current = state;
    if (current is! HomeLoaded) return;
    try {
      final updatedJob = await _jobRepository.toggleSaveJob(jobId);
      final updatedJobs = current.jobs.map((j) {
        return j.id == jobId ? updatedJob : j;
      }).toList();
      emit(current.copyWith(
        jobs: updatedJobs,
        savedCount: updatedJobs.where((j) => j.isSaved).length,
      ));
    } catch (_) {}
  }

  Future<void> applyJob(String jobId) async {
    final current = state;
    if (current is! HomeLoaded) return;
    try {
      await _jobRepository.applyJob(jobId);
      final updatedJobs = current.jobs.map((j) {
        return j.id == jobId ? j.copyWith(isApplied: true) : j;
      }).toList();
      emit(current.copyWith(
        jobs: updatedJobs,
        applicationsCount: updatedJobs.where((j) => j.isApplied).length,
      ));
    } catch (_) {}
  }
}
