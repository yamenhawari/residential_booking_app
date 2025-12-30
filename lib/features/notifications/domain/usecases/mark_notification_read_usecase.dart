import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/notification_repository.dart';

class MarkNotificationReadUseCase implements UseCase<Unit, int> {
  final NotificationRepository repository;
  MarkNotificationReadUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(int id) async {
    return await repository.markAsRead(id);
  }
}
