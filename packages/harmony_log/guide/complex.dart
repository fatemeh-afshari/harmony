import 'package:harmony_log/harmony_log.dart';

void main() {
  final log1 = Log(
    id: LogId(),
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
  log1.init();
  log1.i('hello, there!');
  log1.log(LogLevel.verbose, 'hi');
  log1.log(LogLevel.wtf, 'hi');
  log1.e('bad code!', error: AssertionError(), extra: 'extra');

  final log2 = log1.tagged('OTHER');
  print(log2.tag); // => OTHER
  log2.i('starting other');

  log1.close(); // will close also log2

  // noop logger
  final log3 = Log(
    id: LogId.constant('ID'),
    output: LogOutput.noop(),
  );
  log3.init();
  log3.i('nothing will happen');
  log3.close();

  // better approach for debug and release filter
  final log4 = Log(
    id: LogId(),
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
            child: LogPlainOutput.multi(
              children: [
                LogPlainOutput.console(),
                LogPlainOutput.file(path: '/path/to/folder/'),
              ],
            ),
          ),
        ),
      ),
    ]),
  );
  log4.init();
  log4.w('warning!');
  log4.close();

  final log5 = Log(
    id: LogId.counter(start: 1000),
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
