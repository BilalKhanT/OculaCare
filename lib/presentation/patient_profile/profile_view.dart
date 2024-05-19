import 'package:OculaCare/configs/presentation/constants/colors.dart';
import 'package:OculaCare/logic/patient_profile/patient_profile_cubit.dart';
import 'package:OculaCare/logic/patient_profile/patient_profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PatientProfileScreen extends StatelessWidget {
  const PatientProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<PatientProfileCubit, PatientProfileState> (
        builder: (context, state) {
          if (state is PatientProfileStateLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.appColor,),
            );
          }
          else if (state is PatientProfileStateSetUp) {
            return SizedBox.shrink();
          }
          else if (state is PatientProfileStateLoaded) {
            return SizedBox.shrink();
          }
          else if (state is PatientProfileStateFailure) {
            return Center(
              child: Text(state.errorMsg,),
            );
          }
          else {
            return const SizedBox.shrink();
          }
        }
      )
    );
  }
}
