import 'package:dartz/dartz.dart';
import '../../../../core/entities/apartment.dart';
import '../../../../core/error/failures.dart';
import '../entities/filter_apartment_params.dart';

abstract class HomeRepository {
  Future<Either<Failure, List<Apartment>>> getApartments(
      FilterApartmentParams params);
}
