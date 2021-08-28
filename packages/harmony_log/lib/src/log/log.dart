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
  ///
  /// this will call output init method
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
  ///
  /// this will call output close method
  void close();
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
