import 'package:harmony_log/src/event/event.dart';
import 'package:harmony_log/src/level/level.dart';
import 'package:harmony_log/src/log/log.dart';
import 'package:meta/meta.dart';

@internal
abstract class AbstractLog implements Log {
  const AbstractLog();

  @override
  String? get tag => null;

  /// log events
  ///
  /// should be implemented by sub-classes
  void event(LogEvent event);

  @override
  void log({
    required LogLevel level,
    required String message,
    required Object? error,
    required StackTrace? stackTrace,
    required Object? extra,
  }) {
    event(LogEvent.generate(
      tag: tag,
      level: level,
      message: message,
      error: error,
      stackTrace: stackTrace,
      extra: extra,
    ));
  }
}
