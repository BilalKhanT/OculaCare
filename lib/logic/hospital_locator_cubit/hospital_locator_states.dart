import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../data/models/hospital_locator_model/hospital_bookmark_model.dart';
import '../../data/models/hospital_locator_model/hospital_model.dart';

abstract class HospitalState extends Equatable {
  @override
  List<Object> get props => [];
}

class HospitalLoading extends HospitalState {}

class HospitalError extends HospitalState {
  final String message;

  HospitalError(this.message);
}

class HospitalLoaded extends HospitalState {
  final List<Hospital> hospital;

  HospitalLoaded(this.hospital);
}

class HospitalNavigationStarted extends HospitalState {
  final List<LatLng> polylineCoordinates;

  HospitalNavigationStarted(this.polylineCoordinates);

  @override
  List<Object> get props => [polylineCoordinates];
}

class HospitalBookmarkLoaded extends HospitalState {
  final List<Bookmark> bookmarks;

  HospitalBookmarkLoaded(this.bookmarks);
}



