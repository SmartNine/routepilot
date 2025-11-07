import 'package:flutter/material.dart';
import '../models/route_task.dart';

class RouteResultCard extends StatelessWidget {
  final RouteTask task;

  const RouteResultCard({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final orderedDests = task.orderedDestinations;

    return Card(
      color: Colors.green[50],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.green, size: 32),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '路线优化完成',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      if (task.totalDistanceKm != null && task.totalTimeMin != null)
                        Text(
                          '总距离: ${task.totalDistanceKm!.toStringAsFixed(1)} km  ·  预计: ${task.totalTimeMin} 分钟',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.grey[700],
                              ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 24),

            // Origin
            _buildLocationItem(
              context,
              index: 0,
              title: '起点',
              address: task.origin.address,
              isOrigin: true,
            ),
            const SizedBox(height: 8),

            // Optimized destinations
            ...List.generate(orderedDests.length, (index) {
              final dest = orderedDests[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _buildLocationItem(
                  context,
                  index: index + 1,
                  title: '第 ${index + 1} 站',
                  address: dest.address,
                  notes: dest.notes,
                ),
              );
            }),

            // Summary
            if (task.totalDistanceKm != null)
              Container(
                margin: const EdgeInsets.only(top: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildSummaryItem(
                      Icons.route,
                      '总里程',
                      '${task.totalDistanceKm!.toStringAsFixed(1)} km',
                    ),
                    Container(width: 1, height: 40, color: Colors.grey[300]),
                    _buildSummaryItem(
                      Icons.access_time,
                      '预计时间',
                      '${task.totalTimeMin} 分钟',
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationItem(
    BuildContext context, {
    required int index,
    required String title,
    required String address,
    String? notes,
    bool isOrigin = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: isOrigin ? Colors.green : Colors.blue,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              isOrigin ? 'A' : '$index',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              Text(
                address,
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 13,
                ),
              ),
              if (notes != null)
                Text(
                  notes,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryItem(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, color: Colors.blue, size: 24),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
