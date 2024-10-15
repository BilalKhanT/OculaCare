import 'package:equatable/equatable.dart';

abstract class CurrentLocationState extends Equatable {
  const CurrentLocationState();

  @override
  List<Object?> get props => [];
}

class CurrentLocationInitial extends CurrentLocationState {}

class CurrentLocationLoading extends CurrentLocationState {}

class CurrentLocationSet extends CurrentLocationState {}

class CurrentLocationError extends CurrentLocationState {}
