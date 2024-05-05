import 'package:camera/camera.dart';
import 'package:equatable/equatable.dart';

abstract class ImageCaptureState extends Equatable {
  @override
  List<Object> get props => [];
}

class ImageCaptureStateInitial extends ImageCaptureState {}

class ImageCaptureStateLoading extends ImageCaptureState {}

class ImageCaptureStateLoaded extends ImageCaptureState {
  final bool disable;
  final int status;

  ImageCaptureStateLoaded(this.disable, this.status);
}

class ImageCaptureStateFailure extends ImageCaptureState {
  final String message;

  ImageCaptureStateFailure(this.message);
}

class ImagesCropped extends ImageCaptureState {
  final XFile leftEye;
  final XFile rightEye;
  final bool leftOpen;
  final bool rightOpen;

  ImagesCropped(this.leftEye, this.rightEye, this.leftOpen, this.rightOpen);
}