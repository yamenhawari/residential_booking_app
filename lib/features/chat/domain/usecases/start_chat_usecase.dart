import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/chat_repository.dart';

class StartChatUseCase implements UseCase<int, int> {
  final ChatRepository repository;
  StartChatUseCase(this.repository);
  @override
  Future<Either<Failure, int>> call(int receiverId) async {
    return await repository.startChat(receiverId);
  }
}
