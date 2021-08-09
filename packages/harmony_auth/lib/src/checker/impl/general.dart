import 'package:dio/src/dio_error.dart';

import '../checker.dart';

class AuthCheckerGeneralImpl implements AuthChecker {
  final bool Function(DioError error) lambda;

  const AuthCheckerGeneralImpl(this.lambda);

  @override
  bool isUnauthorizedError(DioError error) => lambda(error);
}
