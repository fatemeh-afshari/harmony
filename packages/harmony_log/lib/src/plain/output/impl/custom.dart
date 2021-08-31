import 'package:harmony_log/src/plain/output/output.dart';
import 'package:meta/meta.dart';

@internal
class LogPlainOutputCustomImpl implements LogPlainOutput {
  final void Function()? init0;
  final void Function(Iterable<String> list)? write0;
  final void Function()? close0;

  const LogPlainOutputCustomImpl({
    void Function()? init,
    void Function(Iterable<String> list)? write,
    void Function()? close,
  })  : init0 = init,
        write0 = write,
        close0 = close;

  @override
  void init() {
    init0?.call();
  }

  @override
  void write(Iterable<String> list) {
    write0?.call(list);
  }

  @override
  void close() {
    close0?.call();
  }
}
