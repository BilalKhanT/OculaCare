import 'package:camera/camera.dart';

abstract class UploadProfilePhotoState {}

class UploadProfilePhotoStateLoading extends UploadProfilePhotoState {}

class UploadProfilePhotoStateInitial extends UploadProfilePhotoState {}

class UploadProfilePhotoStateLoaded extends UploadProfilePhotoState {
  final XFile image;
  UploadProfilePhotoStateLoaded(this.image);
}

class UpdateProfilePhotoStateLoaded extends UploadProfilePhotoState {
  final String image;
  UpdateProfilePhotoStateLoaded(this.image);
}

class UploadProfilePhotoStateError extends UploadProfilePhotoState {
  final String message;

  UploadProfilePhotoStateError(this.message);
}
