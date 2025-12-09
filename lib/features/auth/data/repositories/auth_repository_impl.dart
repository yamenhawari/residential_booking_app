import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/resources/app_strings.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../datasources/auth_local_data_source.dart';
import '../datasources/auth_remote_data_source.dart';
import '../models/user_model.dart';

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
  Future<Either<Failure, User>> register(RegisterParams params) async {
    return _authenticate(() => remoteDataSource.register(params));
  }

  @override
  Future<Either<Failure, User>> login(LoginParams params) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteUser = await remoteDataSource.login(params);

        if (params.isRememberMe) {
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

  // ... verifyOtp, logout, getCurrentUser (same as previous) ...
  @override
  Future<Either<Failure, Unit>> verifyOtp(
      {required String phoneNumber, required String code}) async {
    // ... implementation from previous message ...
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
    // ... implementation from previous message ...
    if (await networkInfo.isConnected) {
      try {
        final token = await localDataSource.getCachedToken();
        await remoteDataSource.logout(token);
        await localDataSource.deleteUser();
        return const Right(unit);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on CacheException {
        // If cache is bad, force logout locally anyway
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

  // FIXED: Strictly typed to expect UserModel from the call
  Future<Either<Failure, User>> _authenticate(
      Future<UserModel> Function() authCall) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteUser = await authCall();
        // remoteUser is definitely UserModel, so this is safe
        await localDataSource.cacheUser(remoteUser);
        return Right(remoteUser);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(OfflineFailure(AppStrings.error.noInternet));
    }
  }
}
