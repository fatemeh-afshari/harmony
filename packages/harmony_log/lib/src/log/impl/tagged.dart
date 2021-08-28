import 'package:harmony_log/src/event/event.dart';
import 'package:harmony_log/src/level/level.dart';
import 'package:harmony_log/src/log/log.dart';
import 'package:meta/meta.dart';

@internal
class LogTaggedImpl implements Log {
  @override
  final String? tag;

  final Log child;

  const LogTaggedImpl({
    required this.tag,
    required this.child,
  });

  @override
  void init() => child.init();

  @override
  void write(LogEvent event) => child.write(event);

  @override
  void log({
    required LogLevel level,
    required String message,
    required Object? error,
    required StackTrace? stackTrace,
    required Object? extra,
  }) =>
      child.log(
        level: level,
        message: message,
        error: error,
        stackTrace: stackTrace,
        extra: extra,
      );

  @override
  void close() => child.close();
}
