import 'package:OculaCare/logic/patient_profile/upload_profile_photo_state.dart';
import 'package:bloc/bloc.dart';
import 'package:image_picker/image_picker.dart';

class UploadProfilePhotoCubit extends Cubit<UploadProfilePhotoState> {
  UploadProfilePhotoCubit() : super(UploadProfilePhotoStateInitial());

  XFile? image;

  uploadPhoto() async {
    emit(UploadProfilePhotoStateLoading());
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      image = pickedFile;
      emit(UploadProfilePhotoStateLoaded(pickedFile));
    }
    else {
      emit(UploadProfilePhotoStateError('Ops, something went wrong'));
    }
  }
}