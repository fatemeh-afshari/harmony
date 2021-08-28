import 'package:harmony_log/src/log/log.dart';
import 'package:meta/meta.dart';

@internal
abstract class DefaultTagLog implements Log {
  const DefaultTagLog();

  @override
  String? get tag => null;
}
