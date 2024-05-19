import 'package:OculaCare/configs/presentation/constants/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GenderRow extends StatefulWidget {
  const GenderRow({Key? key}) : super(key: key);

  @override
  _GenderRowState createState() => _GenderRowState();
}

class _GenderRowState extends State<GenderRow> {
  String _selectedGender = 'male';

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Radio<String>(
          activeColor: AppColors.appColor,
          value: 'male',
          groupValue: _selectedGender,
          onChanged: (value) {
            setState(() => _selectedGender = value!);
          },
        ),
        Text('Male',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
            fontSize: 18.sp,
          ),),
        SizedBox(width: 10.w,),
        Radio<String>(
          activeColor: AppColors.appColor,
          value: 'female',
          groupValue: _selectedGender,
          onChanged: (value) {
            setState(() => _selectedGender = value!);
          },
        ),
        Text('Female',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
            fontSize: 18.sp,
          ),),
        SizedBox(width: 10.w,),
        Radio<String>(
          activeColor: AppColors.appColor,
          value: 'other',
          groupValue: _selectedGender,
          onChanged: (value) {
            setState(() => _selectedGender = value!);
          },
        ),
        Text('Other',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
            fontSize: 18.sp,
          ),),
      ],
    );
  }
}