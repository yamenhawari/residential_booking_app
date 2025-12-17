import 'package:dartz/dartz.dart';
import '../../../../core/entities/apartment.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/home_repository.dart';

class GetApartmentBYIdUseCase implements UseCase<Apartment, int> {
  final HomeRepository repository;

  GetApartmentBYIdUseCase(this.repository);

  @override
  Future<Either<Failure, Apartment>> call(int id) async {
    return await repository.getApartmentById(id);
  }
}
