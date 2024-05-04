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