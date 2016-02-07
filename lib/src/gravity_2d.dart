library physics.gravity_2d;

import 'package:generic_vector_tools/generic_vector_tools.dart';

import 'force_calculator.dart';
import 'gravity_object.dart';


/// 2D gravity simulation (note: nothing limits this to 2d)
class Gravity2d implements ForceCalculator{
  /// Constant of gravitation.
  double g;

  /// Initialise gravity with a strength and a list of entities.
  Gravity2d({double g: 1.0}) {
    this.g = 1.0;
  }

  /// Matrix of product of each entity's mass with every other entity's mass
  M calculateMassProduct(V<GravityObject> entities) =>
      new M.fromV(entities.resolve(entities, (e1, e2) => e1.mass * e2.mass));

  /// Matrix of vectors between positions of all entities
  M calculateDistance(V<GravityObject> entities) => new M.fromV(
      entities.resolve(entities, (e1, e2) => e2.position - e1.position));

  /// Matrix of magnitudes of vectors between positions of all entities
  // M calculateDistanceMagnitude(V<GravityObject> entities) => calculateDistance(entities).mapF((e) => e.magnitude);
  M calculateDistanceMagnitude(M distances) => distances.mapF((e) => e.magnitude);

  /// Matrix of normalised vectors between positions of all entities
  M calculateDirection(M distances) => distances.mapF((e) => e.unit);

  /// ForceCalculator implementation, sets internal list of entities and performs calculation
  /// If entities is null or empty, calculation will proceed using the internal list of entities.
  M calculateForce(V<GravityObject> entities) {
    // Strength of gravitational force
    // F = G*M1*M2 / Distance^2

    // More specifically
    // Magnitude of force is given by:
    // (massProductMatrix / distanceMagnitudeMatrix^2) * g
    // Which acts along the directions in directionMatrix
    M distances = calculateDistance(entities);

    // We must deal with zero distances before dividing by them
    M safeDistances = dealWithZeros(calculateDistanceMagnitude(distances));

    M dSquared = safeDistances.elementWiseMultiply(safeDistances);

    M F_magnitude = calculateMassProduct(entities).elementWiseDivide(dSquared) * g;

    /// Zeros in the direction matrix will nullify any force introduced by
    /// removing zeros from distances
    M F = calculateDirection(distances).elementWiseMultiply(F_magnitude);

    return F;
  }

  /// Deal with zeros in the distance matrix. Default behaviour will change from (0, 0) to (1, 1)
  /// Returns a new matrix.
  M dealWithZeros(M distances) {
    return distances.mapF((e) => replaceZeroWithOne(e));
  }

  double replaceZeroWithOne(double x) {
    if (x == 0.0) return 1.0;
    return x;
  }
}
