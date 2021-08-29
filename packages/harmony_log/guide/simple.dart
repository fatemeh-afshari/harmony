import 'package:harmony_log/harmony_log.dart';

void main() {
  final log = Log(
    output: LogOutput.redirectOnDebug(
      child: LogOutput.plain(
        format: LogPlainFormat.simple(),
        child: LogPlainOutput.console(),
      ),
    ),
  );

  log.i('hello, there!');
  log.e('bad code!', error: AssertionError());
}
