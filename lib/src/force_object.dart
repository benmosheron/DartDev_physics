library physics.force_object;

import 'package:generic_vector_tools/generic_vector_tools.dart';

/// Abstract class that defines an object on which force calculations can be performed.
abstract class ForceObject {
  /// Position of object
  V<double> position;

  /// Velocity of object
  V<double> velocity;

  /// Acceleration of object
  V<double> acceleration;
}
