import 'package:harmony_log/harmony_log.dart';
import 'package:meta/meta.dart';

/// global configurations for harmony_auth module
abstract class AuthConfig {
  /// set logger for harmony_auth module
  static Log? logger;

  /// internal logging
  @internal
  static void log(String message) {
    logger?.i(message);
  }

  const AuthConfig._internal();
}
