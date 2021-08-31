import 'dart:convert';

import 'package:harmony_log/src/event/event.dart';
import 'package:harmony_log/src/level/level.dart';
import 'package:harmony_log/src/plain/format/format.dart';
import 'package:meta/meta.dart';

@internal
class LogPlainFormatJsonImpl implements LogPlainFormat {
  static const _levels = {
    LogLevel.verbose: 'verbose',
    LogLevel.debug: 'debug',
    LogLevel.info: 'info',
    LogLevel.warning: 'warning',
    LogLevel.error: 'error',
    LogLevel.wtf: 'wtf',
  };

  const LogPlainFormatJsonImpl();

  Iterable<String> start(LogEvent event) => ['['];

  @override
  Iterable<String> format(LogEvent event) => [_format(event) + ','];

  Iterable<String> end(LogEvent event) => [']'];

  String _format(LogEvent event) => json.encode({
        'id': event.id,
        'time': event.time.toIso8601String(),
        'tag': event.tag,
        'level': _levels[event.level]!,
        'message': event.message,
        'error': event.error?.toString(),
        'stackTrace': event.stackTrace?.toString(),
        'extra': event.extra?.toString(),
      });
}
