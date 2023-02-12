// ignore_for_file: prefer_const_constructors

import 'package:test/test.dart';
import 'package:yuhsuan_sdk/src/yuhsuan_sdk.dart';

void main() {
  final sdk = MySdk();

  test('test diff', () {
    final o = [1, 3, 4];
    final n = [1, 2, 3];
    final diff = sdk.extractDiff(oldList: o, newList: n);
    print(diff);
  });
}
