import 'package:meta/meta.dart';

import '../matcher/matcher.dart';
import '../token/token.dart';

/// subset [AuthRepository] to avoid usage of
/// external methods internally.
@internal
abstract class AuthRepositorySubset {
  /// refer to [AuthRepository]
  Future<void> refreshTokens();

  /// matcher to check to see if this call is from refresh tokens.
  @internal
  AuthMatcher get refreshTokensMatcher;

  /// refer to [AuthRepository]
  Future<AuthToken?> getToken();
}
