import 'package:equatable/equatable.dart';

abstract class AnimalTrackScoreState extends Equatable {
  const AnimalTrackScoreState();

  @override
  List<Object?> get props => [];
}

class AnimalTrackScoreInitial extends AnimalTrackScoreState {}

class AnimalTrackScoreLoaded extends AnimalTrackScoreState {}
