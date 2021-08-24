/// log level
///
/// Level with more significance is bigger
enum LogLevel {
  /// significance: 0
  verbose,

  /// significance: 1
  debug,

  /// significance: 2
  info,

  /// significance: 3
  warning,

  /// significance: 4
  error,

  /// significance: 5
  ///
  /// (what a terrible failure)
  wtf,
}

/// operations on [LogLevel]
extension LogLevelExt on LogLevel {
  int compareTo(LogLevel other) => index.compareTo(other.index);

  bool operator >=(LogLevel other) => index >= other.index;

  bool operator >(LogLevel other) => index > other.index;

  bool operator <(LogLevel other) => index < other.index;

  bool operator <=(LogLevel other) => index <= other.index;
}
