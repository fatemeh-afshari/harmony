import 'package:harmony_log/src/level/level.dart';
import 'package:harmony_log/src/log/log.dart';

/// extension for abbreviated log methods
///
/// all of methods can complete asynchronously
extension LogLevelExt on Log {
  /// verbose
  void v(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    Object? extra,
  }) =>
      log(
        LogLevel.verbose,
        message,
        error: error,
        stackTrace: stackTrace,
        extra: extra,
      );

  /// debug
  void d(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    Object? extra,
  }) =>
      log(
        LogLevel.debug,
        message,
        error: error,
        stackTrace: stackTrace,
        extra: extra,
      );

  /// info
  void i(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    Object? extra,
  }) =>
      log(
        LogLevel.info,
        message,
        error: error,
        stackTrace: stackTrace,
        extra: extra,
      );

  /// warning
  void w(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    Object? extra,
  }) =>
      log(
        LogLevel.warning,
        message,
        error: error,
        stackTrace: stackTrace,
        extra: extra,
      );

  /// error
  void e(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    Object? extra,
  }) =>
      log(
        LogLevel.error,
        message,
        error: error,
        stackTrace: stackTrace,
        extra: extra,
      );

  /// wtf
  /// (what a terrible failure)
  void wtf(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    Object? extra,
  }) =>
      log(
        LogLevel.wtf,
        message,
        error: error,
        stackTrace: stackTrace,
        extra: extra,
      );
}
