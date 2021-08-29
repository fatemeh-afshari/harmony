import 'package:harmony_log/src/event/event.dart';
import 'package:harmony_log/src/plain/format/format.dart';

class LogPlainFormatSimpleImpl implements LogPlainFormat {
  const LogPlainFormatSimpleImpl();

  @override
  Iterable<String> format(LogEvent event) sync* {
    yield (event.tag ?? '') + ' ' + event.message;
  }
}
