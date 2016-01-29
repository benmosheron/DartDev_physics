import 'dart:math';

import 'package:generic_vector_tools/generic_vector_tools.dart';

import 'gravity_object.dart';

/// 2D gravity simulation
class Gravity2d{

  /// Constant of gravitation
  double g;

  V<GravityObject> entities;

  /// Initialise gravity with a strength and a list of entities.
  Gravity2d({double g: 1.0, V<GravityObject> entities}){
    this.g = 1.0;
    this.entities = entities;
  }
}