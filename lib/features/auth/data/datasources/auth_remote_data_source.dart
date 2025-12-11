import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;

import '../../../../core/api/api_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/resources/app_strings.dart';
import '../../domain/entities/enums/user_enums.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../../../core/models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<Unit> register(RegisterParams params);
  Future<UserModel> login(LoginParams params);
  Future<Unit> verifyOtp({required String phoneNumber, required String code});
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

    request.headers.addAll({
      'Accept': 'application/json',
    });

    request.fields['first_name'] = params.firstName;
    request.fields['last_name'] = params.lastName;
    request.fields['phone_number'] = params.phoneNumber;
    request.fields['password'] = params.password;
    request.fields['date_of_birth'] = params.dob;
    request.fields['role'] = params.role == UserRole.owner ? 'owner' : 'tenant';
    request.fields['fcm_token'] = params.fcmToken;

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
      'phone_number': params.phoneNumber,
      'password': params.password,
      'fcm_token': params.fcmToken,
    });

    final response = await client.post(
      Uri.parse(ApiConstants.login),
      body: body,
      headers: _headers,
    );

    return _handleResponse(response, (json) => UserModel.fromJson(json));
  }

  // ... verifyOtp and logout are the same ...
  @override
  Future<Unit> verifyOtp(
      {required String phoneNumber, required String code}) async {
    final body = json.encode({'phone_number': phoneNumber, 'otp': code});
    final response = await client.post(
      Uri.parse(ApiConstants.verifyOtp),
      body: body,
      headers: _headers,
    );
    return _handleResponse(response, (_) => unit);
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

      if (jsonBody['errors'] != null && jsonBody['errors'] is Map) {
        final Map<String, dynamic> errors = jsonBody['errors'];
        if (errors.isNotEmpty) {
          final firstFieldErrors = errors.values.first;
          if (firstFieldErrors is List && firstFieldErrors.isNotEmpty) {
            errorMessage = firstFieldErrors.first.toString();
          } else if (firstFieldErrors is String) {
            errorMessage = firstFieldErrors;
          }
        }
      }
      throw ServerException(errorMessage);
    }
  }
//TODO check again
}
