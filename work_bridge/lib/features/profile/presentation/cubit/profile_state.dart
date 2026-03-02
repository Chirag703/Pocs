import 'package:equatable/equatable.dart';
import '../../../auth/domain/entities/user.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {
  const ProfileInitial();
}

class ProfileLoading extends ProfileState {
  const ProfileLoading();
}

class ProfileLoaded extends ProfileState {
  final User user;
  final int completionPercent;
  final bool resumeVisible;
  final String? resumeFileName;

  const ProfileLoaded({
    required this.user,
    this.completionPercent = 70,
    this.resumeVisible = true,
    this.resumeFileName,
  });

  ProfileLoaded copyWith({
    User? user,
    int? completionPercent,
    bool? resumeVisible,
    String? resumeFileName,
  }) {
    return ProfileLoaded(
      user: user ?? this.user,
      completionPercent: completionPercent ?? this.completionPercent,
      resumeVisible: resumeVisible ?? this.resumeVisible,
      resumeFileName: resumeFileName ?? this.resumeFileName,
    );
  }

  @override
  List<Object?> get props =>
      [user, completionPercent, resumeVisible, resumeFileName];
}

class ProfileError extends ProfileState {
  final String message;

  const ProfileError({required this.message});

  @override
  List<Object?> get props => [message];
}

class ProfileUpdating extends ProfileState {
  const ProfileUpdating();
}
