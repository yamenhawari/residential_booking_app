import 'package:dartz/dartz.dart';
import '../../../../core/entities/apartment.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/filter_apartment_params.dart';
import '../repositories/home_repository.dart';

class GetApartmentsUseCase
    implements UseCase<List<Apartment>, FilterApartmentParams> {
  final HomeRepository repository;

  GetApartmentsUseCase(this.repository);

  @override
  Future<Either<Failure, List<Apartment>>> call(
      FilterApartmentParams params) async {
    return await repository.getApartments(params);
  }
}
