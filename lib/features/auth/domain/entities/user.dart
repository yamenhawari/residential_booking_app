import 'package:equatable/equatable.dart';
import 'enums/user_enums.dart';

class User extends Equatable {
  final int id;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String? profileImageUrl;
  final String? dob;
  final UserRole role;
  final UserStatus status;
  final String token;

  const User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    this.profileImageUrl,
    this.dob,
    required this.role,
    required this.status,
    required this.token,
  });

  @override
  List<Object?> get props => [
        id,
        firstName,
        lastName,
        phoneNumber,
        profileImageUrl,
        dob,
        role,
        status,
        token
      ];
}
