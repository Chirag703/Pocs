import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/auth_repository.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;

  AuthCubit(this._authRepository) : super(const AuthInitial());

  Future<void> sendOtp(String phoneNumber) async {
    emit(const AuthLoading());
    try {
      await _authRepository.sendOtp(phoneNumber);
      emit(OtpSent(phoneNumber: phoneNumber));
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> verifyOtp(String phoneNumber, String otp) async {
    emit(const AuthLoading());
    try {
      final user = await _authRepository.verifyOtp(phoneNumber, otp);
      if (user != null) {
        emit(OtpVerified(user: user));
      } else {
        emit(NewUserDetected(phoneNumber: phoneNumber));
      }
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> signOut() async {
    await _authRepository.signOut();
    emit(const AuthSignedOut());
  }

  void resetState() {
    emit(const AuthInitial());
  }
}
