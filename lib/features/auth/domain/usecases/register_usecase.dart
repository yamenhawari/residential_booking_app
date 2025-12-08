import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/enums/user_enums.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class RegisterUseCase implements UseCase<User, RegisterParams> {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  @override
  Future<Either<Failure, User>> call(RegisterParams params) async {
    return await repository.register(
      phoneNumber: params.phoneNumber,
      password: params.password,
      role: params.role,
      fcmToken: params.fcmToken,
    );
  }
}

class RegisterParams extends Equatable {
  final String phoneNumber;
  final String password;
  final UserRole role;
  final String fcmToken;

  const RegisterParams({
    required this.phoneNumber,
    required this.password,
    required this.role,
    required this.fcmToken,
  });

  @override
  List<Object> get props => [phoneNumber, password, role, fcmToken];
}
