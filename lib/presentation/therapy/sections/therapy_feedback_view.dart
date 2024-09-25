import 'package:OculaCare/presentation/widgets/btn_flat.dart';
import 'package:OculaCare/presentation/widgets/cstm_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import '../../../configs/presentation/constants/colors.dart';
import '../../../configs/routes/route_names.dart';
import '../../../configs/utils/utils.dart';
import '../../../logic/auth_cubit/auth_cubit.dart';
import '../../../logic/keyboard_listener_cubit/keyboard_list_cubit.dart';
import '../../../logic/keyboard_listener_cubit/keyboard_list_state.dart';
import '../../../logic/therapy_cubit/therapy_feedback_cubit.dart';
import '../../../logic/therapy_cubit/therapy_feedback_states.dart';

class TherapyFeedbackView extends StatelessWidget {
  const TherapyFeedbackView({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.sizeOf(context).height;
    double screenWidth = MediaQuery.sizeOf(context).width;
    return Scaffold(
      backgroundColor: AppColors.screenBackground,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: AppColors.screenBackground,
        leading: IconButton(
            onPressed: () {
              context.pop();
            },
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: AppColors.appColor,
              size: 30,
            )),
        title: Text(
          'Rate your experience',
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'MontserratMedium',
            fontWeight: FontWeight.w800,
            fontSize: screenWidth * 0.05,
          ),
        ),
      ),
      body: BlocConsumer<TherapyFeedbackCubit, TherapyFeedbackState>(
        listener: (context, state) {
          if (state is TherapyFeedbackServerError) {
            AppUtils.showToast(context, 'Server Error',
                'Server error has occurred, please try again later', true);
          }
        },
        builder: (context, state) {
          if (state is TherapyFeedbackLoading) {
            return const Center(
              child: DotLoader(
                loaderColor: AppColors.appColor,
              ),
            );
          }
          if (state is TherapyFeedbackCompleted) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset('assets/svgs/thank_you.svg'),
                SizedBox(
                  height: screenHeight * 0.03,
                ),
                Text(
                  'Thank you.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: const Color(0xFF1D2838),
                    fontFamily: 'MontserratMedium',
                    fontWeight: FontWeight.w800,
                    fontSize: screenWidth * 0.06,
                    height: 0,
                    letterSpacing: -0.96,
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.03,
                ),
                Text(
                  'Your feedback will help us improve\nthe app for everyone',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: const Color(0xFF475466),
                    fontFamily: 'MontserratMedium',
                    fontWeight: FontWeight.w800,
                    fontSize: screenWidth * 0.038,
                    height: 0,
                    letterSpacing: -0.56,
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.05,
                ),
                Padding(
                    padding: const EdgeInsets.only(left: 30, right: 30),
                    child: ButtonFlat(
                        btnColor: AppColors.appColor,
                        textColor: Colors.white,
                        onPress: () {
                          context.go(RouteNames.dashboardRoute);
                          context
                              .read<TherapyFeedbackCubit>()
                              .emitInitial(cubit: context.read<AuthCubit>());
                          context.read<TherapyFeedbackCubit>().clearController();
                        },
                        text: 'Back to Dashboard')),
              ],
            );
          }
          return Column(
            children: [
              SizedBox(
                height: screenHeight * 0.03,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: BlocBuilder<TherapyFeedbackCubit, TherapyFeedbackState>(
                  builder: (context, state) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          onTap: () {
                            context.read<TherapyFeedbackCubit>().likedFeedbackState();
                            context.read<TherapyFeedbackCubit>().clearController();
                          },
                          child: Container(
                            width: MediaQuery.sizeOf(context).width * 0.38,
                            height: MediaQuery.sizeOf(context).height * 0.17,
                            decoration: ShapeDecoration(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(
                                    width: 1, color: Color(0xFFF2F3F6)),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              shadows: const [
                                BoxShadow(
                                  color: Color(0x0F000000),
                                  blurRadius: 24,
                                  offset: Offset(0, 4),
                                  spreadRadius: 0,
                                )
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                (state is TherapyFeedbackLiked)
                                    ? SvgPicture.asset(
                                    'assets/svgs/liked_feedback_pressed.svg')
                                    : SvgPicture.asset(
                                    'assets/svgs/liked_experience.svg'),
                                Text(
                                  'Loved it',
                                  style: TextStyle(
                                    color: const Color(0xFF98A1B2),
                                    fontFamily: 'MontserratMedium',
                                    fontWeight: FontWeight.w800,
                                    fontSize: screenWidth * 0.04,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            context
                                .read<TherapyFeedbackCubit>()
                                .unlikedFeedbackState();
                            context.read<TherapyFeedbackCubit>().clearController();
                          },
                          child: Container(
                            width: MediaQuery.sizeOf(context).width * 0.38,
                            height: MediaQuery.sizeOf(context).height * 0.17,
                            decoration: ShapeDecoration(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(
                                    width: 1, color: Color(0xFFF2F3F6)),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              shadows: const [
                                BoxShadow(
                                  color: Color(0x0F000000),
                                  blurRadius: 24,
                                  offset: Offset(0, 4),
                                  spreadRadius: 0,
                                )
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                (state is TherapyFeedbackUnLiked)
                                    ? SvgPicture.asset(
                                    'assets/svgs/unliked_feedback_pressed.svg')
                                    : SvgPicture.asset(
                                    'assets/svgs/unliked_experience.svg'),
                                Text(
                                  'Not Great',
                                  style: TextStyle(
                                    color: const Color(0xFF98A1B2),
                                    fontFamily: 'MontserratMedium',
                                    fontWeight: FontWeight.w800,
                                    fontSize: screenWidth * 0.04,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              SizedBox(
                height: screenHeight * 0.05,
              ),
              BlocBuilder<KeyboardListenerCubit, KeyboardListenerState>(
                builder: (context, state) {
                  if (state is KeyboardClosed) {
                    return BlocBuilder<TherapyFeedbackCubit, TherapyFeedbackState>(
                      builder: (context, state) {
                        if (state is TherapyFeedbackLiked) {
                          return Column(
                            children:
                            state.selectionStatus.keys.map((itemName) {
                              return Padding(
                                padding:
                                const EdgeInsets.only(left: 30, right: 30),
                                child: InkWell(
                                  onTap: () {
                                    context
                                        .read<TherapyFeedbackCubit>()
                                        .toggleLikedItem(itemName);
                                  },
                                  child: Container(
                                    height: MediaQuery.sizeOf(context).height *
                                        0.05,
                                    margin: const EdgeInsets.only(top: 10),
                                    decoration: BoxDecoration(
                                      color: state.selectionStatus[itemName] ??
                                          false
                                          ? Colors.green[200]
                                          : Colors.grey,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Center(
                                      child: Text(
                                        itemName,
                                        style: TextStyle(
                                          color:
                                          state.selectionStatus[itemName] ??
                                              false
                                              ? Colors.black
                                              : Colors.white,
                                          fontFamily: 'MontserratMedium',
                                          fontWeight: FontWeight.w600,
                                          fontSize: screenWidth * 0.04,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          );
                        }
                        if (state is TherapyFeedbackUnLiked) {
                          return Column(
                            children:
                            state.selectionStatus.keys.map((itemName) {
                              return Padding(
                                padding:
                                const EdgeInsets.only(left: 30, right: 30),
                                child: InkWell(
                                  onTap: () {
                                    context
                                        .read<TherapyFeedbackCubit>()
                                        .toggleUnLikedItem(itemName);
                                  },
                                  child: Container(
                                    height: MediaQuery.sizeOf(context).height *
                                        0.05,
                                    margin: const EdgeInsets.only(top: 10),
                                    decoration: BoxDecoration(
                                      color: state.selectionStatus[itemName] ??
                                          false
                                          ? Colors.red[200]
                                          : Colors.grey,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Center(
                                      child: Text(
                                        itemName,
                                        style: TextStyle(
                                          color:
                                          state.selectionStatus[itemName] ??
                                              false
                                              ? Colors.black
                                              : Colors.white,
                                          fontFamily: 'MontserratMedium',
                                          fontWeight: FontWeight.w600,
                                          fontSize: screenWidth * 0.04,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          );
                        }
                        return const SizedBox();
                      },
                    );
                  }
                  return const SizedBox();
                },
              ),
              SizedBox(
                height: screenHeight * 0.03,
              ),
              BlocBuilder<TherapyFeedbackCubit, TherapyFeedbackState>(
                builder: (context, state) {
                  if (state is TherapyFeedbackLiked || state is TherapyFeedbackUnLiked) {
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 25, right: 25, top: 10),
                          child: Container(
                            height: MediaQuery.sizeOf(context).height * 0.12,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.all(4),
                            child: TextField(
                              maxLines: null,
                              maxLength: 400,
                              controller: context
                                  .read<TherapyFeedbackCubit>()
                                  .textFeedbackController,
                              focusNode: context
                                  .read<TherapyFeedbackCubit>()
                                  .textFeedbackNode,
                              keyboardType: TextInputType.multiline,
                              expands: true,
                              style: TextStyle(
                                fontFamily: 'MontserratMedium',
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: screenWidth * 0.037,
                              ),
                              decoration: InputDecoration(
                                hintStyle: TextStyle(
                                  fontFamily: 'MontserratMedium',
                                  fontWeight: FontWeight.w600,
                                  fontSize: screenWidth * 0.037,
                                ),
                                hintText: "Add text here (optional)",
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: const EdgeInsets.all(8),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: screenHeight * 0.03,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 30, right: 30),
                          child: InkWell(
                            onTap: () {
                              if (state is TherapyFeedbackLiked) {
                                if (state.selectionStatus.values
                                    .every((element) => element == false)) {
                                  AppUtils.showToast(
                                      context,
                                      'Error',
                                      'Please select at least one option',
                                      true);
                                  return;
                                }
                              }
                              if (state is TherapyFeedbackUnLiked) {
                                if (state.selectionStatus.values
                                    .toList()
                                    .every((element) => element == false)) {
                                  AppUtils.showToast(
                                      context,
                                      'Error',
                                      'Please select at least one option',
                                      true);
                                  return;
                                }
                              }
                              context
                                  .read<TherapyFeedbackCubit>()
                                  .toggleFeedbackCompleted();
                              context.read<TherapyFeedbackCubit>().clearController();
                            },
                            child: BlocBuilder<TherapyFeedbackCubit, TherapyFeedbackState>(
                              builder: (context, state) {
                                return GestureDetector(
                                  onTap: () {
                                    if (state is TherapyFeedbackLiked) {
                                      if (state.selectionStatus.values.every(
                                              (element) => element == false)) {
                                        AppUtils.showToast(
                                            context,
                                            'Error',
                                            'Please select at least one option',
                                            true);
                                        return;
                                      }
                                      List<String> list = state
                                          .selectionStatus.entries
                                          .where((entry) => entry.value == true)
                                          .map((entry) {
                                        if (!entry.key
                                            .contains("All of the above")) {
                                          return entry.key;
                                        }
                                        return "";
                                      }).toList();
                                      list.remove("");
                                      context
                                          .read<TherapyFeedbackCubit>()
                                          .submitFeedback(
                                          'Liked',
                                          list,
                                          context
                                              .read<TherapyFeedbackCubit>()
                                              .textFeedbackController
                                              .text);
                                    }
                                    if (state is TherapyFeedbackUnLiked) {
                                      if (state.selectionStatus.values
                                          .toList()
                                          .every(
                                              (element) => element == false)) {
                                        AppUtils.showToast(
                                            context,
                                            'Error',
                                            'Please select at least one option',
                                            true);
                                        return;
                                      }
                                      List<String> list = state
                                          .selectionStatus.entries
                                          .where((entry) => entry.value == true)
                                          .map((entry) {
                                        if (!entry.key
                                            .contains("All of the above")) {
                                          return entry.key;
                                        }
                                        return "";
                                      }).toList();
                                      list.remove("");

                                      context
                                          .read<TherapyFeedbackCubit>()
                                          .submitFeedback(
                                          'Unliked',
                                          list,
                                          context
                                              .read<TherapyFeedbackCubit>()
                                              .textFeedbackController
                                              .text);
                                    }
                                  },
                                  child: Container(
                                    height: 55,
                                    margin: const EdgeInsets.only(top: 10),
                                    decoration: BoxDecoration(
                                      color: AppColors.appColor,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Submit",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'MontserratMedium',
                                          fontSize: screenWidth * 0.045,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                  return const SizedBox();
                },
              ),
            ],
          );
        },
      ),
    );
  }
}