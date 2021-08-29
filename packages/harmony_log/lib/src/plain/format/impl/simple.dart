import 'package:harmony_log/src/event/event.dart';
import 'package:harmony_log/src/level/level.dart';
import 'package:harmony_log/src/plain/format/format.dart';

class LogPlainFormatSimpleImpl implements LogPlainFormat {
  static const prefix = 'HARMONY_LOG';

  const LogPlainFormatSimpleImpl();

  @override
  Iterable<String> format(LogEvent event) sync* {
    yield _line(event);
  }

  String _line(LogEvent event) {
    final s = StringBuffer();
    if (prefix.isNotEmpty) s.write('$prefix ');
    s.write('${_level(event.level)} ');
    if (event.tag != null) s.write('${event.tag} ');
    s.write('${event.message} ');
    if (event.error != null) s.write('${event.error} ');
    if (event.stackTrace != null) s.write('${event.stackTrace} ');
    return s.toString();
  }

  String _level(LogLevel level) =>
      level.toString().substring('LogEvent.'.length).toUpperCase();
}
