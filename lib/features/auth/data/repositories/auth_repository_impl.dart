import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/resources/app_strings.dart';
import '../../domain/entities/enums/user_enums.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_data_source.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, User>> register({
    required String phoneNumber,
    required String password,
    required UserRole role,
    required String fcmToken,
  }) async {
    return _authenticate(() => remoteDataSource.register(
          phoneNumber: phoneNumber,
          password: password,
          role: role,
          fcmToken: fcmToken,
        ));
  }

  @override
  Future<Either<Failure, User>> login({
    required String phoneNumber,
    required String password,
    required String fcmToken,
    required bool isRememberMe,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteUser = await remoteDataSource.login(
          phoneNumber: phoneNumber,
          password: password,
          fcmToken: fcmToken,
        );

        if (isRememberMe) {
          await localDataSource.cacheUser(remoteUser);
        } else {
          await localDataSource.deleteUser();
        }

        return Right(remoteUser);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(OfflineFailure(AppStrings.error.noInternet));
    }
  }

  @override
  Future<Either<Failure, Unit>> verifyOtp({
    required String phoneNumber,
    required String code,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.verifyOtp(phoneNumber: phoneNumber, code: code);
        return const Right(unit);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(OfflineFailure(AppStrings.error.noInternet));
    }
  }

  @override
  Future<Either<Failure, Unit>> logout() async {
    if (await networkInfo.isConnected) {
      try {
        final token = await localDataSource.getCachedToken();
        await remoteDataSource.logout(token);
        await localDataSource.deleteUser();
        return const Right(unit);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on CacheException {
        await localDataSource.deleteUser();
        return const Right(unit);
      }
    } else {
      return Left(OfflineFailure(AppStrings.error.noInternet));
    }
  }

  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    try {
      final user = await localDataSource.getCachedUser();
      return Right(user);
    } on CacheException {
      return Left(CacheFailure(AppStrings.error.cache));
    }
  }

  Future<Either<Failure, User>> _authenticate(
      Future<User> Function() authCall) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteUser = await authCall();
        await localDataSource.cacheUser(remoteUser as dynamic);
        return Right(remoteUser);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(OfflineFailure(AppStrings.error.noInternet));
    }
  }
}
