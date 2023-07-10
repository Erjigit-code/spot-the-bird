part of 'location_cubit.dart';

abstract class LocationState extends Equatable {
  const LocationState();
  @override
  List<Object> get props => [];
}

class LocationInitial extends LocationState {
  const LocationInitial();
}

class LocationLoadind extends LocationState {
  const LocationLoadind();
}

class LocationError extends LocationState {
  const LocationError();
}

class LocationLoaded extends LocationState {
  final double latitude;
  final double logtitude;
  const LocationLoaded({required this.latitude, required this.logtitude});
}
