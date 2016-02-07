library physics.test_integration;

import 'package:generic_vector_tools/generic_vector_tools.dart';
import 'package:physics/physics.dart';
import 'package:test/test.dart';

import 'test_gravity_classes.dart';

void run() {
  group('Integration tests', () {

    final V<GravityObject> three2dObjects = new V<GravityObject>([
      new GravityObject2d(0.0, 0.0, 1.0),
      new GravityObject2d(10.0, 10.0, 2.0),
      new GravityObject2d(20.0, 20.0, 3.0)
    ]);

    Gravity2d g = new Gravity2d();

    test('Test integration setup', () {
       Integration i = new Integration(1.0, g);

       print (three2dObjects[0].position[0]);
       i.Integrate(three2dObjects);
       print (three2dObjects[0].position[0]);
      });
  });
}

