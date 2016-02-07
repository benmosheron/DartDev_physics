library physics.test;

import 'package:generic_vector_tools/generic_vector_tools.dart';
import 'package:physics/physics.dart';
import 'package:test/test.dart';

import 'test_gravity_classes.dart';

void run() {
  group('Gravity2d tests', () {
    V<GravityObject> three2dObjects = new V<GravityObject>([
      new GravityObject2d(0.0, 0.0, 1.0),
      new GravityObject2d(10.0, 10.0, 2.0),
      new GravityObject2d(20.0, 20.0, 3.0)
    ]);
    V<GravityObject> twoSimple2dObjects = new V<GravityObject>([
      new GravityObject2d(0.0, 0.0, 1.0),
      new GravityObject2d(1.0, 0.0, 1.0)
    ]);
    final V<double> two1s = new V<double>([1.0, 1.0]);
    final V<double> two0s = new V<double>([0.0, 0.0]);
    final V<double> oneZero = new V<double>([1.0, 0.0]);

    test('Test Gravity2d setup', () {
      Gravity2d gravity = new Gravity2d(entities: three2dObjects);
      V<double> expectedMasses = new V([1.0, 2.0, 3.0]);
      V<V> expectedPositions = new V([
        new V([0.0, 0.0]),
        new V([10.0, 10.0]),
        new V([20.0, 20.0])
      ]);

      _expectTrue(gravity.entities.length == 3);
      _expectTrue(gravity.g == 1.0);
      _expectTrue(gravity.entities is V<GravityObject>);
      _expectTrueForAllEntities(gravity, (e) => e.mass, expectedMasses);
      _expectTrueForAllEntities(gravity, (e) => e.position, expectedPositions);
    });

    test('Test massProductMatrix', () {
      Gravity2d gravity = new Gravity2d(entities: three2dObjects);
      M expectedMasses = new M.fromArray(3, 3, [
        1.0, 2.0, 3.0, // m0*m0, m0*m1, m0*m2
        2.0, 4.0, 6.0, // ...
        3.0, 6.0, 9.0
      ]); // m2*m0, m2*m1, m2*m2
      _expectTrue(gravity.massProduct == expectedMasses);
    });

    test('Test distance', () {
      Gravity2d gravity = new Gravity2d(entities: three2dObjects);
      M expectedDistances = new M.fromArray(3, 3, [
        two0s, two1s * 10.0, two1s * 20.0, // p0->p0, p0->p1, p0->p2
        two1s * -10.0, two0s, two1s * 10.0, // ...
        two1s * -20.0, two1s * -10.0, two0s
      ]); // p2->p0, p2->p1, p2->p2
      _expectTrue(gravity.distance == expectedDistances);
    });

    test('Test direction', () {
      Gravity2d gravity = new Gravity2d(entities: three2dObjects);
      // Expected components are either 0 or ec, given that all positions are diagonal from each other
      double ec = 0.7071067811865475;
      V<double> twoEcs = new V.all(2, ec);
      M expectedDirections = new M.fromArray(3, 3, [
        two0s, twoEcs, twoEcs, // p0->p0, p0->p1, p0->p2
        twoEcs.negate(), two0s, twoEcs, // ...
        twoEcs.negate(), twoEcs.negate(), two0s
      ]); // p2->p0, p2->p1, p2->p2
      _expectTrue(gravity.direction == expectedDirections);
    });

    test('Test dealWithZeros', () {
      Gravity2d gravity = new Gravity2d(entities: twoSimple2dObjects);
      M expectedSafeDistances = new M.fromArray(2, 2, [1.0, 1.0, 1.0, 1.0,]);
      M safeDistances = gravity.dealWithZeros(gravity.distanceMagnitude);
      _expectTrue(safeDistances == expectedSafeDistances);
    });

    test('Test distance^2   ', () {
      Gravity2d gravity = new Gravity2d(entities: twoSimple2dObjects);
      M dSquaredWithZeros = gravity.distanceMagnitude
          .elementWiseMultiply(gravity.distanceMagnitude);
      M safeDistances = gravity.dealWithZeros(gravity.distanceMagnitude);
      M dSquared = safeDistances.elementWiseMultiply(safeDistances);
      // Just running without exception is enough for now
      _expectTrue(dSquaredWithZeros is M);
      _expectTrue(dSquared is M);
    });

    test('Test calulateForce 2 objects', () {
      // Two objects with mass 1.0
      // the second object is 1.0 units to the right
      // default g = 1.0

      Gravity2d gravity = new Gravity2d(entities: twoSimple2dObjects);
      // Expect force from first to second = 1.0 to the right
      // Expect force from second to first = -1.0 to the right
      // All others should be 0

      M expectedForce =
          new M.fromArray(2, 2, [two0s, oneZero, oneZero.negate(), two0s]);
      _expectTrue(gravity.calculateForce() == expectedForce);
    });

    test('Test calulateForce massless objects', () {
      // Two objects with mass 1.0
      // the second object is 1.0 units to the right
      // default g = 1.0

      Gravity2d gravity = new Gravity2d(entities: twoSimple2dObjects);
      gravity.entities[0].mass = 0.0;
      // Expect force from first to second = 1.0 to the right
      // Expect force from second to first = -1.0 to the right
      // All others should be 0

      M expectedForce = new M.fromArray(2, 2, [two0s, two0s, two0s, two0s]);
      _expectTrue(gravity.calculateForce() == expectedForce);
    });
  });
}

void _expectTrueForAllEntities(
    Gravity2d gravity, Function f, V expectedValues) {
  _expectTrue(gravity.entities
      .zip(expectedValues, (actual, expected) => f(actual) == expected)
      .elements
      .every((e) => e));
}

void _expectTrue(bool b) {
  expect(b, isTrue);
}
