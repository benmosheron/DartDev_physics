import 'package:generic_vector_tools/generic_vector_tools.dart';

/// Abstract class that defines an object on which gravity calculations can be performed.
abstract class GravityObject {
  /// Mass of the object.
  double mass;

  /// Position of object
  V<double> position;
}
