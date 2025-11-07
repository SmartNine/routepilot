import 'location.dart';

class RouteTask {
  final String taskId;
  final Location origin;
  final List<Location> destinations;
  final List<int>? optimizedOrder;
  final double? totalDistanceKm;
  final int? totalTimeMin;
  final DateTime createdAt;

  RouteTask({
    required this.taskId,
    required this.origin,
    required this.destinations,
    this.optimizedOrder,
    this.totalDistanceKm,
    this.totalTimeMin,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory RouteTask.fromJson(Map<String, dynamic> json) {
    return RouteTask(
      taskId: json['task_id'] as String,
      origin: Location.fromJson(json['origin'] as Map<String, dynamic>),
      destinations: (json['destinations'] as List)
          .map((e) => Location.fromJson(e as Map<String, dynamic>))
          .toList(),
      optimizedOrder: json['optimized_order'] != null
          ? List<int>.from(json['optimized_order'] as List)
          : null,
      totalDistanceKm: json['total_distance_km'] != null
          ? (json['total_distance_km'] as num).toDouble()
          : null,
      totalTimeMin: json['total_time_min'] as int?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'task_id': taskId,
      'origin': origin.toJson(),
      'destinations': destinations.map((e) => e.toJson()).toList(),
      if (optimizedOrder != null) 'optimized_order': optimizedOrder,
      if (totalDistanceKm != null) 'total_distance_km': totalDistanceKm,
      if (totalTimeMin != null) 'total_time_min': totalTimeMin,
      'created_at': createdAt.toIso8601String(),
    };
  }

  RouteTask copyWith({
    String? taskId,
    Location? origin,
    List<Location>? destinations,
    List<int>? optimizedOrder,
    double? totalDistanceKm,
    int? totalTimeMin,
  }) {
    return RouteTask(
      taskId: taskId ?? this.taskId,
      origin: origin ?? this.origin,
      destinations: destinations ?? this.destinations,
      optimizedOrder: optimizedOrder ?? this.optimizedOrder,
      totalDistanceKm: totalDistanceKm ?? this.totalDistanceKm,
      totalTimeMin: totalTimeMin ?? this.totalTimeMin,
      createdAt: createdAt,
    );
  }

  List<Location> get orderedDestinations {
    if (optimizedOrder == null) return destinations;
    return optimizedOrder!.map((index) => destinations[index]).toList();
  }
}
