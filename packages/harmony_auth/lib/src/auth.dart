import 'package:logger/logger.dart';
import 'package:meta/meta.dart';

/// set logger for harmony auth module
class Auth {
  /// set logger for harmony auth module
  static Logger? logger;

  /// internal logging
  @internal
  static void log(String message) {
    logger?.i(message);
  }

  const Auth._internal();
}
