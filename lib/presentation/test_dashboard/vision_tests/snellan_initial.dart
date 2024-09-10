import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../configs/presentation/constants/colors.dart';
import '../../../configs/routes/route_names.dart';
import '../../../logic/tests/vision_tests/snellan_initial_cubit.dart';
import '../../../logic/tests/vision_tests/snellan_initial_state.dart';
import '../../../logic/tests/vision_tests/snellan_test_cubit.dart';

class SnellanInitialView extends StatelessWidget {
  final String eye;
  const SnellanInitialView({super.key, required this.eye});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.sizeOf(context).height;
    double screenWidth = MediaQuery.sizeOf(context).width;
    return PopScope(
        canPop: false,
        child: Scaffold(
          backgroundColor: AppColors.screenBackground,
          body: BlocConsumer<SnellanInitialCubit, SnellanInitialState>(
            listener: (context, state) {
              if (state is SnellanInitialCompleted) {
                context.read<SnellanTestCubit>().startTest();
                context.go(RouteNames.snellanRoute);
              }
            },
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 15.0, vertical: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset('assets/images/snellan_guide.png', height: screenHeight * 0.3,),
                    SizedBox(height: screenHeight * 0.05,),
                    Text(
                      'Instructions',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: AppColors.appColor,
                        fontFamily: 'MontserratMedium',
                        fontWeight: FontWeight.w800,
                        fontSize: screenWidth * 0.05,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    Flexible(
                      child: Text(
                        '1. Cover your $eye eye with one of your hand.',
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'MontserratMedium',
                          fontSize: screenWidth * 0.04,
                          letterSpacing: 0.5,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    Flexible(
                      child: Text(
                        '2. Read slowly and loud the sequence of letters you see on the screen.',
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'MontserratMedium',
                          fontSize: screenWidth * 0.04,
                          letterSpacing: 0.5,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    Flexible(
                      child: Text(
                        '3. If you are unable to see sequence say *Not Visible*.',
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'MontserratMedium',
                          fontSize: screenWidth * 0.04,
                          letterSpacing: 0.5,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ));
  }
}
