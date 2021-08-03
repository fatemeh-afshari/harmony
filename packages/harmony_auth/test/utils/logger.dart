import 'package:logger/logger.dart';

Logger get noopLogger {
  return Logger(
    filter: NoopFilter(),
  );
}

class NoopFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) => false;
}
