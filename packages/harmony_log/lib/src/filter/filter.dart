import 'package:harmony_log/src/event/event.dart';
import 'package:harmony_log/src/filter/impl/all.dart';
import 'package:harmony_log/src/filter/impl/by_tag.dart';
import 'package:harmony_log/src/filter/impl/debug.dart';
import 'package:harmony_log/src/filter/impl/exact_level.dart';
import 'package:harmony_log/src/filter/impl/extra.dart';
import 'package:harmony_log/src/filter/impl/general.dart';
import 'package:harmony_log/src/filter/impl/level.dart';
import 'package:harmony_log/src/filter/impl/none.dart';
import 'package:harmony_log/src/filter/impl/profile.dart';
import 'package:harmony_log/src/filter/impl/release.dart';
import 'package:harmony_log/src/filter/impl/tag.dart';
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
  /// accepts tags equal to [tag]
  const factory LogFilter.byTag(
    bool Function(String? tag) predicate,
  ) = LogFilterByTagImpl;

  /// tag implementation
  ///
  /// accepts extra equal to [extra]
  const factory LogFilter.extra(
    String? extra,
  ) = LogFilterExtraImpl;

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
