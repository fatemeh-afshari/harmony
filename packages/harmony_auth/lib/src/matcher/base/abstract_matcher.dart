import 'package:harmony_auth/src/matcher/base/not_matcher.dart';
import 'package:meta/meta.dart';

import '../matcher.dart';
import 'difference_matcher.dart';
import 'intersection_matcher.dart';
import 'symmetric_difference_matcher.dart';
import 'union_matcher.dart';

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
