// Copyright (c) 2016, Ben Sheron. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library physics.test;

import 'package:generic_vector_tools/generic_vector_tools.dart';
import 'package:physics/physics.dart';
import 'package:test/test.dart';

import 'test_gravity_classes.dart';

void main() {
  group('Gravity2d tests', () {
    V<GravityObject> three2dObjects = new V<GravityObject>
    ([new GravityObject2d(0.0, 0.0, 1.0),
      new GravityObject2d(10.0, 10.0, 2.0),
      new GravityObject2d(20.0, 20.0, 3.0)]);

    // setUp(() {
    //   awesome = new Awesome();
    // });

    test('Test Gravity2d setup', () {
      Gravity2d gravity = new Gravity2d(entities: three2dObjects);
      V<double> expectedMasses = new V([1.0, 2.0, 3.0]);
      V<V> expectedPositions = new V([new V([0.0, 0.0]), new V([10.0, 10.0]), new V([20.0, 20.0])]);

      _expectTrue(gravity.entities.length == 3);
      _expectTrue(gravity.g == 1.0);
      _expectTrue(gravity.entities is V<GravityObject>);
      _expectTrueForAllEntities(gravity, (e) => e.mass, expectedMasses);
      _expectTrueForAllEntities(gravity, (e) => e.position, expectedPositions);

    });
  });
}

void _expectTrueForAllEntities(Gravity2d gravity, Function f, V expectedValues){
  _expectTrue(gravity.entities.zip(expectedValues, (actual, expected) => f(actual) == expected).elements.every((e) => e));
}

void _expectTrue(bool b){
  expect(b, isTrue);
}
