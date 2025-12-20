class ServerException implements Exception {
  final String message;
  const ServerException(this.message);
}

class CacheException implements Exception {}

class OfflineException implements Exception {}

class ConflictException implements Exception {
  final String message;
  const ConflictException(this.message);
}

class SelfBookingException implements Exception {
  final String message;
  const SelfBookingException(this.message);
}
