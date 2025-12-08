import 'package:equatable/equatable.dart';
import '../../domain/entities/user.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object> get props => [message];
}

// --- Success States ---

class AuthRegisterSuccess extends AuthState {
  final User user;
  const AuthRegisterSuccess(this.user);

  @override
  List<Object> get props => [user];
}

class AuthLoginSuccess extends AuthState {
  final User user;
  const AuthLoginSuccess(this.user);

  @override
  List<Object> get props => [user];
}

class AuthOtpVerifiedSuccess extends AuthState {}

class AuthLogoutSuccess extends AuthState {}

// --- Splash/Startup States ---

class AuthUserCheckSuccess extends AuthState {
  final User user;
  const AuthUserCheckSuccess(this.user);

  @override
  List<Object> get props => [user];
}

class AuthUserCheckFail extends AuthState {}
