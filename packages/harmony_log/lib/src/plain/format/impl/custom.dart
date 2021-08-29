import 'package:harmony_log/src/event/event.dart';
import 'package:harmony_log/src/plain/format/format.dart';

class LogPlainFormatCustomImpl implements LogPlainFormat {
  final Iterable<String> Function(LogEvent event) format0;

  const LogPlainFormatCustomImpl(this.format0);

  @override
  Iterable<String> format(LogEvent event) => format0(event);
}
