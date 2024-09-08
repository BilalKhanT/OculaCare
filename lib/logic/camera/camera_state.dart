import 'package:camera/camera.dart';
import 'package:equatable/equatable.dart';

sealed class CameraState extends Equatable {
  const CameraState();

  @override
  List<Object?> get props => [];
}

class CameraInitial extends CameraState {}

class CameraSuccess extends CameraState {}

class CameraLoading extends CameraState {}

class CameraLoaded extends CameraState {
  final CameraController camera;
  final String state;

  const CameraLoaded(this.camera, this.state);

  @override
  List<Object?> get props => [camera];
}

class CameraError extends CameraState {
  final String error;

  const CameraError(this.error);

  @override
  List<Object?> get props => [error];
}
