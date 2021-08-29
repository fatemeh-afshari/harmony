import 'package:harmony_log/src/event/event.dart';
import 'package:harmony_log/src/log/base/abstract_log.dart';
import 'package:harmony_log/src/output/output.dart';
import 'package:meta/meta.dart';

@internal
class LogStandardImpl extends AbstractLog {
  final LogOutput output;

  const LogStandardImpl({
    required this.output,
  }) : super();

  @override
  void init() {
    throw 0;
  }

  @override
  void write(LogEvent event) {
    throw 0;
  }

  @override
  void close() {
    throw 0;
  }
}
