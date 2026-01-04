import 'package:dartz/dartz.dart';
import 'package:residential_booking_app/core/error/failures.dart';
import 'package:residential_booking_app/core/network/network_info.dart';
import 'package:residential_booking_app/features/chat/data/datasources/chat_remote_datasource.dart';
import 'package:residential_booking_app/features/chat/domain/entities/conversation.dart';
import 'package:residential_booking_app/features/chat/domain/entities/message.dart';
import '../../domain/repositories/chat_repository.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  ChatRepositoryImpl(
      {required this.remoteDataSource, required this.networkInfo});

  @override
  Future<Either<Failure, List<Conversation>>> getConversations() async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getConversations();
        return Right(result);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    }
    return const Left(OfflineFailure("No Internet"));
  }

  @override
  Future<Either<Failure, List<Message>>> getMessages(int conversationId) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getMessages(conversationId);
        return Right(result);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    }
    return const Left(OfflineFailure("No Internet"));
  }

  @override
  Future<Either<Failure, Unit>> sendMessage(
      int conversationId, String body) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.sendMessage(conversationId, body);
        return const Right(unit);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    }
    return const Left(OfflineFailure("No Internet"));
  }

  @override
  Future<Either<Failure, int>> startChat(int receiverId) async {
    if (await networkInfo.isConnected) {
      try {
        final id = await remoteDataSource.startChat(receiverId);
        return Right(id);
      } catch (e) {
        return Left(ServerFailure(
            e.toString())); // Will catch "Cannot chat with yourself"
      }
    }
    return const Left(OfflineFailure("No Internet"));
  }

  // [NEW]
  @override
  Future<Either<Failure, Unit>> deleteConversation(int id) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.deleteConversation(id);
        return const Right(unit);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    }
    return const Left(OfflineFailure("No Internet"));
  }

  // [NEW]
  @override
  Future<Either<Failure, Unit>> deleteMessage(int id) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.deleteMessage(id);
        return const Right(unit);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    }
    return const Left(OfflineFailure("No Internet"));
  }
}
