import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/user.dart';
import '../usecases/login_usecase.dart';
import '../usecases/register_usecase.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> register(RegisterParams params);

  Future<Either<Failure, User>> login(LoginParams params);

  Future<Either<Failure, Unit>> verifyOtp({
    required String phoneNumber,
    required String code,
  });

  Future<Either<Failure, Unit>> logout();

  Future<Either<Failure, User>> getCurrentUser();
}
