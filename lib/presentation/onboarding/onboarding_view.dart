import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:OculaCare/configs/presentation/constants/colors.dart';
import 'package:OculaCare/configs/routes/route_names.dart';
import 'package:OculaCare/logic/sign_up_cubit/sign_up_cubit.dart';
import 'package:OculaCare/presentation/sign_up/widgets/cstm_flat_btn.dart';
import 'data_onboarding/content_model.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  int currentIndex = 0;
  late PageController _controller;

  @override
  void initState() {
    _controller = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.sizeOf(context).height;
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _controller,
              itemCount: contents.length,
              onPageChanged: (int index) {
                setState(() {
                  currentIndex = index;
                });
              },
              itemBuilder: (_, i) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(contents[i].image.toString()),
                      SizedBox(height: screenHeight * 0.05,),
                      Text(
                        contents[i].title.toString(),
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 30.sp,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.0,
                          color: AppColors.appColor,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.01),
                      Text(
                        contents[i].discription.toString(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: AppColors.textGrey,
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              contents.length,
                  (index) => buildDot(index, context),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 30.0),
            child: CustomFlatButton(
              onTap: () {
                if (currentIndex == contents.length - 1) {
                  context.read<SignUpCubit>().loadSignUpScreen();
                  context.push(RouteNames.signUpRoute);
                }
                _controller.nextPage(
                  duration: const Duration(milliseconds: 100),
                  curve: Curves.easeOutCirc,
                );
              },
              text: currentIndex == contents.length - 1 ? "Get Started" : "Next",
              btnColor: AppColors.appColor,
            ),
          ),
          // Container(
          //   height: 60,
          //   margin: const EdgeInsets.all(40),
          //   width: double.infinity,
          //   decoration: BoxDecoration(
          //     color: AppColors.appColor,
          //
          //   ),
          //   child: TextButton(
          //     onPressed: () {
          //       if (currentIndex == contents.length - 1) {
          //         context.read<SignUpCubit>().loadSignUpScreen();
          //         context.push(RouteNames.signUpRoute);
          //       }
          //       _controller.nextPage(
          //         duration: const Duration(milliseconds: 100),
          //         curve: Curves.easeOutCirc,
          //       );
          //     },
          //     child: Text(
          //         currentIndex == contents.length - 1 ? "Continue" : "Next"),
          //   ),
          // )
        ],
      ),
    );
  }

  Container buildDot(int index, BuildContext context) {
    return Container(
      height: 10,
      width: currentIndex == index ? 25 : 10,
      margin: const EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: AppColors.appColor,
      ),
    );
  }
}
