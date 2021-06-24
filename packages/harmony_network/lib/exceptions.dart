class InvalidConfigException implements Exception {
  const InvalidConfigException([this.message]);
  final String? message;

  @override
  String toString() {
    return generateError(this, message);
  }
}

class NoConfigFoundException implements Exception {
  const NoConfigFoundException([this.message]);
  final String? message;

  @override
  String toString() {
    return generateError(this, message);
  }
}

String generateError(Exception e, String? error) {
  final errorOutput = error == null ? '' : ' \n$error';
  return '\n✗ ERROR: ${(e).runtimeType.toString()}$errorOutput';
}
