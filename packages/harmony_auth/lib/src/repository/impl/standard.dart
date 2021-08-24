import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

import '../../auth.dart';
import '../../matcher/matcher.dart';
import '../../rest/rest.dart';
import '../../storage/storage.dart';
import '../../token/token.dart';
import '../repository.dart';

@internal
class AuthRepositoryStandardImpl implements AuthRepository {
  final AuthStorage storage;
  final AuthRest rest;

  const AuthRepositoryStandardImpl({
    required this.storage,
    required this.rest,
  });

  @override
  Future<void> refreshTokens() async {
    _log('refresh, checking if token is available ...');
    try {
      final token1 = await storage.getToken();
      if (token1 != null) {
        _log('token is available, attempting to call rest ...');
        try {
          final token2 = await rest.refreshTokens(token1);
          await storage.setToken(token2);
        } on AuthRestException {
          _log('rest call finished, refresh token is not valid, error');
          await storage.removeToken();
          throw AuthRepositoryExceptionStandardImpl();
        } on DioError {
          _log('rest call finished with network error, error');
          rethrow;
        } on AuthStorageException {
          rethrow;
        } on Object {
          _log('rest call finished with bad error type (!), error');
          rethrow;
        }
      } else {
        _log('no token available, error');
        throw AuthRepositoryExceptionStandardImpl();
      }
    } on AuthStorageException {
      _log('storage problem occurred, error');
      rethrow;
    }
  }

  @override
  AuthMatcher get refreshTokensMatcher => rest.refreshTokensMatcher;

  @override
  Future<AuthToken?> getToken() => storage.getToken();

  @override
  Future<void> removeToken() => storage.removeToken();

  @override
  Future<void> setToken(AuthToken token) => storage.setToken(token);

  void _log(String message) {
    Auth.log('harmony_auth refresh.standard: $message');
  }

  @override
  Future<AuthStatus> get status async => await storage.status;

  @override
  Stream<AuthStatus> get statusStream => storage.statusStream;

  @override
  Future<void> initializeStatusStream() async {
    await storage.initializeStatusStream();
  }
}

@internal
class AuthRepositoryExceptionStandardImpl implements AuthRepositoryException {
  const AuthRepositoryExceptionStandardImpl();

  @override
  String toString() => 'AuthRepositoryException.standard';
}
