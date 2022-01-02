import 'package:harmony_log/src/plain/output/impl/noop.dart';
import 'package:meta/meta.dart';

/// THIS IS A FAKE NOOP IMPLEMENTATION FOR FILE
@internal
class LogPlainOutputFileImpl extends LogPlainOutputNoopImpl {
  const LogPlainOutputFileImpl({
    required String path,
    String prefix = 'log_',
    String postfix = '',
    String ext = '.log',
  });
}
