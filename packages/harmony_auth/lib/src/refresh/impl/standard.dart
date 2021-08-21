import 'package:dio/dio.dart';
import 'package:harmony_auth/harmony_auth.dart';
import 'package:meta/meta.dart';

import '../../auth.dart';
import '../../rest/rest.dart';
import '../../storage/storage.dart';
import '../refresh.dart';

@internal
class AuthRefreshStandardImpl implements AuthRefresh {
  final AuthStorage storage;
  final AuthRest rest;

  const AuthRefreshStandardImpl({
    required this.storage,
    required this.rest,
  });

  @override
  Future<void> refresh() async {
    _log('refresh, checking if token is available ...');
    final token1 = await storage.get();
    if (token1 != null) {
      _log('token is available, attempting to call rest ...');
      try {
        final token2 = await rest.refreshTokens(token1.refresh);
        await storage.set(token2);
      } on AuthException catch (_) {
        _log('rest call finished, refresh token is not valid, error');
        await storage.remove();
        throw AuthException();
      } on DioError catch (_) {
        _log('rest call finished with network error, error');
        rethrow;
      } catch (_) {
        _log('rest call finished with bad error type (!), error');
        rethrow;
      }
    } else {
      _log('no token available, error');
      throw AuthException();
    }
  }

  void _log(String message) {
    Auth.log('harmony_auth refresh.standard: $message');
  }
}
