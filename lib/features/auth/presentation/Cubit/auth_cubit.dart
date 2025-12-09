import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
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

  /// 1. Check if user is already logged in (Splash Screen)
  Future<void> checkAuthStatus() async {
    // Don't emit loading here if you want a silent check,
    // but usually Splash screens show a loader anyway.
    final result = await getCurrentUserUseCase(NoParams());

    result.fold(
      (failure) => emit(AuthUserCheckFail()),
      (user) => emit(AuthUserCheckSuccess(user)),
    );
  }

  /// 2. Register User (Multipart Request)
  Future<void> register(RegisterParams params) async {
    emit(AuthLoading());

    final result = await registerUseCase(params);

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) => emit(AuthRegisterSuccess(user)),
    );
  }

  /// 3. Login User
  Future<void> login(LoginParams params) async {
    emit(AuthLoading());

    final result = await loginUseCase(params);

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) => emit(AuthLoginSuccess(user)),
    );
  }

  /// 4. Verify OTP (If flow requires it)
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

  /// 5. Logout
  Future<void> logout() async {
    emit(AuthLoading());

    final result = await logoutUseCase(NoParams());

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) => emit(AuthLogoutSuccess()),
    );
  }
}
