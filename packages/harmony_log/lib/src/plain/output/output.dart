import 'package:harmony_log/src/plain/output/impl/console.dart';
import 'package:harmony_log/src/plain/output/impl/custom.dart';
import 'package:harmony_log/src/plain/output/impl/file.dart';
import 'package:harmony_log/src/plain/output/impl/multi.dart';
import 'package:harmony_log/src/plain/output/impl/noop.dart';
import 'package:harmony_log/src/plain/output/impl/redirect.dart';

abstract class LogPlainOutput {
  /// console implementation
  const factory LogPlainOutput.console() = LogPlainOutputConsoleImpl;

  /// custom implementation
  const factory LogPlainOutput.custom({
    void Function()? init,
    void Function(Iterable<String> list)? write,
    void Function()? close,
  }) = LogPlainOutputCustomImpl;

  /// noop implementation
  const factory LogPlainOutput.noop() = LogPlainOutputNoopImpl;

  /// multi implementation
  const factory LogPlainOutput.multi({
    required List<LogPlainOutput> children,
  }) = LogPlainOutputMultiImpl;

  /// redirect implementation
  const factory LogPlainOutput.redirect({
    bool enabled,
    required LogPlainOutput child,
  }) = LogPlainOutputRedirectImpl;

  factory LogPlainOutput.file({
    required String path,
    String prefix,
    String postfix,
    String ext,
  }) = LogPlainOutputFileImpl;

  void init();

  void write(Iterable<String> list);

  void close();
}
