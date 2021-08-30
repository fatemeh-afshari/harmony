import 'dart:io';

import 'package:harmony_log/src/plain/output/output.dart';
import 'package:meta/meta.dart';

/// state of file output
enum _State {
  initial,
  initialized,
  closeCommand,
  closed,
}

/// The flush method does not sent any signals to the io system,
/// or push data through any faster. It just returns a future
/// that completes when there is no data buffered in the IOSink object.
/// It essentially just adds an empty stream to the IOSink,
/// and signals when this empty stream is completed.
@internal
class LogPlainOutputFileImpl implements LogPlainOutput {
  static const logStart = 'HARMONY_LOG INITIALIZED';
  static const logEnd = 'HARMONY_LOG CLOSED';

  final String path;
  final String prefix;
  final String postfix;
  final String ext;

  LogPlainOutputFileImpl({
    required this.path,
    this.prefix = 'log_',
    this.postfix = '',
    this.ext = '.log',
  });

  var _state = _State.initial;

  /// will be non null between
  /// [_State.initialized] and [_State.closeCommand] inclusive.
  IOSink? _sink;

  @override
  void init() {
    if (_state == _State.initial) {
      var directory = Directory(path);
      // only assert on debug
      assert((() => directory.existsSync())());
      var filePath = directory.path +
          Platform.pathSeparator +
          prefix +
          DateTime.now().toIso8601String().replaceAll(':', '-') +
          postfix +
          ext;
      final file = File(filePath);
      final sink0 = file.openWrite();
      sink0.writeln(logStart);
      _state = _State.initialized;
      _sink = sink0;
    }
  }

  @override
  void write(Iterable<String> list) {
    if (_state == _State.initialized) {
      final sink0 = _sink!;
      for (final line in list) {
        sink0.writeln(line);
      }
    } else {
      throw StateError('bad state');
    }
  }

  @override
  void close() {
    if (_state == _State.initialized) {
      _state = _State.closeCommand;
      // without await:
      _close();
    }
  }

  Future<void> _close() async {
    assert(_state == _State.closeCommand);
    final sink0 = _sink!;
    sink0.writeln(logEnd);
    await sink0.close();
    _state = _State.closed;
    _sink = null;
  }
}
