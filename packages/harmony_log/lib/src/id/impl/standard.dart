import 'package:harmony_log/src/id/id.dart';
import 'package:uuid/uuid.dart';

class LogIdStandardImpl implements LogId {
  static const _uuid = Uuid();

  const LogIdStandardImpl();

  @override
  String generate() => _uuid.v1();
}
