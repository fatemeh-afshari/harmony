import 'package:harmony_log/harmony_log.dart';

void main() {
  final log = Log(
    output: LogOutput.filtered(
      filter: LogFilter.debug(),
      child: LogOutput.plain(
        format: LogPlainFormat.simple(),
        child: LogPlainOutput.console(),
      ),
    ),
  );

  log.i('hello, there!');
  log.e('bad code!', error: AssertionError());
}
