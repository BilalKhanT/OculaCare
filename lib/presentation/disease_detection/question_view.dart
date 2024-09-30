import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../configs/presentation/constants/colors.dart';
import '../../configs/routes/route_names.dart';
import '../../logic/detection/question_cubit.dart';
import '../../logic/detection/question_state.dart';
import '../../logic/image_capture/img_capture_cubit.dart';

class QuestionScreen extends StatelessWidget {
  const QuestionScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
          if (state is QuestionLoaded) {
            final question = state.questions[state.currentQuestionIndex];
            return Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    question.questionText,
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'MontserratMedium',
                      fontWeight: FontWeight.w800,
                      fontSize: screenWidth * 0.05,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.03),
                  SizedBox(
                    height: screenHeight * 0.6,
                    child: ListView.builder(
                      itemCount: question.options.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 20.0),
                          child: GestureDetector(
                            onTap: () {
                              context
                                  .read<QuestionCubit>()
                                  .selectOption(question.options[index]);
                            },
                            child: Container(
                              width: screenWidth,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: AppColors.appColor,
                              ),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 17.0),
                                  child: Text(
                                    question.options[index],
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'MontserratMedium',
                                      fontWeight: FontWeight.w800,
                                      fontSize: screenWidth * 0.04,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          } else if (state is QuestionFinished) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    state.result,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      context.read<ImageCaptureCubit>().initializeCamera();
                      context.go(RouteNames.imgCaptureRoute);
                    },
                    child: const Text('Continue'),
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
