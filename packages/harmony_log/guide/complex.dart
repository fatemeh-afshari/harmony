import 'package:harmony_log/harmony_log.dart';

void main() {
  final log1 = Log(
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
  log1.i('hello, there!');
  log1.log(LogLevel.verbose, 'hi');
  log1.log(LogLevel.wtf, 'hi');
  log1.e('bad code!', error: AssertionError(), extra: 'extra');

  final log2 = log1.tagged('OTHER');
  print(log2.tag); // => OTHER
  log2.i('starting other');

  // noop logger
  final log3 = Log(
    output: LogOutput.noop(),
  );
  log3.i('nothing will happen');

  // better approach for debug and release filter
  final log4 = Log(
    output: LogOutput.multi(children: [
      LogOutput.redirectOnRelease(
        child: LogOutput.filtered(
          filter: LogFilter.exactLevel(LogLevel.error),
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
      ),
      LogOutput.redirectOnDebug(
        child: LogOutput.filtered(
          filter: LogFilter.level(LogLevel.info),
          child: LogOutput.plain(
            format: LogPlainFormat.simple(),
            child: LogPlainOutput.console(),
          ),
        ),
      ),
    ]),
  );
  log4.w('warning!');

  final log5 = Log(
    output: LogOutput.plain(
      format: LogPlainFormat.custom(
        format: (event) => [event.message],
      ),
      child: LogPlainOutput.custom(
        write: (list) => list.forEach(print),
      ),
    ),
  );
  log5.wtf('what a terrible failure');

  // don't forget:
  log1.init();
  log1.close();
}
