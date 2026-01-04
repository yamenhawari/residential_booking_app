import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/chat_repository.dart';

class DeleteConversationUseCase implements UseCase<Unit, int> {
  final ChatRepository repository;
  DeleteConversationUseCase(this.repository);
  @override
  Future<Either<Failure, Unit>> call(int id) async {
    return await repository.deleteConversation(id);
  }
}

class DeleteMessageUseCase implements UseCase<Unit, int> {
  final ChatRepository repository;
  DeleteMessageUseCase(this.repository);
  @override
  Future<Either<Failure, Unit>> call(int id) async {
    return await repository.deleteMessage(id);
  }
}
