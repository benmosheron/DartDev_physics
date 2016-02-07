library physics.test_integration;

import 'package:generic_vector_tools/generic_vector_tools.dart';
import 'package:physics/physics.dart';
import 'package:test/test.dart';

import 'test_gravity_classes.dart';

void run() {
  group('Integration tests', () {
    Gravity2d g = new Gravity2d();

    test('Test integration setup', () {
        V<GravityObject> objects = new V<GravityObject>([
          new GravityObject2d(0.0, 0.0, 1.0),
          new GravityObject2d(1.0, 0.0, 1.0)
          ]);
        Integration i = new Integration(1.0, g);
        i.integrate(objects);
        // Expect objects to have begun accelerating towards each other,
        // they will have effectively switched places after 1 timestep with dt = 1 and G = 1
        expect(objects[0].acceleration == new V([1.0, 0.0]), true);
        expect(objects[0].velocity == new V([1.0, 0.0]), true);
        expect(objects[0].position == new V([1.0, 0.0]), true);
        expect(objects[1].acceleration == new V([-1.0, 0.0]), true);
        expect(objects[1].velocity == new V([-1.0, 0.0]), true);
        expect(objects[1].position == new V([0.0, 0.0]), true);
      });

  });
}

