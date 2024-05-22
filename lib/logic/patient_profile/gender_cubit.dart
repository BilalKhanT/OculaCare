import 'package:OculaCare/logic/patient_profile/patient_profile_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GenderCubit extends Cubit<String> {
  GenderCubit() : super('male');

  void selectGender(String gender, BuildContext context) {
    context.read<PatientProfileCubit>().setGender(gender);
    emit(gender);
  }

  setGender(String gender) {
    emit(gender);
  }
}
