import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';
import 'package:harmony_auth/src/manipulator/manipulator.dart';

const testUrl = 'https://test';

void main() {
  group('AuthManipulator', () {
    group('standard', () {
      test('basic', () {
        final request = RequestOptions(path: testUrl);
        final manipulator = AuthManipulator.standard();
        manipulator.manipulate(request, 'a1');
        expect(
          request.headers['authorization'],
          equals('Bearer a1'),
        );
      });
    });

    group('general', () {
      test('basic', () {
        final request = RequestOptions(path: testUrl);
        final manipulator = AuthManipulator.general((request, _) {
          request.headers['a'] = 'b';
        });
        manipulator.manipulate(request, 'a1');
        expect(
          request.headers['a'],
          equals('b'),
        );
      });
    });

    group('headers', () {
      test('basic', () {
        final request = RequestOptions(path: testUrl);
        final manipulator = AuthManipulator.headers((access) => {
              'a': 'b',
              'b': access,
            });
        manipulator.manipulate(request, 'a1');
        expect(
          request.headers['a'],
          equals('b'),
        );
        expect(
          request.headers['b'],
          equals('a1'),
        );
      });
    });

    group('header', () {
      test('basic', () {
        final request = RequestOptions(path: testUrl);
        final manipulator = AuthManipulator.header(
          'a',
          (access) => access * 2,
        );
        manipulator.manipulate(request, 'a1');
        expect(
          request.headers['a'],
          equals('a1a1'),
        );
      });
    });

    group('headerPrefixed', () {
      test('basic', () {
        final request = RequestOptions(path: testUrl);
        final manipulator = AuthManipulator.headerPrefixed(
          'a',
          'A',
        );
        manipulator.manipulate(request, 'a1');
        expect(
          request.headers['a'],
          equals('Aa1'),
        );
      });
    });
  });
}
