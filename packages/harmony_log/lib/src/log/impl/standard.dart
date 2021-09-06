import 'package:harmony_log/src/event/event.dart';
import 'package:harmony_log/src/id/id.dart';
import 'package:harmony_log/src/level/level.dart';
import 'package:harmony_log/src/log/log.dart';
import 'package:harmony_log/src/output/output.dart';
import 'package:meta/meta.dart';

@internal
class LogStandardImpl implements Log {
  final LogOutput output;

  final LogId id;

  const LogStandardImpl({
    this.tag = 'APP',
    required this.id,
    required this.output,
  });

  @override
  final String? tag;

  @override
  Log tagged(String? tag) => LogStandardImpl(
        tag: tag,
        id: id,
        output: output,
      );

  @override
  void init() {
    output.init();
  }

  @override
  void write(LogEvent event) {
    output.write(event);
  }

  @override
  void log(
    LogLevel level,
    String message, {
    Object? error,
    StackTrace? stackTrace,
    Object? extra,
  }) {
    final event = LogEvent(
      id: id.generate(),
      time: DateTime.now(),
      tag: tag,
      level: level,
      message: message,
      error: error,
      stackTrace: stackTrace,
      extra: extra,
    );
    write(event);
  }

  @override
  void close() {
    output.close();
  }
}
