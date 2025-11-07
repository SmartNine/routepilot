const axios = require('axios');

class GoogleMapsService {
  constructor() {
    this.apiKey = process.env.GOOGLE_MAPS_API_KEY;
    this.baseUrl = 'https://maps.googleapis.com/maps/api';
  }

  /**
   * Geocode an address to lat/lng
   */
  async geocode(address) {
    if (!this.apiKey) {
      throw new Error('Google Maps API key not configured');
    }

    try {
      const response = await axios.get(`${this.baseUrl}/geocode/json`, {
        params: {
          address,
          key: this.apiKey,
        },
      });

      if (response.data.status === 'OK' && response.data.results.length > 0) {
        const location = response.data.results[0].geometry.location;
        return {
          lat: location.lat,
          lng: location.lng,
          formatted_address: response.data.results[0].formatted_address,
        };
      }

      throw new Error(`Geocoding failed: ${response.data.status}`);
    } catch (error) {
      console.error('Geocoding error:', error.message);
      throw error;
    }
  }

  /**
   * Get distance matrix between multiple locations
   */
  async getDistanceMatrix(origins, destinations) {
    if (!this.apiKey) {
      throw new Error('Google Maps API key not configured');
    }

    try {
      const originsStr = origins.map(o => `${o.lat},${o.lng}`).join('|');
      const destinationsStr = destinations.map(d => `${d.lat},${d.lng}`).join('|');

      const response = await axios.get(`${this.baseUrl}/distancematrix/json`, {
        params: {
          origins: originsStr,
          destinations: destinationsStr,
          key: this.apiKey,
          mode: 'driving',
        },
      });

      if (response.data.status === 'OK') {
        return this.parseDistanceMatrix(response.data);
      }

      throw new Error(`Distance Matrix API failed: ${response.data.status}`);
    } catch (error) {
      console.error('Distance Matrix error:', error.message);
      throw error;
    }
  }

  parseDistanceMatrix(data) {
    const matrix = [];
    
    for (const row of data.rows) {
      const distances = [];
      for (const element of row.elements) {
        if (element.status === 'OK') {
          distances.push({
            distance_km: element.distance.value / 1000, // Convert meters to km
            duration_min: Math.round(element.duration.value / 60), // Convert seconds to minutes
          });
        } else {
          distances.push(null);
        }
      }
      matrix.push(distances);
    }

    return matrix;
  }
}

module.exports = new GoogleMapsService();
