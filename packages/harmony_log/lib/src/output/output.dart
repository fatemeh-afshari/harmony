import 'package:harmony_log/src/event/event.dart';
import 'package:harmony_log/src/output/impl/multi.dart';
import 'package:harmony_log/src/output/impl/noop.dart';
import 'package:harmony_log/src/output/impl/redirect.dart';

/// log output
abstract class LogOutput {
  /// noop implementation
  const factory LogOutput.noop() = LogOutputNoopImpl;

  /// multi implementation
  const factory LogOutput.multi(List<LogOutput> children) = LogOutputMultiImpl;

  /// redirect implementation
  const factory LogOutput.redirect(LogOutput child) = LogOutputRedirectImpl;

  /// initialized output
  ///
  /// output can not be used before initialization
  ///
  /// this can complete asynchronously
  ///
  /// [Log.init] will call this method for you
  void init();

  /// output event
  ///
  /// this can complete asynchronously
  void write(LogEvent event);

  /// initialized output
  ///
  /// output can not be used before initialization
  ///
  /// this can complete asynchronously
  ///
  /// [Log.close] will call this method for you
  void close();
}
