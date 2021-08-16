/// log level
enum LogLevel {
  verbose,
  debug,
  info,
  warning,
  error,
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
