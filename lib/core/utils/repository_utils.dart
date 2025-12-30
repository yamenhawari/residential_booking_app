import 'package:dartz/dartz.dart';
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
        return const Left(CacheFailure("Cache Error"));
      } catch (e) {
        return Left(ServerFailure("Unexpected Error: $e"));
      }
    } else {
      return const Left(OfflineFailure("No Internet Connection"));
    }
  }
}
