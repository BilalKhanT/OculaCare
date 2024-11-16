import 'package:flutter/material.dart';
import 'package:cculacare/configs/presentation/constants/colors.dart';
import 'package:cculacare/presentation/widgets/btn_flat.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../data/models/hospital_locator_model/hospital_bookmark_model.dart';
import '../../../data/models/hospital_locator_model/hospital_model.dart';
import '../../../data/repositories/local/preferences/shared_prefs.dart';
import '../../../logic/hospital_locator_cubit/hospital_locator_cubit.dart';

class HospitalInfoBottomSheet extends StatelessWidget {
  final Hospital hospital;
  final bool isBookmarked;
  final VoidCallback onPressed; // Add this parameter

  const HospitalInfoBottomSheet({
    Key? key,
    required this.hospital,
    required this.isBookmarked,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return Container(
      height: height * 0.45,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.whiteColor, AppColors.bg],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
        boxShadow: [
          BoxShadow(
            color: AppColors.textGrey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hospital.name,
                    style: TextStyle(
                      fontSize: height * 0.025,
                      fontWeight: FontWeight.w700,
                      color: AppColors.appColor,
                      fontFamily: 'MontserratMedium',
                    ),
                  ),
                  SizedBox(height: height * 0.005),
                  Text(
                    "Eye Specialist • ★ 4.5",
                    style: TextStyle(
                      fontSize: height * 0.02,
                      color: AppColors.textGrey,
                      fontFamily: 'MontserratRegular',
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: SvgPicture.asset(
                  isBookmarked ? 'assets/svgs/bookmark_filled.svg' : 'assets/svgs/bookmark_outlined.svg',
                  height: height * 0.03,
                  width: height * 0.03,
                  color: isBookmarked ? AppColors.appColor : Colors.blue,
                ),
                onPressed: () {
                  if (isBookmarked) {
                    print("delete");
                  } else {
                    context.read<HospitalCubit>().addBookmark(hospital);
                  }
                },
              )

            ],
          ),
          SizedBox(height: height * 0.02),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.location_on, color: AppColors.brightRed, size: height * 0.03),
                  SizedBox(width: width * 0.02),
                  Text(
                    "${hospital.distance} m away",
                    style: TextStyle(
                      fontSize: height * 0.02,
                      color: AppColors.textGrey,
                      fontFamily: 'MontserratRegular',
                    ),
                  ),
                ],
              ),
              SizedBox(height: height * 0.01),
              Row(
                children: [
                  Icon(Icons.access_time, color: AppColors.lightGreen, size: height * 0.03),
                  SizedBox(width: width * 0.02),
                  Text(
                    "Open: 9:00 AM - 6:00 PM",
                    style: TextStyle(
                      fontSize: height * 0.02,
                      color: AppColors.textGrey,
                      fontFamily: 'MontserratRegular',
                    ),
                  ),
                ],
              ),
              SizedBox(height: height * 0.01),
              Row(
                children: [
                  Icon(Icons.local_hospital, color: AppColors.purple, size: height * 0.03),
                  SizedBox(width: width * 0.02),
                  Text(
                    "Emergency Services Available",
                    style: TextStyle(
                      fontSize: height * 0.02,
                      color: AppColors.textGrey,
                      fontFamily: 'MontserratRegular',
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: height * 0.02),

          // Action buttons
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: ButtonFlat(
                btnColor: AppColors.appColor,
                textColor: AppColors.whiteColor,
                onPress: onPressed, // Use the onPressed callback here
                text: "Start Navigation",
              ),
            ),
          ),
          SizedBox(width: width * 0.02),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: ButtonFlat(
                btnColor: Colors.grey[300]!,
                textColor: Colors.black,
                onPress: () {
                  Navigator.pop(context);
                },
                text: "Close",

              ),
            ),
          ),
        ],
      ),
    );
  }
}
