import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/location.dart';
import '../models/route_task.dart';
import '../services/api_service.dart';

final apiServiceProvider = Provider((ref) => ApiService());

final routeTaskProvider = StateNotifierProvider<RouteTaskNotifier, AsyncValue<RouteTask?>>((ref) {
  return RouteTaskNotifier(ref.read(apiServiceProvider));
});

class RouteTaskNotifier extends StateNotifier<AsyncValue<RouteTask?>> {
  final ApiService _apiService;

  RouteTaskNotifier(this._apiService) : super(const AsyncValue.data(null));

  Future<void> optimizeRoute(Location origin, List<Location> destinations) async {
    state = const AsyncValue.loading();

    try {
      final task = RouteTask(
        taskId: const Uuid().v4(),
        origin: origin,
        destinations: destinations,
      );

      final optimizedTask = await _apiService.optimizeRoute(task);
      state = AsyncValue.data(optimizedTask);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  void clearRoute() {
    state = const AsyncValue.data(null);
  }
}

// Provider for managing input locations
final locationInputProvider = StateNotifierProvider<LocationInputNotifier, LocationInputState>((ref) {
  return LocationInputNotifier();
});

class LocationInputState {
  final Location? origin;
  final List<Location> destinations;

  LocationInputState({
    this.origin,
    this.destinations = const [],
  });

  LocationInputState copyWith({
    Location? origin,
    List<Location>? destinations,
  }) {
    return LocationInputState(
      origin: origin ?? this.origin,
      destinations: destinations ?? this.destinations,
    );
  }

  bool get isValid => origin != null && destinations.isNotEmpty;
}

class LocationInputNotifier extends StateNotifier<LocationInputState> {
  LocationInputNotifier() : super(LocationInputState());

  void setOrigin(Location location) {
    state = state.copyWith(origin: location);
  }

  void addDestination(Location location) {
    state = state.copyWith(
      destinations: [...state.destinations, location],
    );
  }

  void removeDestination(int index) {
    final newDestinations = List<Location>.from(state.destinations);
    newDestinations.removeAt(index);
    state = state.copyWith(destinations: newDestinations);
  }

  void updateDestination(int index, Location location) {
    final newDestinations = List<Location>.from(state.destinations);
    newDestinations[index] = location;
    state = state.copyWith(destinations: newDestinations);
  }

  void clearAll() {
    state = LocationInputState();
  }
}
