import 'package:logger/logger.dart';
import 'package:meta/meta.dart';

/// global configurations for harmony_login module
abstract class FireConfig {
  /// set logger for harmony_login module
  static Logger? logger;

  /// internal logging
  @internal
  static void log(String message) {
    logger?.i(message);
  }

  const FireConfig._internal();
}
