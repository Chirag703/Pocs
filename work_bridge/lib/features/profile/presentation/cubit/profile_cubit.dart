import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/profile_repository.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepository _repo;

  ProfileCubit(this._repo) : super(const ProfileInitial());

  Future<void> loadProfile() async {
    emit(const ProfileLoading());
    try {
      final user = await _repo.getProfile();
      if (user != null) {
        // Calculate completion percent based on filled fields
        int filled = 0;
        if (user.name.isNotEmpty) filled++;
        if (user.email.isNotEmpty) filled++;
        if (user.dateOfBirth != null) filled++;
        if (user.gender != null) filled++;
        if (user.jobTitle != null) filled++;
        if (user.company != null) filled++;
        if (user.skills.isNotEmpty) filled++;
        if (user.resumeUrl != null) filled++;
        final percent = ((filled / 8) * 100).toInt();

        emit(ProfileLoaded(
          user: user,
          completionPercent: percent,
          resumeFileName: user.resumeUrl != null ? 'resume.pdf' : null,
        ));
      } else {
        emit(const ProfileError(message: 'Profile not found'));
      }
    } catch (e) {
      emit(ProfileError(message: e.toString()));
    }
  }

  Future<void> uploadResume(String filePath) async {
    final current = state;
    if (current is! ProfileLoaded) return;
    emit(const ProfileUpdating());
    try {
      await _repo.uploadResume(filePath);
      final user = await _repo.getProfile();
      if (user != null) {
        emit(current.copyWith(
          user: user,
          resumeFileName: filePath.split('/').last,
          completionPercent: 100,
        ));
      }
    } catch (e) {
      emit(ProfileError(message: e.toString()));
    }
  }

  Future<void> toggleResumeVisibility(bool isVisible) async {
    final current = state;
    if (current is! ProfileLoaded) return;
    await _repo.toggleResumeVisibility(isVisible);
    emit(current.copyWith(resumeVisible: isVisible));
  }
}
