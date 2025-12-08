class ServerException implements Exception {
  final String message;
  const ServerException(this.message);
}

class CacheException implements Exception {}

class OfflineException implements Exception {}
