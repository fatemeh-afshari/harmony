/// token result
class LoginResult {
  final String backend;
  final String refresh;
  final String access;

  const LoginResult({
    required this.backend,
    required this.refresh,
    required this.access,
  });
}
