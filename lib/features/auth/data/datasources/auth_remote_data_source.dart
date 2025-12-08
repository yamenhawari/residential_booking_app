import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import '../../../../core/api/api_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/resources/app_strings.dart';
import '../../domain/entities/enums/user_enums.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> register({
    required String phoneNumber,
    required String password,
    required UserRole role,
    required String fcmToken,
  });

  Future<UserModel> login({
    required String phoneNumber,
    required String password,
    required String fcmToken,
  });

  Future<Unit> verifyOtp({
    required String phoneNumber,
    required String code,
  });

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
  Future<UserModel> register({
    required String phoneNumber,
    required String password,
    required UserRole role,
    required String fcmToken,
  }) async {
    final body = json.encode({
      'phone_number': phoneNumber,
      'password': password,
      'role': role == UserRole.owner ? 'owner' : 'tenant',
      'fcm_token': fcmToken,
    });

    final response = await client.post(
      Uri.parse(ApiConstants.register),
      body: body,
      headers: _headers,
    );

    return _handleResponse(response, (json) => UserModel.fromJson(json));
  }

  @override
  Future<UserModel> login({
    required String phoneNumber,
    required String password,
    required String fcmToken,
  }) async {
    final body = json.encode({
      'phone_number': phoneNumber,
      'password': password,
      'fcm_token': fcmToken,
    });

    final response = await client.post(
      Uri.parse(ApiConstants.login),
      body: body,
      headers: _headers,
    );

    return _handleResponse(response, (json) => UserModel.fromJson(json));
  }

  @override
  Future<Unit> verifyOtp(
      {required String phoneNumber, required String code}) async {
    final body = json.encode({
      'phone_number': phoneNumber,
      'otp': code,
    });

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
      final message = jsonBody['message'] ?? AppStrings.error.server;
      throw ServerException(message);
    }
  }
}
