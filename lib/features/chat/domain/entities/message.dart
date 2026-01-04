import 'package:equatable/equatable.dart';

class Message extends Equatable {
  final int id;
  final int senderId;
  final String body;
  final String createdAt;

  const Message({
    required this.id,
    required this.senderId,
    required this.body,
    required this.createdAt,
  });

  @override
  List<Object> get props => [id, senderId, body, createdAt];
}
