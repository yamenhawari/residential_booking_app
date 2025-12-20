import 'package:dartz/dartz.dart';
import '../../../../core/api/api_constants.dart';
import '../../../../core/api/api_consumer.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/models/user_model.dart';
import '../../domain/entities/enums/user_enums.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/register_usecase.dart';

abstract class AuthRemoteDataSource {
  Future<Unit> register(RegisterParams params);
  Future<UserModel> login(LoginParams params);
  Future<Unit> logout(String token);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiConsumer apiConsumer;

  AuthRemoteDataSourceImpl({required this.apiConsumer});

  @override
  Future<Unit> register(RegisterParams params) async {
    final fields = {
      'first_name': params.firstName,
      'last_name': params.lastName,
      'phone': params.phoneNumber,
      'birth_date': params.dob,
      'role': params.role == UserRole.owner ? 'owner' : 'tenant',
      'password': params.password,
      'password_confirmation': params.password,
    };

    final files = <FileParam>[];
    if (await params.profileImage.exists()) {
      files.add(FileParam(name: 'profile_image', file: params.profileImage));
    }
    if (await params.idImage.exists()) {
      files.add(FileParam(name: 'id_image', file: params.idImage));
    }

    await apiConsumer.postMultipart(
      ApiConstants.register,
      fields: fields,
      files: files,
      requiresAuth: false,
    );

    return unit;
  }

  @override
  Future<UserModel> login(LoginParams params) async {
    final response = await apiConsumer.post(
      ApiConstants.login,
      body: {
        'phone': params.phoneNumber,
        'password': params.password,
      },
      requiresAuth: false,
    );

    final user = UserModel.fromJson(response);

    if (user.status == UserStatus.pending) {
      throw ServerException("Your account is pending admin approval.");
    }
    if (user.status == UserStatus.blocked) {
      throw ServerException("Your account is blocked.");
    }

    return user;
  }

  @override
  Future<Unit> logout(String token) async {
    await apiConsumer.post(ApiConstants.logout);
    return unit;
  }
}
