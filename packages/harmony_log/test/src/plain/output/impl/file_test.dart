import 'dart:async';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:harmony_log/src/plain/output/output.dart';
import 'package:uuid/uuid.dart';

void main() {
  group('LogPlainOutput', () {
    group('console', () {
      test('given not initialized when write then throw', () {
        final id = Uuid().v1();
        final path = Directory.systemTemp.path;
        final po = LogPlainOutput.file(
          path: path,
          prefix: 'prefix_${id}_',
          postfix: '_postfix',
          ext: '.txt',
        );
        expect(
          () => po.write(['abc', 'def']),
          throwsA(isA<StateError>()),
        );
      });

      test('when init and close then print init and close messages', () async {
        final id = Uuid().v1();
        final path = Directory.systemTemp.path;
        final po = LogPlainOutput.file(
          path: path,
          prefix: 'prefix_${id}_',
          postfix: '_postfix',
          ext: '.txt',
        );
        po.init();
        po.close();
        await Future<void>.delayed(Duration(milliseconds: 50));
        final file = await find(path, 'prefix_${id}_', '_postfix', '.txt');
        if (file != null) {
          final list = await file.readAsLines();
          expect(list, hasLength(0));
        } else {
          fail('file not found');
        }
      });

      test('when init, write and close then print messages', () async {
        final id = Uuid().v1();
        final path = Directory.systemTemp.path;
        final po = LogPlainOutput.file(
          path: path,
          prefix: 'prefix_${id}_',
          postfix: '_postfix',
          ext: '.txt',
        );
        po.init();
        po.write(['abc', 'def']);
        po.close();
        await Future<void>.delayed(Duration(milliseconds: 50));
        final file = await find(path, 'prefix_${id}_', '_postfix', '.txt');
        if (file != null) {
          final list = await file.readAsLines();
          expect(
            list,
            allOf(
              containsAllInOrder(<String>[
                'abc',
                'def',
              ]),
              hasLength(2),
            ),
          );
        } else {
          fail('file not found');
        }
      });

      test('when init, write multi and close then print messages', () async {
        final id = Uuid().v1();
        final path = Directory.systemTemp.path;
        final po = LogPlainOutput.file(
          path: path,
          prefix: 'prefix_${id}_',
          postfix: '_postfix',
          ext: '.txt',
        );
        po.init();
        po.write(['abc1', 'def1']);
        po.write(['abc2', 'def2']);
        po.write(['abc3', 'def3']);
        po.close();
        await Future<void>.delayed(Duration(milliseconds: 50));
        final file = await find(path, 'prefix_${id}_', '_postfix', '.txt');
        if (file != null) {
          final list = await file.readAsLines();
          expect(
            list,
            allOf(
              containsAllInOrder(<String>[
                'abc1',
                'def1',
                'abc2',
                'def2',
                'abc3',
                'def3',
              ]),
              hasLength(6),
            ),
          );
        } else {
          fail('file not found');
        }
      });

      test('given closed when write then throw', () {
        final id = Uuid().v1();
        final path = Directory.systemTemp.path;
        final po = LogPlainOutput.file(
          path: path,
          prefix: 'prefix_${id}_',
          postfix: '_postfix',
          ext: '.txt',
        );
        po.init();
        po.close();
        expect(
          () => po.write(['abc', 'def']),
          throwsA(isA<StateError>()),
        );
      });

      test('given closed when wait and write then throw', () async {
        final id = Uuid().v1();
        final path = Directory.systemTemp.path;
        final po = LogPlainOutput.file(
          path: path,
          prefix: 'prefix_${id}_',
          postfix: '_postfix',
          ext: '.txt',
        );
        po.init();
        po.close();
        await Future<void>.delayed(Duration(milliseconds: 50));
        expect(
          () => po.write(['abc', 'def']),
          throwsA(isA<StateError>()),
        );
      });

      test('given initialized when init then not throw', () {
        final id = Uuid().v1();
        final path = Directory.systemTemp.path;
        final po = LogPlainOutput.file(
          path: path,
          prefix: 'prefix_${id}_',
          postfix: '_postfix',
          ext: '.txt',
        );
        po.init();
        po.init();
      });

      test('given closed when close then not throw', () {
        final id = Uuid().v1();
        final path = Directory.systemTemp.path;
        final po = LogPlainOutput.file(
          path: path,
          prefix: 'prefix_${id}_',
          postfix: '_postfix',
          ext: '.txt',
        );
        po.init();
        po.close();
        po.close();
      });

      test('given closed when wait and close then not throw', () async {
        final id = Uuid().v1();
        final path = Directory.systemTemp.path;
        final po = LogPlainOutput.file(
          path: path,
          prefix: 'prefix_${id}_',
          postfix: '_postfix',
          ext: '.txt',
        );
        po.init();
        po.close();
        await Future<void>.delayed(Duration(milliseconds: 50));
        po.close();
      });

      test('checking default arguments part 1', () async {
        final id = Uuid().v1();
        final path = Directory.systemTemp.path;
        final po = LogPlainOutput.file(
          path: path,
          postfix: id,
        );
        po.init();
        po.close();
        await Future<void>.delayed(Duration(milliseconds: 50));
        final file = await find(path, 'log_', id, '.log');
        if (file != null) {
          final list = await file.readAsLines();
          expect(list, hasLength(0));
        } else {
          fail('file not found');
        }
      });

      test('checking default arguments part 2', () async {
        final id = Uuid().v1();
        final path = Directory.systemTemp.path;
        final po = LogPlainOutput.file(
          path: path,
          prefix: id,
        );
        po.init();
        po.close();
        await Future<void>.delayed(Duration(milliseconds: 50));
        final file = await find(path, id, '', '.log');
        if (file != null) {
          final list = await file.readAsLines();
          expect(list, hasLength(0));
        } else {
          fail('file not found');
        }
      });
    });
  });
}

Future<File?> find(
  String path,
  String prefix,
  String postfix,
  String ext,
) async {
  await for (final f in Directory(path).list()) {
    if (f is File) {
      final name = f.path.split(Platform.pathSeparator).last;
      if (name.startsWith(prefix) && name.endsWith('$postfix$ext')) {
        return f;
      }
    }
  }
  return null;
}
