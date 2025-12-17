import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../usecases/add_apartment_usecase.dart';
import '../usecases/update_apartment_usecase.dart';
import '../usecases/respond_booking_usecase.dart';

abstract class OwnerRepository {
  Future<Either<Failure, Unit>> addApartment(AddApartmentParams params);
  Future<Either<Failure, Unit>> updateApartment(UpdateApartmentParams params);
  Future<Either<Failure, Unit>> deleteApartment(int apartmentId);
  Future<Either<Failure, Unit>> respondToBooking(RespondBookingParams params);
}
