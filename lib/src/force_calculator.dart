library physics.force_calculator;

import 'package:generic_vector_tools/generic_vector_tools.dart';

import 'force_object.dart';

/// Abstract class that defines an object which calculates forces or interactions between a vector of objects.
abstract class ForceCalculator {
  /// Calculate matrix of forces acting on an internal list of entities.
  /// Matrix is of the form:
  /// { f(e0, e0)  f(e0, e1)  f(e0, e2)}
  /// { f(e1, e0)  f(e1, e1)  f(e1, e2)}
  /// { f(e2, e0)  f(e2, e1)  f(e2, e2)}
  /// where e.g. f(e0, e1) is the force acting on e0 as a result of e1
  M calculateForce(V<ForceObject> entities);
}
