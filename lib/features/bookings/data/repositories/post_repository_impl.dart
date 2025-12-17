import 'package:dartz/dartz.dart';
import 'package:residential_booking_app/features/bookings/domain/entities/add_review_usecase.dart';
import 'package:residential_booking_app/features/bookings/domain/usecases/create_booking_usecase.dart';
import 'package:residential_booking_app/features/bookings/domain/usecases/modify_booking_usecase.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/resources/app_strings.dart';
import '../../domain/entities/booking.dart';
import '../../domain/repositories/booking_repository.dart';
import '../datasources/booking_remote_data_source.dart';

class BookingRepositoryImpl implements BookingRepository {
  final BookingRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  BookingRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, Unit>> createBooking(
      CreateBookingParams params) async {
    return _performAction(() => remoteDataSource.createBooking(params));
  }

  @override
  Future<Either<Failure, Unit>> cancelBooking(int bookingId) async {
    return _performAction(() => remoteDataSource.cancelBooking(bookingId));
  }

  @override
  Future<Either<Failure, Unit>> modifyBooking(
      ModifyBookingParams params) async {
    return _performAction(() => remoteDataSource.modifyBooking(params));
  }

  @override
  Future<Either<Failure, List<Booking>>> getMyBookings() async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getMyBookings();
        return Right(result);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(OfflineFailure(AppStrings.error.noInternet));
    }
  }

  @override
  Future<Either<Failure, Unit>> addReview(ReviewParams params) async {
    return _performAction(() => remoteDataSource.addReview(params));
  }

  Future<Either<Failure, Unit>> _performAction(
      Future<Unit> Function() call) async {
    if (await networkInfo.isConnected) {
      try {
        await call();
        return const Right(unit);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(OfflineFailure(AppStrings.error.noInternet));
    }
  }
}
