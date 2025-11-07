import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/route_provider.dart';
import '../widgets/location_input_card.dart';
import '../widgets/route_result_card.dart';
import 'map_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locationInput = ref.watch(locationInputProvider);
    final routeTask = ref.watch(routeTaskProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('RoutePilot'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              // TODO: Navigate to history screen
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('历史记录功能开发中')),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Welcome Card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '路线优化助手',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '输入起点和目的地，智能规划最优配送路线',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[600],
                            ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Location Input Card
              const LocationInputCard(),
              const SizedBox(height: 16),

              // Optimize Button
              if (locationInput.isValid)
                ElevatedButton.icon(
                  onPressed: routeTask.isLoading
                      ? null
                      : () {
                          ref.read(routeTaskProvider.notifier).optimizeRoute(
                                locationInput.origin!,
                                locationInput.destinations,
                              );
                        },
                  icon: routeTask.isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.route),
                  label: Text(routeTask.isLoading ? '计算中...' : '生成最优路线'),
                ),
              const SizedBox(height: 16),

              // Route Result
              routeTask.when(
                data: (task) {
                  if (task == null) return const SizedBox.shrink();
                  return Column(
                    children: [
                      RouteResultCard(task: task),
                      const SizedBox(height: 16),
                      OutlinedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MapScreen(task: task),
                            ),
                          );
                        },
                        icon: const Icon(Icons.map),
                        label: const Text('在地图上查看'),
                      ),
                    ],
                  );
                },
                loading: () => const SizedBox.shrink(),
                error: (error, stack) => Card(
                  color: Colors.red[50],
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        const Icon(Icons.error_outline, color: Colors.red, size: 48),
                        const SizedBox(height: 8),
                        Text(
                          '路线优化失败',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          error.toString(),
                          style: const TextStyle(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
