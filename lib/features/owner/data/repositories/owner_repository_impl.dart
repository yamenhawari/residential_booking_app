import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/resources/app_strings.dart';
import '../../domain/repositories/owner_repository.dart';
import '../../domain/usecases/add_apartment_usecase.dart';
import '../../domain/usecases/respond_booking_usecase.dart';
import '../../domain/usecases/update_apartment_usecase.dart';
import '../datasources/owner_remote_data_source.dart';

class OwnerRepositoryImpl implements OwnerRepository {
  final OwnerRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  OwnerRepositoryImpl(
      {required this.remoteDataSource, required this.networkInfo});

  Future<Either<Failure, Unit>> _performAction(
      Future<Unit> Function() action) async {
    if (await networkInfo.isConnected) {
      try {
        await action();
        return const Right(unit);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(OfflineFailure(AppStrings.error.noInternet));
    }
  }

  @override
  Future<Either<Failure, Unit>> addApartment(AddApartmentParams params) async {
    return _performAction(() => remoteDataSource.addApartment(params));
  }

  @override
  Future<Either<Failure, Unit>> updateApartment(
      UpdateApartmentParams params) async {
    return _performAction(() => remoteDataSource.updateApartment(params));
  }

  @override
  Future<Either<Failure, Unit>> deleteApartment(int apartmentId) async {
    return _performAction(() => remoteDataSource.deleteApartment(apartmentId));
  }

  @override
  Future<Either<Failure, Unit>> respondToBooking(
      RespondBookingParams params) async {
    return _performAction(() => remoteDataSource.respondToBooking(params));
  }
}
