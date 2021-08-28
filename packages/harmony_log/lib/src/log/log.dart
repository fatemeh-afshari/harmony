import 'package:harmony_log/src/event/event.dart';
import 'package:harmony_log/src/level/level.dart';
import 'package:harmony_log/src/log/impl/noop.dart';
import 'package:harmony_log/src/log/impl/standard.dart';
import 'package:harmony_log/src/log/impl/tagged.dart';

/// Log class
///
/// logger has null tag by default
abstract class Log {
  /// standard logger
  const factory Log() = LogStandardImpl;

  /// noop logger
  const factory Log.noop() = LogNoopImpl;

  /// tagged logger
  ///
  /// create a new logger based on this logger with a new tag.
  ///
  /// all of the new logger method calls will redirect
  /// to base logger.
  const factory Log.tagged({
    required String? tag,
    required Log child,
  }) = LogTaggedImpl;

  /// initialized logger
  ///
  /// logger can not be used before initialization
  ///
  /// all of tagged loggers also initialize
  ///
  /// this can complete asynchronously
  void init();

  /// get this logger's tag
  ///
  /// logger has null tag by default
  String? get tag;

  /// log events
  ///
  /// should be implemented by sub-classes
  void write(LogEvent event);

  /// log
  ///
  /// use abbreviated methods like: [v], ..., [wtf]
  ///
  /// this can complete asynchronously
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
  ///
  /// this can complete asynchronously
  void close();
}

/// extension for abbreviated log methods
///
/// all of methods can complete asynchronously
extension LogLevelExt on Log {
  /// verbose
  void v(
    String message, [
    Object? error,
    StackTrace? stackTrace,
    Object? extra,
  ]) =>
      log(
        level: LogLevel.verbose,
        message: message,
        error: error,
        stackTrace: stackTrace,
        extra: extra,
      );

  /// debug
  void d(
    String message, [
    Object? error,
    StackTrace? stackTrace,
    Object? extra,
  ]) =>
      log(
        level: LogLevel.debug,
        message: message,
        error: error,
        stackTrace: stackTrace,
        extra: extra,
      );

  /// info
  void i(
    String message, [
    Object? error,
    StackTrace? stackTrace,
    Object? extra,
  ]) =>
      log(
        level: LogLevel.info,
        message: message,
        error: error,
        stackTrace: stackTrace,
        extra: extra,
      );

  /// warning
  void w(
    String message, [
    Object? error,
    StackTrace? stackTrace,
    Object? extra,
  ]) =>
      log(
        level: LogLevel.warning,
        message: message,
        error: error,
        stackTrace: stackTrace,
        extra: extra,
      );

  /// error
  void e(
    String message, [
    Object? error,
    StackTrace? stackTrace,
    Object? extra,
  ]) =>
      log(
        level: LogLevel.error,
        message: message,
        error: error,
        stackTrace: stackTrace,
        extra: extra,
      );

  /// wtf
  /// (what a terrible failure)
  void wtf(
    String message, [
    Object? error,
    StackTrace? stackTrace,
    Object? extra,
  ]) =>
      log(
        level: LogLevel.wtf,
        message: message,
        error: error,
        stackTrace: stackTrace,
        extra: extra,
      );
}

/// extension to add tag to a logger
extension LogTagExt on Log {
  /// tagged logger
  ///
  /// create a new logger based on this logger with a new tag.
  ///
  /// all of the new logger method calls will redirect
  /// to base logger.
  Log withTag(String? tag) => Log.tagged(
        tag: tag,
        child: this,
      );
}
