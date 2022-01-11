import 'package:harmony_log/harmony_log.dart';

void main() {
  final log = Log(
    id: LogId(),
    child: LogOutput.redirectOnDebug(
      child: LogOutput.plain(
        format: LogPlainFormat.simple(),
        child: LogPlainOutput.console(),
      ),
    ),
  );
  log.init();
  log.i('hello, there!');
  log.e('bad code!', error: AssertionError());
  log.close();
}
