import 'package:harmony_log/src/event/event.dart';
import 'package:harmony_log/src/filter/impl/all.dart';
import 'package:harmony_log/src/filter/impl/general.dart';
import 'package:harmony_log/src/filter/impl/level.dart';
import 'package:harmony_log/src/filter/impl/none.dart';
import 'package:harmony_log/src/level/level.dart';

/// log filter
abstract class LogFilter {
  /// general implementation
  const factory LogFilter.general(
    bool Function(LogEvent event) predicate,
  ) = LogFilterGeneralImpl;

  /// level implementation
  ///
  /// accepts levels greater than or equal to [level]
  const factory LogFilter.level(
    LogLevel level,
  ) = LogFilterLevelImpl;

  /// general implementation
  const factory LogFilter.all() = LogFilterAllImpl;

  /// general implementation
  const factory LogFilter.none() = LogFilterNoneImpl;

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
