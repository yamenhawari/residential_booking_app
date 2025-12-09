import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;

import '../../../../core/api/api_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/resources/app_strings.dart';
import '../../domain/entities/enums/user_enums.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> register(RegisterParams params);
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
  Future<UserModel> register(RegisterParams params) async {
    // 1. Create Multipart Request
    final request =
        http.MultipartRequest('POST', Uri.parse(ApiConstants.register));

    // 2. Add Headers (Accept JSON is crucial for Laravel/Node backends to return JSON errors)
    request.headers.addAll({
      'Accept': 'application/json',
    });

    // 3. Add Text Fields
    request.fields['first_name'] = params.firstName;
    request.fields['last_name'] = params.lastName;
    request.fields['phone_number'] = params.phoneNumber;
    request.fields['password'] = params.password;
    request.fields['date_of_birth'] = params.dob;
    request.fields['role'] = params.role == UserRole.owner ? 'owner' : 'tenant';
    request.fields['fcm_token'] = params.fcmToken;

    // 4. Add Files
    // Helper function to detect mime type could be added, but default stream is usually fine.
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

    // 5. Send and Handle Response
    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    return _handleResponse(response, (json) => UserModel.fromJson(json));
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

  /// Improved Response Handler
  /// Extracts specific validation errors like "Phone taken"
  T _handleResponse<T>(http.Response response, T Function(dynamic) onSuccess) {
    final jsonBody = json.decode(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return onSuccess(jsonBody);
    } else {
      // 1. Default Message
      String errorMessage = jsonBody['message'] ?? AppStrings.error.server;

      // 2. Check for Validation Errors object
      // Backend format: { "errors": { "phone": ["taken"], "password": ["short"] } }
      if (jsonBody['errors'] != null && jsonBody['errors'] is Map) {
        final Map<String, dynamic> errors = jsonBody['errors'];

        if (errors.isNotEmpty) {
          // Grab the first error message from the first field that failed
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
}
