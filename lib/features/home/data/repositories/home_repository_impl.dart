import 'package:dartz/dartz.dart';

import '../../../../core/entities/apartment.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/resources/app_strings.dart';
import '../../domain/entities/filter_apartment_params.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_remote_data_source.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  HomeRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Apartment>>> getApartments(
      FilterApartmentParams params) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getApartments(params);
        return Right(result);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } catch (e) {
        // Fallback for parsing errors or unexpected crashes
        return Left(ServerFailure(AppStrings.error.server));
      }
    } else {
      return Left(OfflineFailure(AppStrings.error.noInternet));
    }
  }
}
