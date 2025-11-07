/**
 * TSP Solver using Greedy + 2-opt heuristic
 * Suitable for up to 20-30 destinations
 */

class TSPSolver {
  /**
   * Solve TSP problem
   * @param {number[][]} distanceMatrix - Distance matrix where [0] is origin
   * @returns {number[]} Optimized order of destinations (0-indexed, excluding origin)
   */
  solve(distanceMatrix) {
    if (distanceMatrix.length <= 1) {
      return [];
    }

    // Step 1: Greedy initial solution
    let tour = this.greedyTour(distanceMatrix);

    // Step 2: Improve with 2-opt
    tour = this.twoOptImprovement(distanceMatrix, tour);

    // Convert back to destination indices (excluding origin at index 0)
    return tour.slice(1).map(i => i - 1);
  }

  greedyTour(matrix) {
    const n = matrix.length;
    const visited = new Array(n).fill(false);
    const tour = [0]; // Start from origin
    visited[0] = true;

    let current = 0;
    
    // Greedy: always go to nearest unvisited location
    for (let i = 1; i < n; i++) {
      let nearest = -1;
      let minDist = Infinity;

      for (let j = 0; j < n; j++) {
        if (!visited[j] && matrix[current][j] < minDist) {
          minDist = matrix[current][j];
          nearest = j;
        }
      }

      if (nearest !== -1) {
        tour.push(nearest);
        visited[nearest] = true;
        current = nearest;
      }
    }

    return tour;
  }

  twoOptImprovement(matrix, tour, maxIterations = 1000) {
    let improved = true;
    let iteration = 0;
    let bestTour = [...tour];
    let bestDistance = this.calculateTourDistance(matrix, bestTour);

    while (improved && iteration < maxIterations) {
      improved = false;
      iteration++;

      // Try all possible 2-opt swaps
      for (let i = 1; i < tour.length - 1; i++) {
        for (let j = i + 1; j < tour.length; j++) {
          // Create new tour by reversing segment [i, j]
          const newTour = this.twoOptSwap(bestTour, i, j);
          const newDistance = this.calculateTourDistance(matrix, newTour);

          if (newDistance < bestDistance) {
            bestTour = newTour;
            bestDistance = newDistance;
            improved = true;
          }
        }
      }
    }

    return bestTour;
  }

  twoOptSwap(tour, i, j) {
    const newTour = [
      ...tour.slice(0, i),
      ...tour.slice(i, j + 1).reverse(),
      ...tour.slice(j + 1),
    ];
    return newTour;
  }

  calculateTourDistance(matrix, tour) {
    let distance = 0;
    for (let i = 0; i < tour.length - 1; i++) {
      distance += matrix[tour[i]][tour[i + 1]];
    }
    return distance;
  }
}

module.exports = new TSPSolver();
