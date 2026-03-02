import 'package:equatable/equatable.dart';
import '../../domain/entities/user.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class OtpSent extends AuthState {
  final String phoneNumber;

  const OtpSent({required this.phoneNumber});

  @override
  List<Object?> get props => [phoneNumber];
}

class OtpVerified extends AuthState {
  final User user;

  const OtpVerified({required this.user});

  @override
  List<Object?> get props => [user];
}

/// Emitted when OTP is verified but no account exists for this number.
class NewUserDetected extends AuthState {
  final String phoneNumber;

  const NewUserDetected({required this.phoneNumber});

  @override
  List<Object?> get props => [phoneNumber];
}

class AuthError extends AuthState {
  final String message;

  const AuthError({required this.message});

  @override
  List<Object?> get props => [message];
}

class AuthSignedOut extends AuthState {
  const AuthSignedOut();
}
