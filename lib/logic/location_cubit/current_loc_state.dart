import 'package:equatable/equatable.dart';

import '../../data/models/address/address_model.dart';

abstract class CurrentLocationState extends Equatable {
  const CurrentLocationState();

  @override
  List<Object?> get props => [];
}

class CurrentLocationInitial extends CurrentLocationState {}

class CurrentLocationLoading extends CurrentLocationState {}

class CurrentLocationLoaded extends CurrentLocationSet {
  final Address currentAddress;

  CurrentLocationLoaded(this.currentAddress);

  @override
  List<Object?> get props => [currentAddress];
}

class CurrentLocationSet extends CurrentLocationState {}

class CurrentLocationError extends CurrentLocationState {}
