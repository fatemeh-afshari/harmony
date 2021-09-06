import 'package:harmony_log/src/id/id.dart';

class LogIdConstantImpl implements LogId {
  final String id;

  const LogIdConstantImpl([this.id = 'noop']);

  @override
  String generate() => id;
}
