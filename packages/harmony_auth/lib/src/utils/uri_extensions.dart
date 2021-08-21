import 'package:meta/meta.dart';

/// utilities to extract url from [Uri] to match
/// against it.
@internal
extension AuthUriExt on Uri {
  /// note: output should NOT contain queries
  ///
  /// note: output should start with http(s)
  ///
  /// todo: what about port ?
  String get url {
    final str = toString();
    final index = str.indexOf('?');
    return index == -1 ? str : str.substring(0, index);
  }
}
