class AppConfig {
  // API Configuration
  static const String apiBaseUrl = 'http://localhost:3000/api';
  
  // Google Maps API Key (Replace with your own)
  static const String googleMapsApiKey = 'YOUR_GOOGLE_MAPS_API_KEY';
  
  // App Settings
  static const int maxDestinations = 20;
  static const int defaultZoomLevel = 12;
  
  // Cache Settings
  static const Duration cacheExpiration = Duration(hours: 24);
  
  // Navigation URLs
  static const String googleMapsBaseUrl = 'https://www.google.com/maps/dir/';
  static const String appleMapsBaseUrl = 'http://maps.apple.com/';
}
