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
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(OfflineFailure(AppStrings.error.noInternet));
    }
  }

  @override
  Future<Either<Failure, Apartment>> getApartmentById(int apartmentId) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getApartmentById(apartmentId);
        return Right(result);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } catch (e) {
        // FIX: Catch unexpected errors here as well
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(OfflineFailure(AppStrings.error.noInternet));
    }
  }
}
