import 'package:harmony_log/src/event/event.dart';
import 'package:harmony_log/src/filter/impl/all.dart';
import 'package:harmony_log/src/filter/impl/by_error.dart';
import 'package:harmony_log/src/filter/impl/by_extra.dart';
import 'package:harmony_log/src/filter/impl/by_level.dart';
import 'package:harmony_log/src/filter/impl/by_message.dart';
import 'package:harmony_log/src/filter/impl/by_tag.dart';
import 'package:harmony_log/src/filter/impl/debug.dart';
import 'package:harmony_log/src/filter/impl/exact_level.dart';
import 'package:harmony_log/src/filter/impl/extra.dart';
import 'package:harmony_log/src/filter/impl/custom.dart';
import 'package:harmony_log/src/filter/impl/level.dart';
import 'package:harmony_log/src/filter/impl/none.dart';
import 'package:harmony_log/src/filter/impl/profile.dart';
import 'package:harmony_log/src/filter/impl/release.dart';
import 'package:harmony_log/src/filter/impl/tag.dart';
import 'package:harmony_log/src/level/level.dart';

/// log filter
abstract class LogFilter {
  /// custom implementation
  const factory LogFilter.custom(
    bool Function(LogEvent event) predicate,
  ) = LogFilterCustomImpl;

  /// level implementation
  ///
  /// accepts levels greater than or equal to [level]
  const factory LogFilter.level(
    LogLevel level,
  ) = LogFilterLevelImpl;

  /// level implementation
  ///
  /// accepts levels greater than or equal to [level]
  const factory LogFilter.byLevel(
    bool Function(LogLevel level) predicate,
  ) = LogFilterByLevelImpl;

  /// exactLevel implementation
  ///
  /// accepts levels only equal to [level]
  const factory LogFilter.exactLevel(
    LogLevel level,
  ) = LogFilterExactLevelImpl;

  /// tag implementation
  ///
  /// accepts tags equal to [tag]
  const factory LogFilter.tag(
    String? tag,
  ) = LogFilterTagImpl;

  /// byTag implementation
  ///
  /// accepts tags matched using predicate
  const factory LogFilter.byTag(
    bool Function(String? tag) predicate,
  ) = LogFilterByTagImpl;

  /// byMessage implementation
  ///
  /// accepts messages matched using predicate
  const factory LogFilter.byMessage(
    bool Function(String? message) predicate,
  ) = LogFilterByMessageImpl;

  /// byError implementation
  ///
  /// accepts errors matched using predicate
  const factory LogFilter.byError(
    bool Function(Object? error) predicate,
  ) = LogFilterByErrorImpl;

  /// tag implementation
  ///
  /// accepts extra equal to [extra]
  const factory LogFilter.extra(
    String? extra,
  ) = LogFilterExtraImpl;

  /// byExtra implementation
  ///
  /// accepts errors matched using predicate
  const factory LogFilter.byExtra(
    bool Function(Object? extra) predicate,
  ) = LogFilterByExtraImpl;

  /// all implementation
  const factory LogFilter.all() = LogFilterAllImpl;

  /// none implementation
  const factory LogFilter.none() = LogFilterNoneImpl;

  /// debug implementation
  ///
  /// only on debug mode
  const factory LogFilter.debug() = LogFilterDebugImpl;

  /// release implementation
  ///
  /// only on release mode
  const factory LogFilter.release() = LogFilterReleaseImpl;

  /// profile implementation
  ///
  /// only on profile mode
  const factory LogFilter.profile() = LogFilterProfileImpl;

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
