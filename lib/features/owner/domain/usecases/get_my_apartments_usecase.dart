import 'package:dartz/dartz.dart';
import '../../../../core/entities/apartment.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/owner_repository.dart';

class GetOwnerApartmentsUseCase implements UseCase<List<Apartment>, NoParams> {
  final OwnerRepository repository;
  GetOwnerApartmentsUseCase(this.repository);

  @override
  Future<Either<Failure, List<Apartment>>> call(NoParams params) async {
    return await repository.getMyApartments();
  }
}
