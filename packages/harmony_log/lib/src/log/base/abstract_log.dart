import 'package:harmony_log/src/event/event.dart';
import 'package:harmony_log/src/level/level.dart';
import 'package:harmony_log/src/log/base/default_tag_log.dart';
import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';

@internal
abstract class AbstractLog extends DefaultTagLog {
  const AbstractLog();

  /// todo better implementation for id and time ?
  @override
  void log({
    required LogLevel level,
    required String message,
    required Object? error,
    required StackTrace? stackTrace,
    required Object? extra,
  }) {
    write(LogEvent(
      id: Uuid().v1(),
      time: DateTime.now(),
      tag: tag,
      level: level,
      message: message,
      error: error,
      stackTrace: stackTrace,
      extra: extra,
    ));
  }
}
