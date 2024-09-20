import 'dart:convert';
import 'dart:io';
import 'package:OculaCare/logic/patient_profile/patient_profile_cubit.dart';
import 'package:OculaCare/logic/patient_profile/upload_profile_photo_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class UploadProfilePhotoCubit extends Cubit<UploadProfilePhotoState> {
  UploadProfilePhotoCubit() : super(UploadProfilePhotoStateInitial());

  XFile? image;

  void dispose() {
    image = null;
  }

  uploadPhoto(BuildContext context) async {
    emit(UploadProfilePhotoStateLoading());
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      image = pickedFile;
      final base64Image = base64Encode(await File(pickedFile.path).readAsBytes());
      context.read<PatientProfileCubit>().setImage(base64Image);
      emit(UploadProfilePhotoStateLoaded(pickedFile));
    }
    else {
      emit(UploadProfilePhotoStateError('Ops, something went wrong'));
    }
  }

  Future<String> changeProfilePhoto() async{
    emit(UploadProfilePhotoStateLoading());
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      image = pickedFile;
      final base64Image = base64Encode(await File(pickedFile.path).readAsBytes());
      emit(UpdateProfilePhotoStateLoaded(base64Image));
      return base64Image;
    }
    else {
      emit(UploadProfilePhotoStateError('Ops, something went wrong'));
      return '';
    }
  }
}