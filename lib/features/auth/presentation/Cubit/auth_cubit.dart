import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/get_current_user_usecase.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final RegisterUseCase registerUseCase;
  final LoginUseCase loginUseCase;
  final LogoutUseCase logoutUseCase;
  final GetCurrentUserUseCase getCurrentUserUseCase;

  AuthCubit({
    required this.registerUseCase,
    required this.loginUseCase,
    required this.logoutUseCase,
    required this.getCurrentUserUseCase,
  }) : super(AuthInitial());

  static AuthCubit get(BuildContext context) => BlocProvider.of(context);

  Future<void> checkAuthStatus() async {
    final result = await getCurrentUserUseCase(NoParams());
    result.fold(
      (failure) => emit(AuthUserCheckFail()),
      (user) => emit(AuthUserCheckSuccess(user)),
    );
  }

  Future<void> register(RegisterParams params) async {
    emit(AuthLoading());
    final result = await registerUseCase(params);
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) => emit(const AuthRegisterSuccess()),
    );
  }

  Future<void> login(LoginParams params) async {
    emit(AuthLoading());
    final result = await loginUseCase(params);
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) => emit(AuthLoginSuccess(user)),
    );
  }

  Future<void> logout() async {
    emit(AuthLoading());
    final result = await logoutUseCase(NoParams());
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) => emit(AuthLogoutSuccess()),
    );
  }
}
