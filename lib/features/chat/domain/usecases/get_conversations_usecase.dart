import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/conversation.dart';
import '../repositories/chat_repository.dart';

class GetConversationsUseCase implements UseCase<List<Conversation>, NoParams> {
  final ChatRepository repository;
  GetConversationsUseCase(this.repository);
  @override
  Future<Either<Failure, List<Conversation>>> call(NoParams params) async {
    return await repository.getConversations();
  }
}
