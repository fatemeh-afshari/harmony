import 'package:harmony_log/harmony_log.dart';

void main() {
  final log = Log(
    output: LogOutput.multi(children: [
      LogOutput.filtered(
        filter: LogFilter.exactLevel(LogLevel.error),
        child: LogOutput.custom(),
      ),
      LogOutput.filtered(
        filter: LogFilter.level(LogLevel.info),
        child: LogOutput.plain(
          format: LogPlainFormat.simple(),
          child: LogPlainOutput.console(),
        ),
      ),
    ]),
  );

  log.i('hello, there!');
  log.log(LogLevel.verbose, 'hi');
  log.log(LogLevel.wtf, 'hi');
  log.e('bad code!', error: AssertionError(), extra: 'extra');
}
