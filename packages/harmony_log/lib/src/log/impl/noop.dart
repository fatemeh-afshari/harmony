import 'package:harmony_log/src/event/event.dart';
import 'package:harmony_log/src/level/level.dart';
import 'package:harmony_log/src/log/base/default_tag_log.dart';
import 'package:meta/meta.dart';

@internal
class LogNoopImpl extends DefaultTagLog {
  const LogNoopImpl();

  @override
  void init() {
    // noop
  }

  @override
  void write(LogEvent event) {
    // noop
  }

  @override
  void log({
    required LogLevel level,
    required String message,
    required Object? error,
    required StackTrace? stackTrace,
    required Object? extra,
  }) {
    // noop
  }

  @override
  void close() {
    // noop
  }
}
