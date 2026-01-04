import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/message.dart';
import '../repositories/chat_repository.dart';

class GetMessagesUseCase implements UseCase<List<Message>, int> {
  final ChatRepository repository;
  GetMessagesUseCase(this.repository);
  @override
  Future<Either<Failure, List<Message>>> call(int conversationId) async {
    return await repository.getMessages(conversationId);
  }
}
