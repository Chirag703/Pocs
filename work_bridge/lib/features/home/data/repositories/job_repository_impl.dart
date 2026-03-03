import '../../../../core/data/dummy_data.dart';
import '../../domain/entities/job.dart';
import '../../domain/repositories/job_repository.dart';
import '../models/job_model.dart';

/// Dummy-data implementation — no API calls are made.
class JobRepositoryImpl implements JobRepository {
  final List<JobModel> _jobs = DummyData.jobs;

  @override
  Future<List<Job>> getRecommendedJobs({String? filter}) async {
    await Future.delayed(const Duration(milliseconds: 600));
    if (filter == null || filter == 'All') return List.from(_jobs);
    return _jobs.where((j) => j.type == filter).toList();
  }

  @override
  Future<List<Job>> searchJobs(String query) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final q = query.toLowerCase();
    return _jobs
        .where((j) =>
            j.title.toLowerCase().contains(q) ||
            j.company.toLowerCase().contains(q) ||
            j.location.toLowerCase().contains(q))
        .toList();
  }

  @override
  Future<Job> toggleSaveJob(String jobId) async {
    final index = _jobs.indexWhere((j) => j.id == jobId);
    if (index == -1) throw Exception('Job not found');
    _jobs[index] = JobModel(
      id: _jobs[index].id,
      title: _jobs[index].title,
      company: _jobs[index].company,
      location: _jobs[index].location,
      type: _jobs[index].type,
      salary: _jobs[index].salary,
      postedAt: _jobs[index].postedAt,
      description: _jobs[index].description,
      requiredSkills: _jobs[index].requiredSkills,
      experience: _jobs[index].experience,
      openings: _jobs[index].openings,
      isSaved: !_jobs[index].isSaved,
      isApplied: _jobs[index].isApplied,
    );
    return _jobs[index];
  }

  @override
  Future<void> applyJob(String jobId) async {
    await Future.delayed(const Duration(milliseconds: 800));
    final index = _jobs.indexWhere((j) => j.id == jobId);
    if (index != -1) {
      _jobs[index] = JobModel(
        id: _jobs[index].id,
        title: _jobs[index].title,
        company: _jobs[index].company,
        location: _jobs[index].location,
        type: _jobs[index].type,
        salary: _jobs[index].salary,
        postedAt: _jobs[index].postedAt,
        description: _jobs[index].description,
        requiredSkills: _jobs[index].requiredSkills,
        experience: _jobs[index].experience,
        openings: _jobs[index].openings,
        isSaved: _jobs[index].isSaved,
        isApplied: true,
      );
    }
  }
}
