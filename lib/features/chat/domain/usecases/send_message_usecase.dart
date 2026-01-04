import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/chat_repository.dart';

class SendMessageParams {
  final int conversationId;
  final String body;
  SendMessageParams(this.conversationId, this.body);
}

class SendMessageUseCase implements UseCase<Unit, SendMessageParams> {
  final ChatRepository repository;
  SendMessageUseCase(this.repository);
  @override
  Future<Either<Failure, Unit>> call(SendMessageParams params) async {
    return await repository.sendMessage(params.conversationId, params.body);
  }
}
