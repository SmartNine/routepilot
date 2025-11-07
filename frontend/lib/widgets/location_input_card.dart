import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/route_provider.dart';
import '../models/location.dart';

class LocationInputCard extends ConsumerStatefulWidget {
  const LocationInputCard({super.key});

  @override
  ConsumerState<LocationInputCard> createState() => _LocationInputCardState();
}

class _LocationInputCardState extends ConsumerState<LocationInputCard> {
  final _originController = TextEditingController();
  final _destControllers = <TextEditingController>[];

  @override
  void dispose() {
    _originController.dispose();
    for (var controller in _destControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _addDestinationField() {
    setState(() {
      _destControllers.add(TextEditingController());
    });
  }

  void _removeDestinationField(int index) {
    setState(() {
      _destControllers[index].dispose();
      _destControllers.removeAt(index);
    });
    ref.read(locationInputProvider.notifier).removeDestination(index);
  }

  void _onOriginChanged(String value) {
    if (value.isNotEmpty) {
      // Mock location for demo - in production, use geocoding
      final location = Location(
        address: value,
        lat: 34.048 + (value.length * 0.001),
        lng: -118.257 + (value.length * 0.001),
      );
      ref.read(locationInputProvider.notifier).setOrigin(location);
    }
  }

  void _onDestinationChanged(int index, String value) {
    if (value.isNotEmpty) {
      // Mock location for demo - in production, use geocoding
      final location = Location(
        address: value,
        lat: 34.05 + (index * 0.01) + (value.length * 0.001),
        lng: -118.28 + (index * 0.01) + (value.length * 0.001),
      );

      final notifier = ref.read(locationInputProvider.notifier);
      if (index < ref.read(locationInputProvider).destinations.length) {
        notifier.updateDestination(index, location);
      } else {
        notifier.addDestination(location);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              '地址信息',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),

            // Origin Input
            TextField(
              controller: _originController,
              decoration: const InputDecoration(
                labelText: '起点',
                hintText: '输入起始地址',
                prefixIcon: Icon(Icons.my_location),
              ),
              onChanged: _onOriginChanged,
            ),
            const SizedBox(height: 16),

            // Destinations
            Text(
              '目的地 (${_destControllers.length})',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[700],
                  ),
            ),
            const SizedBox(height: 8),

            // Destination Fields
            ...List.generate(_destControllers.length, (index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _destControllers[index],
                        decoration: InputDecoration(
                          labelText: '目的地 ${index + 1}',
                          hintText: '输入送货地址',
                          prefixIcon: const Icon(Icons.place),
                        ),
                        onChanged: (value) => _onDestinationChanged(index, value),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.remove_circle),
                      color: Colors.red,
                      onPressed: () => _removeDestinationField(index),
                    ),
                  ],
                ),
              );
            }),

            // Add Destination Button
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: _addDestinationField,
              icon: const Icon(Icons.add),
              label: const Text('添加目的地'),
            ),
          ],
        ),
      ),
    );
  }
}
