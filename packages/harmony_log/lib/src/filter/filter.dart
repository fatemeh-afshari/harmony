import 'package:harmony_log/src/event/event.dart';
import 'package:harmony_log/src/filter/impl/general.dart';
import 'package:harmony_log/src/filter/impl/level.dart';
import 'package:harmony_log/src/level/level.dart';

/// log filter
abstract class LogFilter {
  /// general implementation
  const factory LogFilter.general(
    bool Function(LogEvent event) predicate,
  ) = LogFilterGeneralImpl;

  /// general implementation
  const factory LogFilter.level(
    LogLevel level,
  ) = LogFilterLevelImpl;

  /// check if should log a specific log event
  bool shouldLog(LogEvent event);

  /// union
  LogFilter operator |(LogFilter other);

  /// intersection
  LogFilter operator &(LogFilter other);

  /// difference
  LogFilter operator -(LogFilter other);

  /// symmetric difference
  LogFilter operator ^(LogFilter other);

  /// negate
  LogFilter operator -();
}
