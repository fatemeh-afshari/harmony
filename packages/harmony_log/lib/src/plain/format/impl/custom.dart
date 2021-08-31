import 'package:harmony_log/src/event/event.dart';
import 'package:harmony_log/src/plain/format/format.dart';

class LogPlainFormatCustomImpl implements LogPlainFormat {
  final Iterable<String> Function()? start0;
  final Iterable<String> Function(LogEvent event) format0;
  final Iterable<String> Function()? end0;

  const LogPlainFormatCustomImpl({
    Iterable<String> Function()? start,
    required Iterable<String> Function(LogEvent event) format,
    Iterable<String> Function()? end,
  })  : start0 = start,
        format0 = format,
        end0 = end;

  @override
  Iterable<String> start() => start0?.call() ?? [];

  @override
  Iterable<String> format(LogEvent event) => format0(event);

  @override
  Iterable<String> end() => end0?.call() ?? [];
}
