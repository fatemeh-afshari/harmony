import 'package:harmony_log/src/event/event.dart';
import 'package:harmony_log/src/plain/format/impl/custom.dart';
import 'package:harmony_log/src/plain/format/impl/simple.dart';

abstract class LogPlainFormat {
  /// simple implementation
  const factory LogPlainFormat.simple({
    String prefix,
  }) = LogPlainFormatSimpleImpl;

  /// custom implementation
  const factory LogPlainFormat.custom(
    Iterable<String> Function(LogEvent event) format,
  ) = LogPlainFormatCustomImpl;

  Iterable<String> format(LogEvent event);
}
