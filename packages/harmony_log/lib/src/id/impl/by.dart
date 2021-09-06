import 'package:harmony_log/src/id/id.dart';

class LogIdByImpl implements LogId {
  final String Function() lambda;

  const LogIdByImpl(this.lambda);

  @override
  String generate() => lambda();
}
