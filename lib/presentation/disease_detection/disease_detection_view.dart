import 'package:cculacare/logic/detection_animation/detection_animation_cubit.dart';
import 'package:cculacare/logic/detection_animation/detection_animation_state.dart';
import 'package:cculacare/presentation/disease_detection/widgets/cstm_detection_btn.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import '../../configs/global/app_globals.dart';
import '../../configs/presentation/constants/colors.dart';
import '../../configs/routes/route_names.dart';
import '../../data/repositories/local/preferences/shared_prefs.dart';
import '../../logic/detection/detection_cubit.dart';
import '../../logic/detection/question_cubit.dart';
import '../result/result_view.dart';
import '../widgets/need_to_setup_profile_widget.dart';

class DiseaseDetectionScreen extends StatelessWidget {
  const DiseaseDetectionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.sizeOf(context).height;
    double screenWidth = MediaQuery.sizeOf(context).width;
    context.read<DetectionCubit>().loadDiseaseResults();
    return Scaffold(
      backgroundColor: AppColors.screenBackground,
      appBar: AppBar(
        backgroundColor: AppColors.screenBackground,
        title: Text(
          'Diagnose',
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'MontserratMedium',
            fontWeight: FontWeight.w800,
            fontSize: screenWidth * 0.05,
          ),
        ),
      ),
      body: BlocBuilder<DetectionAnimationCubit, DetectionAnimationState>(
        builder: (context, state) {
          if (state is DetectionAnimationStateAnimate) {
            return SizedBox(
              height: screenHeight,
              width: screenWidth,
              child: SafeArea(
                child: SingleChildScrollView(
                  child: Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          height: 10.h,
                        ),
                        customDetectionBtnWidget(
                          title: 'Check Your Eyes',
                          icon: SvgPicture.asset(
                            'assets/svgs/eye_scan.svg',
                            // ignore: deprecated_member_use
                            color: Colors.white,
                          ),
                          text: "Take photos, diagnose\ndisease get care tips.",
                          screenWidth: screenWidth,
                          onTap: () {
                            if (sharedPrefs.isProfileSetup) {
                              isHome = false;
                              isMore = false;
                              context.read<QuestionCubit>().startQuestionnaire();
                              context.push(RouteNames.questionRoute);
                            } else {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return const Dialog(
                                      child: NeedToSetupProfileWidget());
                                },
                              );
                            }
                          },
                          screenHeight: screenHeight,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          'Diagnose History',
                          style: TextStyle(
                              fontFamily: 'MontserratMedium',
                              fontSize: screenWidth * 0.045,
                              color: AppColors.appColor,
                              fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          height: screenHeight * 0.5,
                          width: screenWidth,
                          child: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 0),
                            child: DiseaseResultView(),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}