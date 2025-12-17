import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:residential_booking_app/core/models/user_model.dart';

import '../../../../core/api/api_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/resources/app_strings.dart';
import '../../domain/entities/enums/user_enums.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/register_usecase.dart';

abstract class AuthRemoteDataSource {
  Future<Unit> register(RegisterParams params);
  Future<UserModel> login(LoginParams params);
  Future<Unit> logout(String token);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final http.Client client;

  AuthRemoteDataSourceImpl({required this.client});

  Map<String, String> get _headers => {
        'Content-Type': AppStrings.api.contentType,
        'Accept': AppStrings.api.accept,
      };

  @override
  Future<Unit> register(RegisterParams params) async {
    final request =
        http.MultipartRequest('POST', Uri.parse(ApiConstants.register));
    request.headers.addAll({'Accept': 'application/json'});

    request.fields['first_name'] = params.firstName;
    request.fields['last_name'] = params.lastName;
    request.fields['phone'] = params.phoneNumber;
    request.fields['birth_date'] = params.dob;
    request.fields['role'] = params.role == UserRole.owner ? 'owner' : 'tenant';
    request.fields['password'] = params.password;
    request.fields['password_confirmation'] = params.password;

    if (await params.profileImage.exists()) {
      request.files.add(await http.MultipartFile.fromPath(
        'profile_image',
        params.profileImage.path,
      ));
    }

    if (await params.idImage.exists()) {
      request.files.add(await http.MultipartFile.fromPath(
        'id_image',
        params.idImage.path,
      ));
    }

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    return _handleResponse(response, (_) => unit);
  }

  @override
  Future<UserModel> login(LoginParams params) async {
    final body = json.encode({
      'phone': params.phoneNumber,
      'password': params.password,
    });

    final response = await client.post(
      Uri.parse(ApiConstants.login),
      body: body,
      headers: _headers,
    );

    final user = _handleResponse(response, (json) => UserModel.fromJson(json));
    print(response.body);
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
    final headers = _headers
      ..addAll({'Authorization': '${AppStrings.api.bearer} $token'});
    final response = await client.post(
      Uri.parse(ApiConstants.logout),
      headers: headers,
    );
    return _handleResponse(response, (_) => unit);
  }

  T _handleResponse<T>(http.Response response, T Function(dynamic) onSuccess) {
    final jsonBody = json.decode(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return onSuccess(jsonBody);
    } else {
      String errorMessage = jsonBody['message'] ?? AppStrings.error.server;
      if (jsonBody['errors'] != null) {
        final errors = jsonBody['errors'];
        if (errors is Map && errors.isNotEmpty) {
          final firstError = errors.values.first;
          if (firstError is List) errorMessage = firstError.first;
        }
      }
      throw ServerException(errorMessage);
    }
  }
}
