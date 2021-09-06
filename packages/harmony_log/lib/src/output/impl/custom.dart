import 'package:harmony_log/src/event/event.dart';
import 'package:harmony_log/src/output/output.dart';
import 'package:meta/meta.dart';

@internal
class LogOutputCustomImpl implements LogOutput {
  final void Function()? init0;
  final void Function(LogEvent event)? write0;
  final void Function()? close0;

  const LogOutputCustomImpl({
    void Function()? init,
    void Function(LogEvent event)? write,
    void Function()? close,
  })  : init0 = init,
        write0 = write,
        close0 = close;

  @override
  void init() {
    init0?.call();
  }

  @override
  void write(LogEvent event) {
    write0?.call(event);
  }

  @override
  void close() {
    close0?.call();
  }
}
