import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:harmony_log/harmony_log.dart';

void main() {
  group('LogPlainOutput', () {
    group('console', () {
      late LogPlainOutput po;

      setUp(() {
        po = LogPlainOutput.console();
      });

      test('init', () {
        var pr = <String>[];
        runZoned(
          () {
            po.init();
          },
          zoneSpecification: ZoneSpecification(
            print: (self, parent, zone, line) {
              pr.add(line);
            },
          ),
        );
        expect(pr, isEmpty);
      });

      test('write', () {
        final list = ['abc', 'def'];
        var pr = <String>[];
        runZoned(
          () {
            po.write(list);
          },
          zoneSpecification: ZoneSpecification(
            print: (self, parent, zone, line) {
              pr.add(line);
            },
          ),
        );
        expect(pr, containsAllInOrder(list));
      });

      test('close', () {
        var pr = <String>[];
        runZoned(
          () {
            po.close();
          },
          zoneSpecification: ZoneSpecification(
            print: (self, parent, zone, line) {
              pr.add(line);
            },
          ),
        );
        expect(pr, isEmpty);
      });
    });
  });
}
