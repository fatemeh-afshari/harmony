import 'package:harmony_log/src/level/level.dart';
import 'package:harmony_log/src/log/impl/standard.dart';
import 'package:harmony_log/src/log/impl/tagged.dart';

/// Log class
///
/// logger has null tag by default
abstract class Log {
  /// standard logger
  const factory Log() = LogStandardImpl;

  /// tagged logger
  const factory Log.tagged({
    required String? tag,
    required Log child,
  }) = LogTaggedImpl;

  /// initialized logger
  ///
  /// logger can not be used before initialization
  ///
  /// all of tagged loggers also initialize
  void init();

  /// get this logger's tag
  ///
  /// logger has null tag by default
  String? get tag;

  /// log
  ///
  /// use abbreviated methods like: [v], ..., [wtf]
  void log({
    required LogLevel level,
    required String message,
    required Object? error,
    required StackTrace? stackTrace,
    required Object? extra,
  });

  /// close
  ///
  /// after closing you can not call log methods
  ///
  /// all of tagged loggers also closes
  void close();
}

/// extension for abbreviated log methods
extension LogLevelsExt on Log {
  /// verbose
  void v(
    String message, [
    Object? error,
    StackTrace? stackTrace,
    Object? extra,
  ]) {
    log(
      level: LogLevel.verbose,
      message: message,
      error: error,
      stackTrace: stackTrace,
      extra: extra,
    );
  }

  /// debug
  void d(
    String message, [
    Object? error,
    StackTrace? stackTrace,
    Object? extra,
  ]) {
    log(
      level: LogLevel.error,
      message: message,
      error: error,
      stackTrace: stackTrace,
      extra: extra,
    );
  }

  /// info
  void i(
    String message, [
    Object? error,
    StackTrace? stackTrace,
    Object? extra,
  ]) {
    log(
      level: LogLevel.info,
      message: message,
      error: error,
      stackTrace: stackTrace,
      extra: extra,
    );
  }

  /// warning
  void w(
    String message, [
    Object? error,
    StackTrace? stackTrace,
    Object? extra,
  ]) {
    log(
      level: LogLevel.warning,
      message: message,
      error: error,
      stackTrace: stackTrace,
      extra: extra,
    );
  }

  /// error
  void e(
    String message, [
    Object? error,
    StackTrace? stackTrace,
    Object? extra,
  ]) {
    log(
      level: LogLevel.error,
      message: message,
      error: error,
      stackTrace: stackTrace,
      extra: extra,
    );
  }

  /// wtf
  /// (what a terrible failure)
  void wtf(
    String message, [
    Object? error,
    StackTrace? stackTrace,
    Object? extra,
  ]) {
    log(
      level: LogLevel.wtf,
      message: message,
      error: error,
      stackTrace: stackTrace,
      extra: extra,
    );
  }
}

/// extension to add tag to a logger
extension LogTagExt on Log {
  /// create a new logger based on this logger with a new tag
  Log withTag(String? tag) => Log.tagged(
        tag: tag,
        child: this,
      );
}
