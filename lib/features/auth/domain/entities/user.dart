import 'package:equatable/equatable.dart';
import 'enums/user_enums.dart';

class User extends Equatable {
  final int id;
  final String phoneNumber;
  final UserRole role;
  final UserStatus status;
  final String token;

  const User({
    required this.id,
    required this.phoneNumber,
    required this.role,
    required this.status,
    required this.token,
  });

  @override
  List<Object> get props => [id, phoneNumber, role, status, token];
}
