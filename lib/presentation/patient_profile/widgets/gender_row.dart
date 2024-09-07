import 'package:OculaCare/configs/presentation/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../logic/patient_profile/gender_cubit.dart';

class GenderRow extends StatelessWidget {
  const GenderRow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GenderCubit, String?>(
      builder: (context, selectedGender) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Radio<String>(
              activeColor: AppColors.appColor,
              value: 'Male',
              groupValue: selectedGender,
              onChanged: (value) =>
                  context.read<GenderCubit>().selectGender(value!, context),
            ),
            Text('Male',
                style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    fontSize: 18.sp)),
            SizedBox(width: 10.w),
            Radio<String>(
              activeColor: AppColors.appColor,
              value: 'Female',
              groupValue: selectedGender,
              onChanged: (value) =>
                  context.read<GenderCubit>().selectGender(value!, context),
            ),
            Text('Female',
                style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    fontSize: 18.sp)),
            SizedBox(width: 10.w),
            Radio<String>(
              activeColor: AppColors.appColor,
              value: 'Other',
              groupValue: selectedGender,
              onChanged: (value) =>
                  context.read<GenderCubit>().selectGender(value!, context),
            ),
            Text('Other',
                style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    fontSize: 18.sp)),
          ],
        );
      },
    );
  }
}
