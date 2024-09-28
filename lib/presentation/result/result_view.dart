import 'package:animate_do/animate_do.dart';
import 'package:cculacare/presentation/result/widgets/results_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

import '../../configs/presentation/constants/colors.dart';
import '../../logic/detection/detection_cubit.dart';
import '../../logic/detection/detection_state.dart';

class DiseaseResultView extends StatelessWidget {
  const DiseaseResultView({super.key});

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
            Icons.arrow_back_ios_new,
            color: AppColors.appColor,
            size: 30.0,
          ),
        ),
        title: Text(
          'Disease Results',
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'MontserratMedium',
            fontWeight: FontWeight.w800,
            fontSize: screenWidth * 0.05,
          ),
        ),
      ),
      body: BlocBuilder<DetectionCubit, DetectionState>(
        builder: (context, state) {
          if (state is DetectionLoading) {
            return Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
              child: SizedBox(
                height: screenHeight * 0.8,
                child: ListView.builder(
                  itemCount: 8,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 3.0),
                      child: Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7.0),
                            color: Colors.white,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15.0, vertical: 60),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: double.infinity,
                                  height: 12.0,
                                  color: Colors.black,
                                ),
                                const SizedBox(height: 5.0),
                                Container(
                                  width: double.infinity,
                                  height: 12.0,
                                  color: Colors.black,
                                ),
                                const SizedBox(height: 5.0),
                                Container(
                                  width: 100.0,
                                  height: 12.0,
                                  color: Colors.black,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          } else if (state is DetectionLoaded) {
            return Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 0.0),
              child: FadeInUp(
                duration: const Duration(milliseconds: 600),
                child: SizedBox(
                  height: screenHeight,
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: state.diseaseResults.length,
                    itemBuilder: (context, index) {
                      return FadeIn(
                        duration: Duration(milliseconds: 1000 + (index * 100)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 7.0),
                          child: DiseaseResultTile(
                            result: state.diseaseResults[index],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            );
          } else if (state is DetectionServerError) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: Text(
                    'No History Available',
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'MontserratMedium',
                      fontWeight: FontWeight.w800,
                      fontSize: screenWidth * 0.05,
                    ),
                  ),
                ),
              ],
            );
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}
