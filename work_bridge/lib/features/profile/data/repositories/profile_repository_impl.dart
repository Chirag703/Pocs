import '../../../auth/domain/entities/user.dart';
import '../../domain/repositories/profile_repository.dart';

/// Mock implementation
class ProfileRepositoryImpl implements ProfileRepository {
  User? _user = const User(
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
  );

  bool _resumeVisible = true;

  @override
  Future<User?> getProfile() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return _user;
  }

  @override
  Future<void> updateProfile(User user) async {
    await Future.delayed(const Duration(milliseconds: 600));
    _user = user;
  }

  @override
  Future<void> uploadResume(String filePath) async {
    await Future.delayed(const Duration(seconds: 1));
    _user = _user?.copyWith(resumeUrl: filePath);
  }

  @override
  Future<void> toggleResumeVisibility(bool isVisible) async {
    _resumeVisible = isVisible;
  }

  bool get isResumeVisible => _resumeVisible;
}
