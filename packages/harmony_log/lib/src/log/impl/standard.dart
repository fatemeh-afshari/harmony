import 'package:harmony_log/src/event/event.dart';
import 'package:harmony_log/src/log/base/abstract_log.dart';
import 'package:meta/meta.dart';

@internal
class LogStandardImpl extends AbstractLog {
  const LogStandardImpl() : super();

  @override
  void init() {}

  @override
  void write(LogEvent event) {
    print(event.message);
  }

  @override
  void close() {}
}
