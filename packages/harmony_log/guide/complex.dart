import 'package:harmony_log/harmony_log.dart';

void main() {
  final log = Log(
    output: LogOutput.multi(children: [
      LogOutput.filtered(
        filter: LogFilter.release() & LogFilter.exactLevel(LogLevel.error),
        child: LogOutput.custom(
          init: () {
            print('initialize analytics');
          },
          write: (e) {
            print('send to analytics: ${e.message}');
          },
          close: () {
            print('close analytics');
          },
        ),
      ),
      LogOutput.filtered(
        filter: LogFilter.debug() & LogFilter.level(LogLevel.info),
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

  final logForOther = log.tagged('OTHER');
  print(logForOther.tag); // => OTHER
  logForOther.i('starting other');

  // noop logger
  final noopLogger = Log(
    output: LogOutput.noop(),
  );
  noopLogger.i('nothing will happen');
}
