import 'package:harmony_log/src/event/event.dart';
import 'package:harmony_log/src/filter/base/abstract_filter.dart';
import 'package:harmony_log/src/filter/filter.dart';
import 'package:meta/meta.dart';

@internal
class SymmetricDifferenceLogFilter extends AbstractLogFilter {
  final LogFilter m1;
  final LogFilter m2;

  const SymmetricDifferenceLogFilter(this.m1, this.m2);

  @override
  bool shouldLog(LogEvent event) => m1.shouldLog(event) ^ m2.shouldLog(event);
}
