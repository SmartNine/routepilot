import 'dart:io';
import 'package:url_launcher/url_launcher.dart';
import '../models/location.dart';
import '../config/app_config.dart';

class NavigationService {
  static Future<void> navigateToLocation(
    Location origin,
    Location destination,
  ) async {
    final url = _buildNavigationUrl(origin, destination);
    await _launchUrl(url);
  }

  static Future<void> navigateMultipleStops(
    Location origin,
    List<Location> destinations,
  ) async {
    if (destinations.isEmpty) return;

    final url = Platform.isIOS
        ? _buildAppleMapsUrl(origin, destinations)
        : _buildGoogleMapsUrl(origin, destinations);

    await _launchUrl(url);
  }

  static String _buildNavigationUrl(Location origin, Location destination) {
    if (Platform.isIOS) {
      return '${AppConfig.appleMapsBaseUrl}'
          '?saddr=${origin.lat},${origin.lng}'
          '&daddr=${destination.lat},${destination.lng}';
    } else {
      return '${AppConfig.googleMapsBaseUrl}'
          '${origin.lat},${origin.lng}/'
          '${destination.lat},${destination.lng}';
    }
  }

  static String _buildGoogleMapsUrl(
    Location origin,
    List<Location> destinations,
  ) {
    final waypoints = destinations
        .map((loc) => '${loc.lat},${loc.lng}')
        .join('/');
    return '${AppConfig.googleMapsBaseUrl}${origin.lat},${origin.lng}/$waypoints';
  }

  static String _buildAppleMapsUrl(
    Location origin,
    List<Location> destinations,
  ) {
    // Apple Maps has limited multi-stop support, navigate to first destination
    final first = destinations.first;
    return '${AppConfig.appleMapsBaseUrl}'
        '?saddr=${origin.lat},${origin.lng}'
        '&daddr=${first.lat},${first.lng}';
  }

  static Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch navigation app';
    }
  }
}
