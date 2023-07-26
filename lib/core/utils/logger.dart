import 'dart:developer';

class CustomLogger {
  void info(String message) {
    log(message, level: 800);
  }

  void error(String message, [Object? error]) {
    log(message, level: 1000, error: error);
  }

  void debug(String message, [Object? error]) {
    log(message, level: 500, error: error);
  }

  void verbose(String message, [Object? error]) {
    log(message, level: 400, error: error);
  }
}
