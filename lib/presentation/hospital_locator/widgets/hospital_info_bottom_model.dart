import 'package:cculacare/logic/hospital_locator_cubit/bookmark_icon_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../configs/presentation/constants/colors.dart';
import '../../../data/models/hospital_locator_model/hospital_model.dart';
import '../../../logic/hospital_locator_cubit/bookmark_icon_cubit.dart';


class HospitalInfoBottomSheet extends StatelessWidget {
  final Hospital hospital;
  final bool isBookmarked;
  final VoidCallback onPressed;
  final VoidCallback onStart;

  const HospitalInfoBottomSheet({
    Key? key,
    required this.hospital,
    required this.isBookmarked,
    required this.onPressed,
    required this.onStart,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    List<String> imagePaths = [
      "assets/images/hospitals/hospital1.jpg",
      "assets/images/hospitals/hospital2.jpg",
      "assets/images/hospitals/hospital3.jpg",
      "assets/images/hospitals/hospital4.jpg",
    ];

    return Container(
      height: height * 0.95,
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
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                height: height * 0.004,
                width: width * 0.1,
              decoration: BoxDecoration(
              color: AppColors.textGrey,
              borderRadius: const BorderRadius.all(Radius.circular(25)),
            )
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: height * 0.05,
                  width: width * 0.07,
                ),
                SizedBox(
                  height: height * 0.05,
                  width: width * 0.22,
                  child: GestureDetector(
                    onTap: (){
                      context.pop();
                    },
                    child: const Icon(Icons.cancel, color: AppColors.textSecondary, size: 44,),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        hospital.name,
                        style: TextStyle(
                          fontSize: height * 0.022,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                          fontFamily: 'MontserratMedium',
                        ),
                        maxLines: 3, // Limit to 2 lines
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left
                      ),
                      SizedBox(height: height * 0.005),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(hospital.userRatingsTotal.toString(),
                            style: TextStyle(
                                   fontSize: height * 0.018,
                                   color: AppColors.textPrimary,
                                   fontFamily: 'MontserratRegular',
                                ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: List.generate(
                              5,
                                  (index) => Icon(
                                Icons.star,
                                color: index <= hospital.rating!.round() ? AppColors.orange : AppColors.secondaryText,
                                size: 28,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: height * 0.012),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        hospital.address,
                        style: TextStyle(
                          fontSize: height * 0.02,
                          color: AppColors.textGrey,
                          fontFamily: 'MontserratRegular',
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: height * 0.01),
                Text(
                  hospital.businessStatus == "OPERATIONAL" ? "Open" : "Closed",
                  style: TextStyle(
                    fontSize: height * 0.02,
                    color: hospital.businessStatus == "OPERATIONAL" ? AppColors.contentColorGreen : AppColors.brightRed  ,
                    fontFamily: 'MontserratRegular',
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            SizedBox(height: height * 0.01,),
            Row(
              children: [
                Container(
                  height: height * 0.05,
                  width: width * 0.26,
                  decoration: BoxDecoration(
                    color: AppColors.screenBackground,
                    borderRadius: const BorderRadius.all(Radius.circular(100)),
                    border: Border.all(
                      color: Colors.blue,
                      width: 2.0,
                    ),
                  ),
                  child: Center(
                    child: InkWell(
                      onTap: onPressed,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.directions, color: Colors.blue, size: height * 0.02,),
                            SizedBox(width: width * 0.01,),
                            Text("Directions",
                              style: TextStyle(
                                fontSize: height * 0.013,
                                color: AppColors.textPrimary,
                                fontFamily: 'MontserratRegular',
                              ),
                            ),
                          ],
                        )
                    ),
                  ),
                ),
                SizedBox(width: width * 0.02),
                Container(
                  height: height * 0.05,
                  width: width * 0.26,
                  decoration: BoxDecoration(
                    color: AppColors.screenBackground,
                    borderRadius: const BorderRadius.all(Radius.circular(100)),
                    border: Border.all(
                      color: Colors.blue,
                      width: 2.0,
                    ),
                  ),
                  child: Center(
                    child: InkWell(
                        onTap: onStart,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.directions, color: Colors.blue, size: height * 0.02,),
                            SizedBox(width: width * 0.01,),
                            Text("Start",
                              style: TextStyle(
                                fontSize: height * 0.013,
                                color: AppColors.textPrimary,
                                fontFamily: 'MontserratRegular',
                              ),
                            ),
                          ],
                        )
                    ),
                  ),
                ),
                SizedBox(width: width * 0.02),
                Container(
                  height: height * 0.05,
                  width: width * 0.26,
                  decoration: BoxDecoration(
                    color: AppColors.screenBackground,
                    borderRadius: const BorderRadius.all(Radius.circular(100)),
                    border: Border.all(
                      color: Colors.blue,
                      width: 2.0,
                    ),
                  ),
                  child: BlocBuilder<BookmarkIconCubit, BookmarkIconState>(
                    builder: (context, state) {
                      bool isBookmarked = false;
                      if (state is BookmarkIconFilled) {
                        isBookmarked = state.isBookmarked;
                      }
                      return InkWell(
                          onTap: (){
                            context.read<BookmarkIconCubit>().toggleBookmark(hospital);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(isBookmarked ? Icons.bookmark : Icons.bookmark_outline,
                                color: isBookmarked ? Colors.blue : Colors.grey,
                                size: height * 0.02,),
                              SizedBox(width: width * 0.01,),
                              Text(isBookmarked ? "Remove" : "Save",
                                style: TextStyle(
                                  fontSize: height * 0.013,
                                  color: AppColors.textPrimary,
                                  fontFamily: 'MontserratRegular',
                                ),
                              ),
                            ],
                          )
                      );
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: height * 0.01,),
            SizedBox(
              height: height * 0.2,
              width: width,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: imagePaths.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: height * 0.01,
                      horizontal: width * 0.02,
                    ),
                    child: SizedBox(
                      width: width * 0.7, // Ensure items have proper width
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          imagePaths[index],
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
        
        
          ],
        ),
      ),
    );
  }
}
