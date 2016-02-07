library physics.integration;

import 'package:generic_vector_tools/generic_vector_tools.dart';

import 'force_calculator.dart';
import 'force_object.dart';
// import 'gravity_2d.dart';

enum IntegrationMethod{
  Euler
}

/// Handles integration
class Integration{

  /// Timestep of integration
  double dt;

  /// Object which calculates matrix of forces
  final ForceCalculator calculator;

  // Constructors

  /// Create a new integration instance. 
  Integration(this.dt, this.calculator);
  
  /// Updates the positions (TODO velocities and accelerations) of the entities
  void Integrate(V<ForceObject> entities){
    // M F = calculator.calculateForce(entities);

    // Apply forces
    entities.mapF((ForceObject e) => e.position += 1.0);
  }
}