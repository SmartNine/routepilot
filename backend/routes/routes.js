const express = require('express');
const router = express.Router();
const routeService = require('../services/routeService');

// Optimize route
router.post('/optimize', async (req, res, next) => {
  try {
    const { task_id, origin, destinations } = req.body;

    // Validation
    if (!origin || !destinations || !Array.isArray(destinations)) {
      return res.status(400).json({
        error: true,
        message: 'Invalid request: origin and destinations are required',
      });
    }

    if (destinations.length === 0) {
      return res.status(400).json({
        error: true,
        message: 'At least one destination is required',
      });
    }

    if (destinations.length > 20) {
      return res.status(400).json({
        error: true,
        message: 'Maximum 20 destinations allowed',
      });
    }

    // Process route optimization
    const optimizedTask = await routeService.optimizeRoute({
      task_id,
      origin,
      destinations,
    });

    res.json(optimizedTask);
  } catch (error) {
    next(error);
  }
});

// Get route history (mock for now)
router.get('/history', async (req, res, next) => {
  try {
    const limit = parseInt(req.query.limit) || 10;

    // Mock history data
    const history = [];
    res.json(history);
  } catch (error) {
    next(error);
  }
});

// Get specific route by ID (mock for now)
router.get('/:taskId', async (req, res, next) => {
  try {
    const { taskId } = req.params;

    // In production, retrieve from database
    res.status(404).json({
      error: true,
      message: 'Route not found',
    });
  } catch (error) {
    next(error);
  }
});

module.exports = router;
