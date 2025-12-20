import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:residential_booking_app/core/datasources/user_local_data_source.dart';
import '../error/exceptions.dart';
import '../resources/app_strings.dart';
import 'api_consumer.dart';

class HttpApiConsumer implements ApiConsumer {
  final http.Client client;
  final UserLocalDataSource userLocalDataSource;

  static const Duration _timeoutDuration = Duration(seconds: 20);

  HttpApiConsumer({
    required this.client,
    required this.userLocalDataSource,
  });

  Future<Map<String, String>> _getHeaders({
    bool isMultipart = false,
    bool requiresAuth = true,
  }) async {
    final headers = {
      'Accept': AppStrings.api.accept,
    };

    if (!isMultipart) {
      headers['Content-Type'] = AppStrings.api.contentType;
    }

    if (requiresAuth) {
      final token = await userLocalDataSource.getToken();
      if (token.isNotEmpty) {
        headers['Authorization'] = '${AppStrings.api.bearer} $token';
      }
    }

    return headers;
  }

  Uri _buildUri(String path, Map<String, dynamic>? queryParameters) {
    final uri = Uri.parse(path);
    if (queryParameters != null && queryParameters.isNotEmpty) {
      return uri.replace(queryParameters: queryParameters);
    }
    return uri;
  }

  @override
  Future<dynamic> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    bool requiresAuth = true,
  }) async {
    try {
      final uri = _buildUri(path, queryParameters);
      final headers = await _getHeaders(requiresAuth: requiresAuth);

      final response =
          await client.get(uri, headers: headers).timeout(_timeoutDuration);

      return _handleResponse(response);
    } on TimeoutException {
      throw ServerException("Request timed out. Please try again later.");
    } on SocketException {
      throw ServerException("No internet connection.");
    }
  }

  @override
  Future<dynamic> post(
    String path, {
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
    bool requiresAuth = true,
  }) async {
    try {
      final uri = _buildUri(path, queryParameters);
      final headers = await _getHeaders(requiresAuth: requiresAuth);

      final response = await client
          .post(
            uri,
            headers: headers,
            body: body != null ? json.encode(body) : null,
          )
          .timeout(_timeoutDuration);
      return _handleResponse(response);
    } on TimeoutException {
      throw ServerException("Request timed out. Please try again later.");
    } on SocketException {
      throw ServerException("No internet connection.");
    }
  }

  @override
  Future<dynamic> put(
    String path, {
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
    bool requiresAuth = true,
  }) async {
    try {
      final uri = _buildUri(path, queryParameters);
      final headers = await _getHeaders(requiresAuth: requiresAuth);

      final response = await client
          .put(
            uri,
            headers: headers,
            body: body != null ? json.encode(body) : null,
          )
          .timeout(_timeoutDuration);
      return _handleResponse(response);
    } on TimeoutException {
      throw ServerException("Request timed out. Please try again later.");
    } on SocketException {
      throw ServerException("No internet connection.");
    }
  }

  @override
  Future<dynamic> delete(
    String path, {
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
    bool requiresAuth = true,
  }) async {
    try {
      final uri = _buildUri(path, queryParameters);
      final headers = await _getHeaders(requiresAuth: requiresAuth);

      final response = await client
          .delete(
            uri,
            headers: headers,
            body: body != null ? json.encode(body) : null,
          )
          .timeout(_timeoutDuration);

      return _handleResponse(response);
    } on TimeoutException {
      throw ServerException("Request timed out. Please try again later.");
    } on SocketException {
      throw ServerException("No internet connection.");
    }
  }

  @override
  Future<dynamic> postMultipart(
    String path, {
    required Map<String, String> fields,
    required List<FileParam> files,
    bool isPut = false,
    bool requiresAuth = true,
  }) async {
    try {
      final uri = Uri.parse(path);
      final request = http.MultipartRequest('POST', uri);

      request.headers.addAll(await _getHeaders(
        isMultipart: true,
        requiresAuth: requiresAuth,
      ));

      request.fields.addAll(fields);

      for (var fileParam in files) {
        if (await fileParam.file.exists()) {
          request.files.add(await http.MultipartFile.fromPath(
            fileParam.name,
            fileParam.file.path,
          ));
        }
      }

      final streamedResponse = await request.send().timeout(_timeoutDuration);
      final response = await http.Response.fromStream(streamedResponse);

      return _handleResponse(response);
    } on TimeoutException {
      throw ServerException(
          "Request timed out. Please check your connection and try again later.");
    } on SocketException {
      throw ServerException("No internet connection.");
    }
  }

  dynamic _handleResponse(http.Response response) {
    final jsonBody = _tryDecodeJson(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonBody;
    } else {
      String errorMessage = AppStrings.error.server;

      if (jsonBody is Map) {
        if (jsonBody['message'] != null) {
          errorMessage = jsonBody['message'];
        }
        if (jsonBody['errors'] != null) {
          final errors = jsonBody['errors'];
          if (errors is Map && errors.isNotEmpty) {
            final firstError = errors.values.first;
            if (firstError is List && firstError.isNotEmpty) {
              errorMessage = firstError.first;
            }
          }
        }
      }
      throw ServerException(errorMessage);
    }
  }

  dynamic _tryDecodeJson(String source) {
    try {
      return json.decode(source);
    } catch (e) {
      return source;
    }
  }
}
