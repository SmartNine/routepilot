import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/route_task.dart';
import '../models/location.dart';
import '../services/navigation_service.dart';

class MapScreen extends StatefulWidget {
  final RouteTask task;

  const MapScreen({super.key, required this.task});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};

  @override
  void initState() {
    super.initState();
    _createMarkers();
  }

  void _createMarkers() {
    final markers = <Marker>{};

    // Origin marker
    markers.add(
      Marker(
        markerId: const MarkerId('origin'),
        position: LatLng(widget.task.origin.lat, widget.task.origin.lng),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        infoWindow: InfoWindow(
          title: '起点',
          snippet: widget.task.origin.address,
        ),
      ),
    );

    // Destination markers
    final orderedDests = widget.task.orderedDestinations;
    for (var i = 0; i < orderedDests.length; i++) {
      final dest = orderedDests[i];
      markers.add(
        Marker(
          markerId: MarkerId('dest_$i'),
          position: LatLng(dest.lat, dest.lng),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          infoWindow: InfoWindow(
            title: '第 ${i + 1} 站',
            snippet: dest.address,
          ),
          onTap: () => _showNavigationDialog(dest),
        ),
      );
    }

    setState(() {
      _markers = markers;
    });
  }

  void _showNavigationDialog(Location destination) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('导航'),
        content: Text('前往: ${destination.address}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                await NavigationService.navigateToLocation(
                  widget.task.origin,
                  destination,
                );
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('无法打开导航: $e')),
                  );
                }
              }
            },
            child: const Text('开始导航'),
          ),
        ],
      ),
    );
  }

  LatLngBounds _calculateBounds() {
    double minLat = widget.task.origin.lat;
    double maxLat = widget.task.origin.lat;
    double minLng = widget.task.origin.lng;
    double maxLng = widget.task.origin.lng;

    for (final dest in widget.task.destinations) {
      minLat = minLat < dest.lat ? minLat : dest.lat;
      maxLat = maxLat > dest.lat ? maxLat : dest.lat;
      minLng = minLng < dest.lng ? minLng : dest.lng;
      maxLng = maxLng > dest.lng ? maxLng : dest.lng;
    }

    return LatLngBounds(
      southwest: LatLng(minLat - 0.01, minLng - 0.01),
      northeast: LatLng(maxLat + 0.01, maxLng + 0.01),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('路线地图'),
        actions: [
          IconButton(
            icon: const Icon(Icons.navigation),
            onPressed: () async {
              try {
                await NavigationService.navigateMultipleStops(
                  widget.task.origin,
                  widget.task.orderedDestinations,
                );
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('无法打开导航: $e')),
                  );
                }
              }
            },
            tooltip: '一键导航',
          ),
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(widget.task.origin.lat, widget.task.origin.lng),
          zoom: 12,
        ),
        markers: _markers,
        polylines: _polylines,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        mapType: MapType.normal,
        onMapCreated: (controller) {
          _mapController = controller;
          // Fit bounds to show all markers
          Future.delayed(const Duration(milliseconds: 500), () {
            _mapController?.animateCamera(
              CameraUpdate.newLatLngBounds(_calculateBounds(), 50),
            );
          });
        },
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildInfoItem(
                  Icons.place,
                  '${widget.task.destinations.length} 个目的地',
                ),
                _buildInfoItem(
                  Icons.route,
                  '${widget.task.totalDistanceKm?.toStringAsFixed(1) ?? '--'} km',
                ),
                _buildInfoItem(
                  Icons.access_time,
                  '${widget.task.totalTimeMin ?? '--'} 分钟',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.blue),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(fontWeight: FontWeight.w500)),
      ],
    );
  }
}
