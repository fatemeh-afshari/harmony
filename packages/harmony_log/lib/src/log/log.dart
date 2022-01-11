import 'package:harmony_log/src/event/event.dart';
import 'package:harmony_log/src/id/id.dart';
import 'package:harmony_log/src/level/level.dart';
import 'package:harmony_log/src/log/impl/standard.dart';
import 'package:harmony_log/src/output/output.dart';

/// Log class
///
/// logger has null tag by default
///
/// [Log] class is responsible for managing tags,
/// adding time and id info to events, and redirecting
/// events to outputs.
///
/// Note: [Log] class itself is also a [LogOutput].
/// But it provides more utilities over a bare [LogOutput].
/// Like [log], [tagged] or abbreviated methods like [i].
abstract class Log implements LogOutput {
  /// standard logger
  const factory Log({
    String? tag,
    required LogId id,
    required LogOutput child,
  }) = LogStandardImpl;

  /// tagged logger
  ///
  /// create a new logger based on this logger with a new tag.
  ///
  /// all of the new logger method calls will redirect
  /// to base logger.
  Log tagged(String? tag);

  /// initialized logger
  ///
  /// logger can not be used before initialization
  ///
  /// all of tagged loggers also initialize
  ///
  /// this can complete asynchronously
  ///
  /// this will call output init method
  @override
  void init();

  /// get this logger's tag
  ///
  /// logger has null tag by default
  String? get tag;

  /// write events
  ///
  /// this will call output write method
  ///
  /// this should be used only for redirecting one
  /// [Log] to another. Users should not call this
  /// method as it may cause inconsistencies ...
  @override
  void write(LogEvent event);

  /// log
  ///
  /// use abbreviated methods like: [v], ..., [wtf]
  ///
  /// this can complete asynchronously
  void log(
    LogLevel level,
    String message, {
    Object? error,
    StackTrace? stackTrace,
    Object? extra,
  });

  /// close
  ///
  /// after closing you can not call log methods
  ///
  /// all of tagged loggers also closes
  ///
  /// this can complete asynchronously
  ///
  /// this will call output close method
  @override
  void close();
}
