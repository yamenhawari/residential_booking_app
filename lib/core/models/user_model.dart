import '../entities/user.dart';
import '../../features/auth/domain/entities/enums/user_enums.dart';
import '../api/api_constants.dart';

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
    // Accept either 'User' or 'user' wrapper or raw user JSON
    final userData = json['User'] ?? json['user'] ?? json;

    // Support both 'Token' and 'token' as top-level or inside user data: {Token: '...'} or {token: '...'} or {User: {..., token: '...'}}
    final String token =
        json['Token'] ?? json['token'] ?? userData['token'] ?? '';

    return UserModel(
      id: userData['id'] ?? 0,
      firstName: userData['first_name'] ?? '',
      lastName: userData['last_name'] ?? '',
      phoneNumber: userData['phone'] ?? '',
      profileImageUrl: userData['profile_image'] != null
          ? "${ApiConstants.storageBaseUrl}${userData['profile_image']}"
          : null,
      dob: userData['birth_date'],
      role: _mapStringToRole(userData['role']),
      status: _mapStringToStatus(userData['status']),
      token: token,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'phone': phoneNumber,
      'profile_image': profileImageUrl,
      'birth_date': dob,
      'role': role == UserRole.owner ? 'owner' : 'tenant',
      'status': status.name,
      'Token': token,
    };
  }

  static UserRole _mapStringToRole(String? role) {
    return role == 'owner' ? UserRole.owner : UserRole.tenant;
  }

  static UserStatus _mapStringToStatus(String? status) {
    switch (status) {
      case 'active':
        return UserStatus.active;
      case 'inactive':
        return UserStatus.pending;
      case 'blocked':
        return UserStatus.blocked;
      default:
        return UserStatus.unknown;
    }
  }
}
