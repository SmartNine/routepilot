const { v4: uuidv4 } = require('uuid');
const tspSolver = require('../utils/tspSolver');
const googleMapsService = require('./googleMapsService');

class RouteService {
  async optimizeRoute(task) {
    const taskId = task.task_id || uuidv4();
    const { origin, destinations } = task;

    try {
      // Step 1: Get distance matrix
      // In production, use Google Distance Matrix API
      // For now, use Euclidean distance as approximation
      const distanceMatrix = this.calculateDistanceMatrix(origin, destinations);

      // Step 2: Solve TSP to find optimal order
      const optimizedOrder = tspSolver.solve(distanceMatrix);

      // Step 3: Calculate total distance and time
      const { totalDistance, totalTime } = this.calculateTotals(
        origin,
        destinations,
        optimizedOrder,
        distanceMatrix
      );

      return {
        task_id: taskId,
        origin,
        destinations,
        optimized_order: optimizedOrder,
        total_distance_km: parseFloat(totalDistance.toFixed(2)),
        total_time_min: Math.round(totalTime),
        created_at: new Date().toISOString(),
      };
    } catch (error) {
      console.error('Route optimization error:', error);
      throw new Error('Failed to optimize route: ' + error.message);
    }
  }

  calculateDistanceMatrix(origin, destinations) {
    // Create matrix including origin
    const allPoints = [origin, ...destinations];
    const n = allPoints.length;
    const matrix = Array(n).fill(0).map(() => Array(n).fill(0));

    for (let i = 0; i < n; i++) {
      for (let j = 0; j < n; j++) {
        if (i !== j) {
          matrix[i][j] = this.haversineDistance(
            allPoints[i].lat,
            allPoints[i].lng,
            allPoints[j].lat,
            allPoints[j].lng
          );
        }
      }
    }

    return matrix;
  }

  haversineDistance(lat1, lon1, lat2, lon2) {
    const R = 6371; // Earth radius in km
    const dLat = this.toRadians(lat2 - lat1);
    const dLon = this.toRadians(lon2 - lon1);

    const a =
      Math.sin(dLat / 2) * Math.sin(dLat / 2) +
      Math.cos(this.toRadians(lat1)) *
        Math.cos(this.toRadians(lat2)) *
        Math.sin(dLon / 2) *
        Math.sin(dLon / 2);

    const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
    return R * c;
  }

  toRadians(degrees) {
    return degrees * (Math.PI / 180);
  }

  calculateTotals(origin, destinations, optimizedOrder, distanceMatrix) {
    let totalDistance = 0;

    // Distance from origin to first destination
    if (optimizedOrder.length > 0) {
      totalDistance += distanceMatrix[0][optimizedOrder[0] + 1];
    }

    // Distance between destinations
    for (let i = 0; i < optimizedOrder.length - 1; i++) {
      const from = optimizedOrder[i] + 1;
      const to = optimizedOrder[i + 1] + 1;
      totalDistance += distanceMatrix[from][to];
    }

    // Estimate time (assuming average speed of 40 km/h in city)
    const avgSpeedKmh = 40;
    const totalTime = (totalDistance / avgSpeedKmh) * 60; // Convert to minutes

    return { totalDistance, totalTime };
  }
}

module.exports = new RouteService();
