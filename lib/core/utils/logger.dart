import 'dart:developer' as developer;

class Logger {
  static void i(String message) {
    developer.log('INFO: $message', name: 'Logger');
  }

  static void w(String message) {
    developer.log('WARNING: $message', name: 'Logger');
  }

  static void e(String message, [dynamic error, StackTrace? stackTrace]) {
    developer.log(
      'ERROR: $message',
      name: 'Logger',
      error: error,
      stackTrace: stackTrace,
    );
  }
}
