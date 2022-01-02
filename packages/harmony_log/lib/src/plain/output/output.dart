import 'package:harmony_log/src/plain/output/impl/console.dart';
import 'package:harmony_log/src/plain/output/impl/custom.dart';
import 'package:harmony_log/src/plain/output/impl/file_fake.dart'
    if (dart.library.io) 'package:harmony_log/src/plain/output/impl/file.dart';
import 'package:harmony_log/src/plain/output/impl/multi.dart';
import 'package:harmony_log/src/plain/output/impl/noop.dart';
import 'package:harmony_log/src/plain/output/impl/redirect.dart';

abstract class LogPlainOutput {
  /// console implementation
  ///
  /// console using `print`
  const factory LogPlainOutput.console() = LogPlainOutputConsoleImpl;

  /// custom implementation
  ///
  /// custom logic
  const factory LogPlainOutput.custom({
    void Function()? init,
    void Function(Iterable<String> list)? write,
    void Function()? close,
  }) = LogPlainOutputCustomImpl;

  /// noop implementation
  ///
  /// no operation
  const factory LogPlainOutput.noop() = LogPlainOutputNoopImpl;

  /// multi implementation
  ///
  /// redirect to multiple outputs
  const factory LogPlainOutput.multi({
    required List<LogPlainOutput> children,
  }) = LogPlainOutputMultiImpl;

  /// redirect implementation
  ///
  /// redirect conditionally
  const factory LogPlainOutput.redirect({
    bool enabled,
    required LogPlainOutput child,
  }) = LogPlainOutputRedirectImpl;

  /// file implementation
  ///
  /// [path] is directory path
  ///
  /// output to a file
  factory LogPlainOutput.file({
    required String path,
    String prefix,
    String postfix,
    String ext,
  }) = LogPlainOutputFileImpl;

  /// initialize
  void init();

  /// write
  void write(Iterable<String> list);

  /// close
  void close();
}
