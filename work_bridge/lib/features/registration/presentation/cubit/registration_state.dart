import 'package:equatable/equatable.dart';

abstract class RegistrationState extends Equatable {
  const RegistrationState();

  @override
  List<Object?> get props => [];
}

class RegistrationInitial extends RegistrationState {
  const RegistrationInitial();
}

class RegistrationLoading extends RegistrationState {
  const RegistrationLoading();
}

class RegistrationStep1Saved extends RegistrationState {
  const RegistrationStep1Saved();
}

class RegistrationStep2Saved extends RegistrationState {
  const RegistrationStep2Saved();
}

class RegistrationSuccess extends RegistrationState {
  const RegistrationSuccess();
}

class RegistrationError extends RegistrationState {
  final String message;

  const RegistrationError({required this.message});

  @override
  List<Object?> get props => [message];
}
