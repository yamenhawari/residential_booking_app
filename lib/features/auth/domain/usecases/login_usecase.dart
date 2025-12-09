import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase implements UseCase<User, LoginParams> {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  @override
  Future<Either<Failure, User>> call(LoginParams params) async {
    return await repository.login(params);
  }
}

class LoginParams extends Equatable {
  final String phoneNumber;
  final String password;
  final String fcmToken;
  final bool isRememberMe;

  const LoginParams({
    required this.phoneNumber,
    required this.password,
    required this.fcmToken,
    required this.isRememberMe,
  });

  @override
  List<Object> get props => [phoneNumber, password, fcmToken, isRememberMe];
}
