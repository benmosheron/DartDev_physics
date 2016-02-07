library physics.test_gravity_2d;

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
      Gravity2d gravity = new Gravity2d();
      _expectTrue(gravity.g == 1.0);
    });

    test('Test massProductMatrix', () {
      Gravity2d gravity = new Gravity2d();
      M expectedMasses = new M.fromArray(3, 3, [
        1.0, 2.0, 3.0, // m0*m0, m0*m1, m0*m2
        2.0, 4.0, 6.0, // ...
        3.0, 6.0, 9.0
      ]); // m2*m0, m2*m1, m2*m2
      _expectTrue(gravity.calculateMassProduct(three2dObjects) == expectedMasses);
    });

    test('Test distance', () {
      Gravity2d gravity = new Gravity2d();
      M expectedDistances = new M.fromArray(3, 3, [
        two0s, two1s * 10.0, two1s * 20.0, // p0->p0, p0->p1, p0->p2
        two1s * -10.0, two0s, two1s * 10.0, // ...
        two1s * -20.0, two1s * -10.0, two0s
      ]); // p2->p0, p2->p1, p2->p2
      _expectTrue(gravity.calculateDistance(three2dObjects) == expectedDistances);
    });

    test('Test direction', () {
      Gravity2d gravity = new Gravity2d();
      // Expected components are either 0 or ec, given that all positions are diagonal from each other
      double ec = 0.7071067811865475;
      V<double> twoEcs = new V.all(2, ec);
      M expectedDirections = new M.fromArray(3, 3, [
        two0s, twoEcs, twoEcs, // p0->p0, p0->p1, p0->p2
        twoEcs.negate(), two0s, twoEcs, // ...
        twoEcs.negate(), twoEcs.negate(), two0s
      ]); // p2->p0, p2->p1, p2->p2
      _expectTrue(gravity.calculateDirection(gravity.calculateDistance(three2dObjects)) == expectedDirections);
    });

    test('Test dealWithZeros', () {
      Gravity2d gravity = new Gravity2d();
      M expectedSafeDistances = new M.fromArray(2, 2, [1.0, 1.0, 1.0, 1.0,]);
      M safeDistances = gravity.dealWithZeros(gravity.calculateDistanceMagnitude(gravity.calculateDistance(twoSimple2dObjects)));
      _expectTrue(safeDistances == expectedSafeDistances);
    });

    test('Test distance^2   ', () {
      Gravity2d gravity = new Gravity2d();
      M dSquaredWithZeros = gravity.calculateDistanceMagnitude(gravity.calculateDistance(twoSimple2dObjects))
          .elementWiseMultiply(gravity.calculateDistanceMagnitude(gravity.calculateDistance(twoSimple2dObjects)));
      M safeDistances = gravity.dealWithZeros(gravity.calculateDistanceMagnitude(gravity.calculateDistance(twoSimple2dObjects)));
      M dSquared = safeDistances.elementWiseMultiply(safeDistances);
      // Just running without exception is enough for now
      _expectTrue(dSquaredWithZeros is M);
      _expectTrue(dSquared is M);
    });

    test('Test calulateForce 2 objects', () {
      // Two objects with mass 1.0
      // the second object is 1.0 units to the right
      // default g = 1.0

      Gravity2d gravity = new Gravity2d();
      // Expect force from first to second = 1.0 to the right
      // Expect force from second to first = -1.0 to the right
      // All others should be 0

      M expectedForce =
          new M.fromArray(2, 2, [two0s, oneZero, oneZero.negate(), two0s]);
      _expectTrue(gravity.calculateForce(twoSimple2dObjects) == expectedForce);
    });

    test('Test calulateForce massless objects', () {
      // Two objects with mass 1.0
      // the second object is 1.0 units to the right
      // default g = 1.0

      Gravity2d gravity = new Gravity2d();
      // Expect force from first to second = 1.0 to the right
      // Expect force from second to first = -1.0 to the right
      // All others should be 0

      M expectedForce = new M.fromArray(2, 2, [two0s, two0s, two0s, two0s]);
      _expectTrue(gravity.calculateForce(new V<GravityObject>([
      new GravityObject2d(0.0, 0.0, 0.0),
      new GravityObject2d(1.0, 0.0, 1.0)
      ])) == expectedForce);
    });

    test('Test calulateForce throws on null', () {
      Gravity2d gravity = new Gravity2d();
      expect(() => gravity.calculateForce(null), throws);
    });
  });
}

void _expectTrue(bool b) {
  expect(b, isTrue);
}
