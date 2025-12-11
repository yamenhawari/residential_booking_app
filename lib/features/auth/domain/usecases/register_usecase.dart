import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/enums/user_enums.dart';
import '../repositories/auth_repository.dart';

class RegisterUseCase implements UseCase<Unit, RegisterParams> {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(RegisterParams params) async {
    return await repository.register(params);
  }
}

class RegisterParams extends Equatable {
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String password;
  final String dob;
  final File profileImage;
  final File idImage;
  final UserRole role;
  final String fcmToken;

  const RegisterParams({
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.password,
    required this.dob,
    required this.profileImage,
    required this.idImage,
    required this.role,
    required this.fcmToken,
  });

  @override
  List<Object> get props => [
        firstName,
        lastName,
        phoneNumber,
        password,
        dob,
        profileImage.path,
        idImage.path,
        role,
        fcmToken
      ];
}
