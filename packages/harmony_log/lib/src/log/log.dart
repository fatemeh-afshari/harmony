import 'package:harmony_log/src/level/level.dart';

/// Log class
///
/// logger has null tag by default
abstract class Log {
  void init();

  /// get this logger's tag
  ///
  /// logger has null tag by default
  String? get tag;

  /// create a new logger based on this logger with a new tag
  Log withTag(String? tag);

  /// log
  ///
  /// use abbreviated methods like: [v], ..., [wtf]
  void log({
    LogLevel level,
    String message,
    Object? error,
    StackTrace? stackTrace,
    Object? extra,
  });

  /// verbose
  void v(
    String message, [
    Object? error,
    StackTrace? stackTrace,
    Object? extra,
  ]);

  /// debug
  void d(
    String message, [
    Object? error,
    StackTrace? stackTrace,
    Object? extra,
  ]);

  /// info
  void i(
    String message, [
    Object? error,
    StackTrace? stackTrace,
    Object? extra,
  ]);

  /// warning
  void w(
    String message, [
    Object? error,
    StackTrace? stackTrace,
    Object? extra,
  ]);

  /// error
  void e(
    String message, [
    Object? error,
    StackTrace? stackTrace,
    Object? extra,
  ]);

  /// wtf
  /// (what a terrible failure)
  void wtf(
    String message, [
    Object? error,
    StackTrace? stackTrace,
    Object? extra,
  ]);

  /// close
  ///
  /// after closing you can not call log methods
  ///
  /// all of tagged loggers also closes
  void close();
}
