import '../../features/auth/domain/entities/enums/user_enums.dart';
import '../entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.firstName,
    required super.lastName,
    required super.phoneNumber,
    super.profileImageUrl,
    super.dob,
    required super.role,
    required super.status,
    required super.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final userData = json['user'] ?? json;
    return UserModel(
      id: userData['id'],
      firstName: userData['first_name'],
      lastName: userData['last_name'],
      phoneNumber: userData['phone_number'],
      profileImageUrl: userData['profile_image'],
      dob: userData['date_of_birth'],
      role: _mapStringToRole(userData['role']),
      status: _mapStringToStatus(userData['status']),
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'phone_number': phoneNumber,
      'profile_image': profileImageUrl,
      'date_of_birth': dob,
      'role': role == UserRole.owner ? 'owner' : 'tenant',
      'status': status.name,
      'token': token,
    };
  }

  static UserRole _mapStringToRole(String? role) {
    return role == 'owner' ? UserRole.owner : UserRole.tenant;
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
