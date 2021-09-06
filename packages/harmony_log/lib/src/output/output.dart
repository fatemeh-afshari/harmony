import 'package:harmony_log/src/event/event.dart';
import 'package:harmony_log/src/filter/filter.dart';
import 'package:harmony_log/src/output/impl/custom.dart';
import 'package:harmony_log/src/output/impl/filtered.dart';
import 'package:harmony_log/src/output/impl/multi.dart';
import 'package:harmony_log/src/output/impl/noop.dart';
import 'package:harmony_log/src/output/impl/plain.dart';
import 'package:harmony_log/src/output/impl/redirect.dart';
import 'package:harmony_log/src/output/impl/redirect_on_debug.dart';
import 'package:harmony_log/src/output/impl/redirect_on_profile.dart';
import 'package:harmony_log/src/output/impl/redirect_on_release.dart';
import 'package:harmony_log/src/plain/format/format.dart';
import 'package:harmony_log/src/plain/output/output.dart';

/// log output
abstract class LogOutput {
  /// noop implementation
  ///
  /// no operation
  const factory LogOutput.noop() = LogOutputNoopImpl;

  /// multi implementation
  ///
  /// redirect to multiple outputs
  const factory LogOutput.multi({
    required List<LogOutput> children,
  }) = LogOutputMultiImpl;

  /// redirect implementation
  ///
  /// redirect conditionally
  const factory LogOutput.redirect({
    bool enabled,
    required LogOutput child,
  }) = LogOutputRedirectImpl;

  /// redirectOnProfile implementation
  ///
  /// redirect conditionally on profile mode
  const factory LogOutput.redirectOnProfile({
    required LogOutput child,
  }) = LogOutputRedirectOnProfileImpl;

  /// redirectOnDebug implementation
  ///
  /// redirect conditionally on debug mode
  const factory LogOutput.redirectOnDebug({
    required LogOutput child,
  }) = LogOutputRedirectOnDebugImpl;

  /// redirectOnRelease implementation
  ///
  /// redirect conditionally on release mode
  const factory LogOutput.redirectOnRelease({
    required LogOutput child,
  }) = LogOutputRedirectOnReleaseImpl;

  /// filtered implementation
  ///
  /// filter and redirect events
  const factory LogOutput.filtered({
    required LogFilter filter,
    required LogOutput child,
  }) = LogOutputFilteredImpl;

  /// custom implementation
  ///
  /// custom logic
  const factory LogOutput.custom({
    void Function()? init,
    void Function(LogEvent event)? write,
    void Function()? close,
  }) = LogOutputCustomImpl;

  /// plain implementation
  ///
  /// output as a list of string lines
  const factory LogOutput.plain({
    required LogPlainFormat format,
    required LogPlainOutput child,
  }) = LogOutputPlainImpl;

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
