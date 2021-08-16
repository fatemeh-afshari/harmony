import 'package:harmony_log/src/level/level.dart';
import 'package:uuid/uuid.dart';

/// log event
class LogEvent {
  final String id;
  final DateTime time;
  final String? tag;
  final LogLevel level;
  final String message;
  final Object? error;
  final StackTrace? stackTrace;
  final Object? extra;

  const LogEvent({
    required this.id,
    required this.time,
    required this.tag,
    required this.level,
    required this.message,
    required this.error,
    required this.stackTrace,
    required this.extra,
  });

  factory LogEvent.generate({
    required String? tag,
    required LogLevel level,
    required String message,
    required Object? error,
    required StackTrace? stackTrace,
    required Object? extra,
  }) =>
      LogEvent(
        id: Uuid().v1(),
        time: DateTime.now(),
        tag: tag,
        level: level,
        message: message,
        error: error,
        stackTrace: stackTrace,
        extra: extra,
      );
}
