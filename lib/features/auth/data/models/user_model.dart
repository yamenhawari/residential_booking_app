import '../../domain/entities/enums/user_enums.dart';
import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.phoneNumber,
    required super.role,
    required super.status,
    required super.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final userData = json['user'];

    return UserModel(
      id: userData['id'],
      phoneNumber: userData['phone_number'],
      role: _mapStringToRole(userData['role']),
      status: _mapStringToStatus(userData['status']),
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phone_number': phoneNumber,
      'role': role == UserRole.owner ? 'owner' : 'tenant',
      'status': status.name,
      'token': token,
    };
  }

  static UserRole _mapStringToRole(String? role) {
    if (role == 'owner') return UserRole.owner;
    return UserRole.tenant;
  }

  static UserStatus _mapStringToStatus(String? status) {
    switch (status) {
      case 'active':
        return UserStatus.active;
      case 'pending':
        return UserStatus.pending;
      case 'blocked':
        return UserStatus.blocked;
      default:
        return UserStatus.unknown;
    }
  }
}
