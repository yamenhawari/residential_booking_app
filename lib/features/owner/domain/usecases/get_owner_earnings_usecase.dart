import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/owner_repository.dart';

class GetOwnerEarningsUseCase implements UseCase<double, NoParams> {
  final OwnerRepository repository;

  GetOwnerEarningsUseCase(this.repository);

  @override
  Future<Either<Failure, double>> call(NoParams params) async {
    return await repository.getOwnerEarnings();
  }
}
