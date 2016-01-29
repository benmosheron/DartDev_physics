import 'package:generic_vector_tools/generic_vector_tools.dart';
import 'package:physics/physics.dart';

/// Gravity object for unit tests
class GravityObject2d implements GravityObject{
  double mass;
  V<double> position = new V.zero(2);

  double get x => position[0];
  double get y => position[1];

  GravityObject2d(double x, double y, double m){
    position[0] = x;
    position[1] = y;
    mass = m;
  }
}