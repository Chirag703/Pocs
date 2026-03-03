import '../../../../core/data/dummy_data.dart';
import '../../../auth/domain/entities/user.dart';
import '../../domain/repositories/profile_repository.dart';

/// Dummy-data implementation — no API calls are made.
class ProfileRepositoryImpl implements ProfileRepository {
  User? _user = DummyData.users['9876543210'];

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
