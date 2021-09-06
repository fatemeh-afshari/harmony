import 'package:harmony_log/src/filter/base/difference.dart';
import 'package:harmony_log/src/filter/base/intersection.dart';
import 'package:harmony_log/src/filter/base/not.dart';
import 'package:harmony_log/src/filter/base/symmetric_difference.dart';
import 'package:harmony_log/src/filter/base/union.dart';
import 'package:harmony_log/src/filter/filter.dart';
import 'package:meta/meta.dart';

/// basic utilities for set operations
@internal
abstract class AbstractLogFilter implements LogFilter {
  const AbstractLogFilter();

  @override
  LogFilter operator |(LogFilter other) => UnionLogFilter(this, other);

  @override
  LogFilter operator &(LogFilter other) => IntersectionLogFilter(this, other);

  @override
  LogFilter operator -(LogFilter other) => DifferenceLogFilter(this, other);

  @override
  LogFilter operator ^(LogFilter other) =>
      SymmetricDifferenceLogFilter(this, other);

  @override
  LogFilter operator -() => NotLogFilter(this);
}
