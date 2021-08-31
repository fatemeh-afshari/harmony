import 'package:harmony_log/src/event/event.dart';
import 'package:harmony_log/src/level/level.dart';
import 'package:harmony_log/src/log/log.dart';
import 'package:harmony_log/src/output/output.dart';
import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';

@internal
class LogStandardImpl implements Log {
  final LogOutput output;

  const LogStandardImpl({
    this.tag,
    required this.output,
  });

  @override
  final String? tag;

  @override
  Log tagged(String? tag) => LogStandardImpl(
        tag: tag,
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

  @override
  void close() {
    output.close();
  }
}
