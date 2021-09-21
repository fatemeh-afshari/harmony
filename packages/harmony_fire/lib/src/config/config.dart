import 'package:harmony_log/harmony_log.dart';
import 'package:meta/meta.dart';

/// global configurations for harmony_login module
abstract class FireConfig {
  static Log? _log;

  /// get logger of `harmony_log` module
  static Log? get log => _log;

  /// set logger for harmony_auth module
  ///
  /// logger tag will be changed to `harmony_log`
  static set log(Log? value) {
    _log = value?.tagged('harmony_fire');
  }

  /// internal logging
  @internal
  static void logI(String message) {
    _log?.i(message);
  }

  const FireConfig._internal();
}
