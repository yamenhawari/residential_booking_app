import 'dart:io';

abstract class ApiConsumer {
  Future<dynamic> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    bool requiresAuth = true,
  });

  Future<dynamic> post(
    String path, {
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
    bool requiresAuth = true,
  });

  Future<dynamic> put(
    String path, {
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
    bool requiresAuth = true,
  });

  Future<dynamic> delete(
    String path, {
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
    bool requiresAuth = true,
  });

  Future<dynamic> postMultipart(
    String path, {
    required Map<String, String> fields,
    required List<FileParam> files,
    bool isPut = false,
    bool requiresAuth = true,
  });
}

class FileParam {
  final String name;
  final File file;

  FileParam({required this.name, required this.file});
}
