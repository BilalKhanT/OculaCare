import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class LocationState extends Equatable {
  @override
  List<Object> get props => [];
}

class LocationInitial extends LocationState {}

class LocationLoading extends LocationState {}

class LocationLoaded extends LocationState {
  final LatLng position;
  final String address;

  LocationLoaded(this.position, this.address);

  @override
  List<Object> get props => [address, position];
}

class LocationSet extends LocationState {
  final LatLng initialPosition;
  final Set<Marker> markers;
  final String address;
  final double latitude;
  final double longitude;

  LocationSet(this.initialPosition, this.markers, this.address, this.latitude,
      this.longitude);

  @override
  List<Object> get props => [initialPosition, markers, address];
}

class LocationError extends LocationState {
  final String message;

  LocationError(this.message);
}
