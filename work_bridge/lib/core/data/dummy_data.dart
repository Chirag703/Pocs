import '../../features/activity/presentation/cubit/activity_state.dart';
import '../../features/auth/data/models/user_model.dart';
import '../../features/home/data/models/job_model.dart';
import '../../features/notifications/presentation/cubit/notifications_state.dart';

/// Centralised dummy data used by all repositories and cubits.
/// No real API calls are made — all data is served from here.
class DummyData {
  DummyData._();

  // ── Users ──────────────────────────────────────────────────────────────────

  static final Map<String, UserModel> users = {
    '9876543210': UserModel(
      id: 'u1',
      phone: '9876543210',
      name: 'Rahul Sharma',
      email: 'rahul@example.com',
      dateOfBirth: '15/06/1998',
      gender: 'Male',
      jobTitle: 'Software Engineer',
      company: 'TechCorp',
      experienceYears: 3,
      skills: ['Flutter', 'Dart', 'Firebase', 'REST APIs'],
    ),
  };

  // ── Jobs ───────────────────────────────────────────────────────────────────

  static List<JobModel> get jobs => [
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
          requiredSkills: [
            'Figma',
            'Prototyping',
            'User Research',
            'Design Systems'
          ],
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

  // ── Applied jobs (Activity) ────────────────────────────────────────────────

  static const List<AppliedJob> appliedJobs = [
    AppliedJob(
      id: 'a1',
      jobTitle: 'Flutter Developer',
      company: 'TechCorp',
      location: 'Bengaluru',
      appliedDate: '20 Feb 2025',
      currentStatus: 'interview',
      timeline: ['applied', 'shortlisted', 'interview'],
    ),
    AppliedJob(
      id: 'a2',
      jobTitle: 'Product Designer',
      company: 'DesignHub',
      location: 'Remote',
      appliedDate: '15 Feb 2025',
      currentStatus: 'shortlisted',
      timeline: ['applied', 'shortlisted'],
    ),
    AppliedJob(
      id: 'a3',
      jobTitle: 'DevOps Engineer',
      company: 'ScaleUp',
      location: 'Pune',
      appliedDate: '10 Feb 2025',
      currentStatus: 'offered',
      timeline: ['applied', 'shortlisted', 'interview', 'offered'],
    ),
    AppliedJob(
      id: 'a4',
      jobTitle: 'Backend Engineer',
      company: 'CloudBase',
      location: 'Hyderabad',
      appliedDate: '5 Feb 2025',
      currentStatus: 'rejected',
      timeline: ['applied', 'rejected'],
    ),
  ];

  // ── Notifications ──────────────────────────────────────────────────────────

  static const List<AppNotification> notifications = [
    AppNotification(
      id: 'n1',
      title: 'Application Viewed',
      body: 'TechCorp viewed your application for Flutter Developer.',
      type: 'alert',
      time: '2 hours ago',
    ),
    AppNotification(
      id: 'n2',
      title: 'Shortlisted! 🎉',
      body: 'You have been shortlisted for Product Designer at DesignHub.',
      type: 'shortlist',
      time: '1 day ago',
    ),
    AppNotification(
      id: 'n3',
      title: 'Interview Scheduled',
      body: 'Your interview with CloudBase is scheduled for tomorrow at 11 AM.',
      type: 'interview',
      time: '2 days ago',
    ),
    AppNotification(
      id: 'n4',
      title: 'New Job Alert',
      body: '5 new Flutter Developer jobs match your profile in Bengaluru.',
      type: 'alert',
      time: '3 days ago',
      isRead: true,
    ),
    AppNotification(
      id: 'n5',
      title: 'Offer Letter Received',
      body: 'Congratulations! ScaleUp has sent you an offer letter.',
      type: 'offer',
      time: '5 days ago',
      isRead: true,
    ),
  ];
}
