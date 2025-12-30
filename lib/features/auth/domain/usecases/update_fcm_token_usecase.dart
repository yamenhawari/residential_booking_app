import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

class UpdateFcmTokenUseCase implements UseCase<Unit, String> {
  final AuthRepository repository;

  UpdateFcmTokenUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(String token) async {
    return await repository.updateFcmToken(token);
  }
}
