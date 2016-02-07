library physics.gravity_object;

import 'package:generic_vector_tools/generic_vector_tools.dart';

import 'force_object.dart';

/// Abstract class that defines an object on which gravity calculations can be performed.
abstract class GravityObject implements ForceObject{
  /// Mass of the object.
  double mass;

  /// Position of object
  V<double> position;

  /// Velocity of object
  V<double> velocity;

  /// Acceleration of object
  V<double> acceleration;
}
