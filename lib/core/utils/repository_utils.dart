import 'package:dartz/dartz.dart';
import 'package:residential_booking_app/core/resources/app_strings.dart';
import '../../core/error/exceptions.dart';
import '../../core/error/failures.dart';
import '../../core/network/network_info.dart';

class RepositoryUtils {
  final NetworkInfo networkInfo;

  RepositoryUtils(this.networkInfo);

  Future<Either<Failure, T>> safeCall<T>(Future<T> Function() apiCall) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await apiCall();
        return Right(result);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on CacheException {
        return Left(CacheFailure(AppStrings.error.cache));
      } catch (e) {
        return Left(ServerFailure("${AppStrings.error.unexpected}: $e"));
      }
    } else {
      return Left(OfflineFailure(AppStrings.error.noInternet));
    }
  }
}
