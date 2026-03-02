import '../entities/job.dart';

abstract class JobRepository {
  /// Fetch recommended jobs for the home feed.
  Future<List<Job>> getRecommendedJobs({String? filter});

  /// Search jobs by query.
  Future<List<Job>> searchJobs(String query);

  /// Toggle the saved state of a job.
  Future<Job> toggleSaveJob(String jobId);

  /// Apply for a job.
  Future<void> applyJob(String jobId);
}
