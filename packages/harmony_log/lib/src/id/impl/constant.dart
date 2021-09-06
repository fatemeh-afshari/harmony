import 'package:harmony_log/src/id/id.dart';

class LogIdConstantImpl implements LogId {
  final String id;

  const LogIdConstantImpl(this.id);

  @override
  String generate() => id;
}
