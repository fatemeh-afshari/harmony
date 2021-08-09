import 'package:meta/meta.dart';

import '../matcher.dart';
import 'difference.dart';
import 'intersection.dart';
import 'not.dart';
import 'symmetric_difference.dart';
import 'union.dart';

/// basic utilities for set operations
@internal
abstract class AbstractAuthMatcher implements AuthMatcher {
  const AbstractAuthMatcher();

  @override
  AuthMatcher operator |(AuthMatcher other) => UnionAuthMatcher(this, other);

  @override
  AuthMatcher operator &(AuthMatcher other) =>
      IntersectionAuthMatcher(this, other);

  @override
  AuthMatcher operator -(AuthMatcher other) =>
      DifferenceAuthMatcher(this, other);

  @override
  AuthMatcher operator ^(AuthMatcher other) =>
      SymmetricDifferenceAuthMatcher(this, other);

  @override
  AuthMatcher operator -() => NotAuthMatcher(this);
}
