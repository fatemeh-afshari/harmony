import 'package:harmony_log/src/event/event.dart';
import 'package:harmony_log/src/level/level.dart';
import 'package:harmony_log/src/plain/format/format.dart';
import 'package:meta/meta.dart';

@internal
class LogPlainFormatPrettyImpl implements LogPlainFormat {
  static const _levels = {
    LogLevel.verbose: 'VERBOSE',
    LogLevel.debug: 'DEBUG  ',
    LogLevel.info: 'INFO   ',
    LogLevel.warning: 'WARNING',
    LogLevel.error: 'ERROR  ',
    LogLevel.wtf: 'WTF    ',
  };

  final String prefix;

  const LogPlainFormatPrettyImpl({
    this.prefix = 'LOG ',
  });

  @override
  Iterable<String> format(LogEvent event) =>
      _format(event).toList().box(_prepend(event));

  String _prepend(LogEvent event) {
    final s = StringBuffer(prefix);
    final tag = event.tag;
    if (tag != null) {
      s.write(tag);
      s.write(' ');
    }
    s.write(_levels[event.level]!);
    s.write(' ');
    return s.toString();
  }

  Iterable<String> _format(LogEvent event) sync* {
    yield event.time.toIso8601String();
    yield event.message;
    final error = event.error;
    if (error != null) yield error.toString();
    final stackTrace = event.stackTrace;
    if (stackTrace != null) yield stackTrace.toString();
  }
}

@internal
extension StringLineCountExt on String {
  List<String> splitLines() => replaceAll('\r\n', '\n').split('\n');
}

/// todo: can not use: '┄'
@internal
extension StringListBoxingExt on List<String> {
  static const _columns = 120;
  static const _topLeftCorner = '┌';
  static const _bottomLeftCorner = '└';
  static const _middleCorner = '├';
  static const _verticalLine = '│';
  static const _doubleDivider = '─';
  static const _singleDivider = '·';

  List<String> box(String prefix) => _box(prefix).toList();

  Iterable<String> _box(String prepend) sync* {
    if (isEmpty) return;
    yield prepend + _topLeftCorner + _doubleDivider * (_columns - 1);
    for (var index = 0; index < length; index++) {
      final lines = this[index].splitLines();
      for (final line in lines) {
        yield prepend + _verticalLine + ' ' + line;
      }
      if (index == length - 1) {
        yield prepend + _bottomLeftCorner + _doubleDivider * (_columns - 1);
      } else {
        yield prepend + _middleCorner + _singleDivider * (_columns - 1);
      }
    }
  }
}
