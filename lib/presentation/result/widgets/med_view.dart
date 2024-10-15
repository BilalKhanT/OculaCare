import 'package:animate_do/animate_do.dart';
import 'package:cculacare/logic/detection/med_cubit.dart';
import 'package:cculacare/logic/detection/med_state.dart';
import 'package:cculacare/presentation/result/widgets/duration_calendar.dart';
import 'package:cculacare/presentation/widgets/cstm_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../configs/presentation/constants/colors.dart';

class MedView extends StatelessWidget {
  final String disease;
  const MedView({super.key, required this.disease});

  @override
  Widget build(BuildContext context) {
    final int medIndex = disease == 'Cataracts Detected'
        ? 0
        : disease == 'Pterygium Detected'
            ? 1
            : disease == 'Uveitis Detected'
                ? 3
                : 2;
    double screenHeight = MediaQuery.sizeOf(context).height;
    double screenWidth = MediaQuery.sizeOf(context).width;
    return Scaffold(
      backgroundColor: AppColors.screenBackground,
      appBar: AppBar(
        backgroundColor: AppColors.screenBackground,
        title: Text(
          'Medicine Recommendations',
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'MontserratMedium',
            fontWeight: FontWeight.w800,
            fontSize: screenWidth * 0.04,
          ),
        ),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: AppColors.appColor,
            size: 25,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: BlocBuilder<MedCubit, MedState>(
          builder: (context, state) {
            if (state is MedToggled) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FadeInLeft(
                          duration: const Duration(milliseconds: 600),
                          child: IconButton(
                              onPressed: () {
                                if (state.subIndex > 0) {
                                  context.read<MedCubit>().emitToggled(
                                      medIndex, state.subIndex - 1);
                                } else {
                                  context
                                      .read<MedCubit>()
                                      .emitToggled(medIndex, state.subIndex);
                                }
                              },
                              icon: const Icon(
                                Icons.arrow_back_ios_new,
                                color: AppColors.appColor,
                                size: 30,
                              )),
                        ),
                        FadeInDown(
                          duration: const Duration(milliseconds: 600),
                          child: Image.asset(
                            state.medicines.image,
                            height: screenHeight * 0.25,
                          ),
                        ),
                        FadeInRight(
                          duration: const Duration(milliseconds: 600),
                          child: IconButton(
                              onPressed: () {
                                if (state.subIndex < 2) {
                                  context.read<MedCubit>().emitToggled(
                                      medIndex, state.subIndex + 1);
                                } else {
                                  context
                                      .read<MedCubit>()
                                      .emitToggled(medIndex, state.subIndex);
                                }
                              },
                              icon: const Icon(
                                Icons.arrow_forward_ios,
                                color: AppColors.appColor,
                                size: 30,
                              )),
                        ),
                      ],
                    ),
                  ),
                  Center(
                    child: Text(
                      state.medicines.name,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.appColor,
                        fontFamily: 'MontserratMedium',
                        fontWeight: FontWeight.w800,
                        fontSize: screenWidth * 0.045,
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Text(
                      '${state.medicines.usage}.',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Colors.grey.shade800,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w800,
                        fontSize: screenWidth * 0.035,
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Text(
                      'Dosage',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontFamily: 'MontserratMedium',
                        fontWeight: FontWeight.w800,
                        fontSize: screenWidth * 0.045,
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.015,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Container(
                      width: screenWidth,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: AppColors.appColor.withOpacity(0.5),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
                        child: Text(
                          '${state.medicines.dosage}.',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: Colors.grey.shade200,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w800,
                            fontSize: screenWidth * 0.035,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Text(
                      'Course of Treatment',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontFamily: 'MontserratMedium',
                        fontWeight: FontWeight.w800,
                        fontSize: screenWidth * 0.045,
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.015,),
                  Center(
                      child: FadeIn(
                        duration: const Duration(milliseconds: 600),
                        child: DurationCalendar(medicine: state.medicines),
                      )),
                ],
              );
            }
            else if (state is MedLoading) {
              return  Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: screenHeight * 0.3,),
                    const DotLoader(loaderColor: AppColors.appColor,),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
