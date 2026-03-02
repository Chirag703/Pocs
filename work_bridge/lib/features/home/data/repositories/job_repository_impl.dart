import '../../domain/entities/job.dart';
import '../../domain/repositories/job_repository.dart';
import '../models/job_model.dart';

/// Mock implementation — replace with real API calls.
class JobRepositoryImpl implements JobRepository {
  final List<JobModel> _jobs = [
    JobModel(
      id: 'j1',
      title: 'Flutter Developer',
      company: 'TechCorp',
      location: 'Bengaluru',
      type: 'Full Time',
      salary: '12–18 LPA',
      postedAt: '2 days ago',
      description:
          'We are looking for a passionate Flutter Developer to join our mobile team. You will work on building and maintaining our consumer-facing mobile applications used by millions.',
      requiredSkills: ['Flutter', 'Dart', 'Firebase', 'REST APIs'],
      experience: '2–4 years',
      openings: '3 openings',
    ),
    JobModel(
      id: 'j2',
      title: 'Product Designer',
      company: 'DesignHub',
      location: 'Remote',
      type: 'Remote',
      salary: '10–15 LPA',
      postedAt: '1 day ago',
      description:
          'Join DesignHub to craft beautiful and functional product experiences. You will work closely with engineers and product managers to define and implement UI/UX solutions.',
      requiredSkills: ['Figma', 'Prototyping', 'User Research', 'Design Systems'],
      experience: '3–5 years',
      openings: '1 opening',
    ),
    JobModel(
      id: 'j3',
      title: 'Backend Engineer',
      company: 'CloudBase',
      location: 'Hyderabad',
      type: 'Full Time',
      salary: '15–25 LPA',
      postedAt: '3 days ago',
      description:
          'Build scalable backend services and APIs for our SaaS platform. Experience with distributed systems and cloud infrastructure is a plus.',
      requiredSkills: ['Node.js', 'PostgreSQL', 'Docker', 'AWS'],
      experience: '4–6 years',
      openings: '2 openings',
    ),
    JobModel(
      id: 'j4',
      title: 'Data Analyst',
      company: 'InsightsCo',
      location: 'Mumbai',
      type: 'Part Time',
      salary: '6–10 LPA',
      postedAt: '5 days ago',
      description:
          'Analyze large datasets and generate actionable insights for our marketing and product teams.',
      requiredSkills: ['Python', 'SQL', 'Tableau', 'Excel'],
      experience: '1–3 years',
      openings: '2 openings',
    ),
    JobModel(
      id: 'j5',
      title: 'DevOps Engineer',
      company: 'ScaleUp',
      location: 'Pune',
      type: 'Full Time',
      salary: '18–28 LPA',
      postedAt: '1 week ago',
      description:
          'Manage our CI/CD pipelines, Kubernetes clusters, and cloud infrastructure on GCP and AWS.',
      requiredSkills: ['Kubernetes', 'Terraform', 'CI/CD', 'GCP'],
      experience: '3–7 years',
      openings: '1 opening',
    ),
  ];

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
