library physics.integration;

import 'package:generic_vector_tools/generic_vector_tools.dart';

import 'force_calculator.dart';
import 'force_object.dart';

enum IntegrationMethod{
  Euler
}

/// Handles integration
class Integration{

  /// Timestep of integration
  double dt;

  /// Object which calculates matrix of forces
  final ForceCalculator calculator;

  //--------------//
  // Constructors //
  //--------------//
  
  /// Create a new integration instance. 
  Integration(this.dt, this.calculator);
  
  //---------//
  // Methods //
  //---------//

  /// Updates the positions, velocities and acceleration of the entities
  void integrate(V<ForceObject> entities){
    M F = calculator.calculateForce(entities);

    V sumForces = new V(F.rows.map((V row) => row.sum()));

    // Euler integration
    // a = F / m;

    V mass = entities.mapF((e) => e.mass);

    V a = sumForces.elementWiseDivide(mass);

    // Set acceleration, velocity and position
    for(int i = 0; i < entities.length; i++){
      entities[i].acceleration = a[i];
      entities[i].velocity += entities[i].acceleration * dt;
      entities[i].position += entities[i].velocity * dt;
    }
  }
}