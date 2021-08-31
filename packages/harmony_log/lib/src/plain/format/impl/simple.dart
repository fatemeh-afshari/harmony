import 'package:harmony_log/src/event/event.dart';
import 'package:harmony_log/src/level/level.dart';
import 'package:harmony_log/src/plain/format/format.dart';
import 'package:meta/meta.dart';

@internal
class LogPlainFormatSimpleImpl implements LogPlainFormat {
  static const _levels = {
    LogLevel.verbose: '[V]',
    LogLevel.debug: '[D]',
    LogLevel.info: '[I]',
    LogLevel.warning: '[W]',
    LogLevel.error: '[E]',
    LogLevel.wtf: '[W]',
  };

  final String prefix;

  const LogPlainFormatSimpleImpl({
    this.prefix = 'LOG ',
  });

  @override
  Iterable<String> format(LogEvent event) => [_line(event)];

  String _line(LogEvent event) {
    final s = StringBuffer();
    s.write(prefix);
    s.write(event.time.toIso8601String());
    final tag = event.tag;
    if (tag != null) {
      s.write(' ');
      s.write(tag);
    }
    s.write(' ');
    s.write(_levels[event.level]!);
    s.write(' ');
    s.write(event.message);
    final error = event.error;
    if (error != null) {
      s.write(' ERROR=');
      s.write(error);
    }
    return s.toString();
  }
}
