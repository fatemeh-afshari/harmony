import 'package:harmony_log/src/level/level.dart';

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
    this.tag,
    required this.level,
    required this.message,
    this.error,
    this.stackTrace,
    this.extra,
  });
}
