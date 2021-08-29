import 'package:harmony_log/src/event/event.dart';
import 'package:harmony_log/src/plain/format/impl/simple.dart';

abstract class LogPlainFormat {
  /// simple implementation
  const factory LogPlainFormat.simple() = LogPlainFormatSimpleImpl;

  Iterable<String> format(LogEvent event);
}
