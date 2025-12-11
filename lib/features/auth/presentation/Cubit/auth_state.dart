import 'package:equatable/equatable.dart';
import 'package:residential_booking_app/core/entities/user.dart';

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

class AuthRegisterSuccess extends AuthState {
  const AuthRegisterSuccess();
}

class AuthLoginSuccess extends AuthState {
  final User user;
  const AuthLoginSuccess(this.user);
  @override
  List<Object> get props => [user];
}

class AuthOtpVerifiedSuccess extends AuthState {}

class AuthLogoutSuccess extends AuthState {}

class AuthUserCheckSuccess extends AuthState {
  final User user;
  const AuthUserCheckSuccess(this.user);
  @override
  List<Object> get props => [user];
}

class AuthUserCheckFail extends AuthState {}
