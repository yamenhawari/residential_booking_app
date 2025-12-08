import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/enums/user_enums.dart';
import '../../domain/usecases/get_current_user_usecase.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../domain/usecases/verify_otp_usecase.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final RegisterUseCase registerUseCase;
  final LoginUseCase loginUseCase;
  final VerifyOtpUseCase verifyOtpUseCase;
  final LogoutUseCase logoutUseCase;
  final GetCurrentUserUseCase getCurrentUserUseCase;

  AuthCubit({
    required this.registerUseCase,
    required this.loginUseCase,
    required this.verifyOtpUseCase,
    required this.logoutUseCase,
    required this.getCurrentUserUseCase,
  }) : super(AuthInitial());

  static AuthCubit get(BuildContext context) => BlocProvider.of(context);

  // --- 1. Check if user is already logged in (Splash) ---
  Future<void> checkAuthStatus() async {
    emit(AuthLoading());
    final result = await getCurrentUserUseCase(NoParams());

    result.fold(
      (failure) => emit(AuthUserCheckFail()),
      (user) => emit(AuthUserCheckSuccess(user)),
    );
  }

  // --- 2. Register ---
  Future<void> register({
    required String phoneNumber,
    required String password,
    required UserRole role, // UI passes this now//TODO check
    required String fcmToken,
  }) async {
    emit(AuthLoading());

    final result = await registerUseCase(RegisterParams(
      phoneNumber: phoneNumber,
      password: password,
      role: role,
      fcmToken: fcmToken,
    ));

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) => emit(AuthRegisterSuccess(user)),
    );
  }

  // --- 3. Login ---
  Future<void> login({
    required String phoneNumber,
    required String password,
    required String fcmToken,
    required bool isRememberMe, // UI passes this now
  }) async {
    emit(AuthLoading());

    final result = await loginUseCase(LoginParams(
      phoneNumber: phoneNumber,
      password: password,
      fcmToken: fcmToken,
      isRememberMe: isRememberMe,
    ));

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) => emit(AuthLoginSuccess(user)),
    );
  }

  // --- 4. Verify OTP ---
  Future<void> verifyOtp({
    required String phoneNumber,
    required String code,
  }) async {
    emit(AuthLoading());

    final result = await verifyOtpUseCase(VerifyOtpParams(
      phoneNumber: phoneNumber,
      code: code,
    ));

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) => emit(AuthOtpVerifiedSuccess()),
    );
  }

  // --- 5. Logout ---
  Future<void> logout() async {
    emit(AuthLoading());

    final result = await logoutUseCase(NoParams());

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) => emit(AuthLogoutSuccess()),
    );
  }
}
