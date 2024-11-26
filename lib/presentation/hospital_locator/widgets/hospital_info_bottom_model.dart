import 'package:cculacare/logic/hospital_locator_cubit/bookmark_icon_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../configs/presentation/constants/colors.dart';
import '../../../data/models/hospital_locator_model/hospital_model.dart';
import '../../../logic/hospital_locator_cubit/bookmark_icon_cubit.dart';
import '../../widgets/btn_flat.dart';

class HospitalInfoBottomSheet extends StatelessWidget {
  final Hospital hospital;
  final bool isBookmarked;
  final VoidCallback onPressed;

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
              Expanded(
                child: Column(
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
                      maxLines: 2, // Limit to 2 lines
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: height * 0.005),
                    Text(
                      hospital.businessStatus == "OPERATIONAL"
                          ? "Status: Open"
                          : "Status: Closed",
                      style: TextStyle(
                        fontSize: height * 0.02,
                        color: hospital.businessStatus == "OPERATIONAL"
                            ? AppColors.lightGreen
                            : AppColors.brightRed,
                        fontFamily: 'MontserratRegular',
                      ),
                    ),
                  ],
                ),
              ),
              BlocBuilder<BookmarkIconCubit, BookmarkIconState>(
                builder: (context, state) {
                  bool isBookmarked = false;
                  if (state is BookmarkIconFilled) {
                    isBookmarked = state.isBookmarked;
                  }
                  return IconButton(
                    icon: Icon(
                      isBookmarked ? Icons.bookmark : Icons.bookmark_outline,
                      color: isBookmarked ? AppColors.appColor : Colors.grey,
                      size: height * 0.03,
                    ),
                    onPressed: () {
                      context.read<BookmarkIconCubit>().toggleBookmark(hospital);
                    },
                  );
                },
              ),
            ],
          ),
          SizedBox(height: height * 0.02),

          // Hospital Details
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.location_on,
                      color: AppColors.brightRed, size: height * 0.03),
                  SizedBox(width: width * 0.02),
                  Expanded(
                    child: Text(
                      hospital.address,
                      style: TextStyle(
                        fontSize: height * 0.02,
                        color: AppColors.textGrey,
                        fontFamily: 'MontserratRegular',
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              SizedBox(height: height * 0.01),
              if (hospital.rating != null) ...[
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: height * 0.03),
                    SizedBox(width: width * 0.02),
                    Text(
                      "Rating: ${hospital.rating} (${hospital.userRatingsTotal ?? 0} reviews)",
                      style: TextStyle(
                        fontSize: height * 0.02,
                        color: AppColors.textGrey,
                        fontFamily: 'MontserratRegular',
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
          SizedBox(height: height * 0.06),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: ButtonFlat(
                  btnColor: AppColors.appColor,
                  textColor: AppColors.whiteColor,
                  onPress: onPressed,
                  text: "Navigate",
                ),
              ),
              SizedBox(width: width * 0.02),
              Expanded(
                child: ButtonFlat(
                  btnColor: Colors.grey[300]!,
                  textColor: Colors.black,
                  onPress: () {
                    Navigator.pop(context);
                  },
                  text: "Close",
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
