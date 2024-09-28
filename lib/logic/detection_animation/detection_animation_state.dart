import 'package:equatable/equatable.dart';

abstract class DetectionAnimationState extends Equatable {
  @override
  List<Object> get props => [];
}

class DetectionAnimationStateInitial extends DetectionAnimationState {}

class DetectionAnimationStateAnimate extends DetectionAnimationState {}
