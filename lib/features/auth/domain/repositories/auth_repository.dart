import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/enums/user_enums.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> register({
    required String phoneNumber,
    required String password,
    required UserRole role,
    required String fcmToken,
  });

  Future<Either<Failure, User>> login({
    required String phoneNumber,
    required String password,
    required String fcmToken,
    required bool isRememberMe,
  });

  Future<Either<Failure, Unit>> verifyOtp({
    required String phoneNumber,
    required String code,
  });

  Future<Either<Failure, Unit>> logout();

  Future<Either<Failure, User>> getCurrentUser();
}
