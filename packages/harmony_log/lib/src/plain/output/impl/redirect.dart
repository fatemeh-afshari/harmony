import 'package:harmony_log/src/plain/output/output.dart';
import 'package:meta/meta.dart';

@internal
class LogPlainOutputRedirectImpl implements LogPlainOutput {
  final bool enabled;

  final LogPlainOutput child;

  const LogPlainOutputRedirectImpl({
    this.enabled = true,
    required this.child,
  });

  @override
  void init() {
    if (enabled) {
      child.init();
    }
  }

  @override
  void write(Iterable<String> list) {
    if (enabled) {
      child.write(list);
    }
  }

  @override
  void close() {
    if (enabled) {
      child.close();
    }
  }
}
