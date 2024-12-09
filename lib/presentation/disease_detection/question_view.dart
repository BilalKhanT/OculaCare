import 'package:cculacare/configs/extension/extensions.dart';
import 'package:cculacare/presentation/widgets/cstm_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import '../../configs/presentation/constants/colors.dart';
import '../../logic/detection/question_cubit.dart';
import '../../logic/detection/question_state.dart';

class QuestionScreen extends StatelessWidget {
  const QuestionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();
    FocusNode node = FocusNode();
    double screenHeight = MediaQuery.sizeOf(context).height;
    double screenWidth = MediaQuery.sizeOf(context).width;
    return Scaffold(
      backgroundColor: AppColors.screenBackground,
      appBar: AppBar(
        backgroundColor: AppColors.screenBackground,
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: const Icon(
            Icons.arrow_back_ios_new_outlined,
            color: AppColors.appColor,
          ),
        ),
        title: Text(
          'Symptoms Assessment',
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'MontserratMedium',
            fontWeight: FontWeight.w800,
            fontSize: screenWidth * 0.05,
          ),
        ),
      ),
      body: BlocBuilder<QuestionCubit, QuestionState>(
        builder: (context, state) {
          if (state is QuestionLoading) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  DotLoader(loaderColor: AppColors.appColor),
                ],
              ),
            );
          }
          else if (state is QuestionLoaded) {
            context.read<QuestionCubit>().startSpeaking(state.question);
            return Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08, vertical: screenHeight * 0.015),
                            child: Text(state.question,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w800,
                              fontSize: screenWidth * 0.035,
                            ),),
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.03,),
                        Lottie.asset(
                          'assets/lotties/robot.json',
                          height: screenHeight * 0.25,
                          width: screenHeight * 0.25,
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(30.r),
                            child: TextFormField(
                              controller: controller,
                              focusNode: node,
                              cursorColor: AppColors.appColor,
                              style: context.appTheme.textTheme.labelMedium?.copyWith(
                                  color: AppColors.secondaryText,
                                  fontSize: MediaQuery.sizeOf(context).width * 0.04),
                              decoration: InputDecoration(
                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.send),
                                  onPressed: () {
                                    final String answer = controller.text;
                                    controller.clear();
                                    context.read<QuestionCubit>().nextQuestion(answer);
                                  },
                                  color: AppColors.appColor,
                                ),
                                fillColor: Colors.grey.shade300,
                                filled: true,
                                hintStyle: context.appTheme.textTheme.labelMedium?.copyWith(
                                    color: Colors.grey.shade400,
                                    fontSize: MediaQuery.sizeOf(context).width * 0.04),
                                hintText: 'Type Yes or No',
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.only(
                                  top: MediaQuery.sizeOf(context).height * 0.015,
                                  left: 20.w,
                                  bottom: MediaQuery.sizeOf(context).height * 0.015,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          } else if (state is QuestionFinished) {
            context.read<QuestionCubit>().completeCheck(context, state.result.diagnosis!);
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Lottie.asset(
                    'assets/lotties/robot.json',
                    height: screenHeight * 0.3,
                    width: screenHeight * 0.3,
                  ),
                ],
              ),
            );
          } else {
            return const Center(child: Text('Something went wrong!'));
          }
        },
      ),
    );
  }
}
