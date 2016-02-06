//import 'dart:math';

import 'package:generic_vector_tools/generic_vector_tools.dart';

import 'gravity_object.dart';

/// 2D gravity simulation
class Gravity2d{

  /// Constant of gravitation
  double g;

  V<GravityObject> entities;

  /// Initialise gravity with a strength and a list of entities.
  Gravity2d({double g: 1.0, V<GravityObject> entities}){
    if(entities == null || entities.length < 1)
      throw new Exception("Empty or null entity list");
    this.g = 1.0;
    this.entities = entities;
  }

  /// Matrix of product of each entity's mass with every other entity's mass
  M get massProductMatrix => new M.fromV(entities.resolve(entities, (e1, e2) => e1.mass * e2.mass));

  /// Matrix of vectors between positions of all entities
  M get distanceMatrix => new M.fromV(entities.resolve(entities, (e1, e2) => e2.position - e1.position));

  /// Matrix of magnitudes of vectors between positions of all entities
  M get distanceMagnitudeMatrix => distanceMatrix.mapF((e) => e.magnitude);

  /// Matrix of normalised vectors between positions of all entities
  M get directionMatrix => distanceMatrix.mapF((e) => e.unit);
  
  M calculateForce(){
    // Strength of gravitational force
    // F = G*M1*M2 / Distance^2

    // More specifically
    // Magnitude of force is given by:
    // (massProductMatrix / distanceMagnitudeMatrix^2) * g
    // Which acts along the directions in directionMatrix
    return directionMatrix;


    // V m = new V(E.map((e) => e.mass).toList());

    // // The square mass terms on diagonals will be cancelled by zero direction vectors later
    // M Mass = m * m;

    // V<V2> p = new V<V2>(E.map((e) => e.p).toList());

    // // We can resolve the positions into a matrix of vectors from p_i -> p_j
    // // by the power of functional programming!

    // M D = p.Resolve(p, (p1, p2) => p2 - p1);

    // // From this we can easily map the distances and normalised directions
    // M DistanceSquared = D.MapF((V2 e) => e.Magnitude * e.Magnitude); // Watch out for zero diagonals here, we will divide by this!
    // M Direction = D.MapF((V2 e) => e.Unit);

    // // Before we divide by DistanceSquared, we should take care of the diagonal zeros, they are irrelevant so we can make them 1.
    // for(int i = 0; i<D.nRows; i++) DistanceSquared[i][i] = 1.0;
    // // We should also check for entities in the exact same place (dont generate an infinite force).
    // DistanceSquared.MapF((e) => e == 0.0 ? 1.0 : e);

    // // We can now calculate a matrix of gravitational force between all entitities
    // M Magnitude = Mass.ElementWiseDivide(DistanceSquared) * Constants.G;
    // // And apply the magnitude along the directions
    // M F = Direction.ElementWiseMultiply(Magnitude);
  }
}