import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import '../../configs/presentation/constants/colors.dart';
import '../../configs/routes/route_names.dart';
import '../../configs/utils/utils.dart';
import '../../logic/auth_cubit/auth_cubit.dart';
import '../../logic/feedback_cubit/feedback_cubit.dart';
import '../../logic/feedback_cubit/feedback_state.dart';
import '../../logic/keyboard_listener_cubit/keyboard_list_cubit.dart';
import '../../logic/keyboard_listener_cubit/keyboard_list_state.dart';

class FeedbackView extends StatelessWidget {
  const FeedbackView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              context.pop();
              context
                  .read<FeedbackCubit>()
                  .emitInitial(cubit: context.read<AuthCubit>());
            },
            icon: const Icon(
              Icons.arrow_back,
              size: 30,
            )),
        title: const Text(
          'Rate your experience',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
          ),
        ),
      ),
      body: BlocConsumer<FeedbackCubit, FeedbackState>(
        listener: (context, state) {
          if (state is FeedbackServerError) {
            AppUtils.showToast(context, 'Server Error', 'Server error has occurred, please try again later', true);
          }
        },
        builder: (context, state) {
          if (state is FeedbackLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is FeedbackCompleted) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset('assets/svgs/thank_you.svg'),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'Thank you.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF1D2838),
                    fontSize: 24,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                    height: 0,
                    letterSpacing: -0.96,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'Your feedback will help us improve\nthe app for everyone',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF475466),
                    fontSize: 14,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                    height: 0,
                    letterSpacing: -0.56,
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30),
                  child: InkWell(
                    onTap: () {
                      context.go(RouteNames.homeRoute);
                      context
                          .read<FeedbackCubit>()
                          .emitInitial(cubit: context.read<AuthCubit>());
                      context.read<FeedbackCubit>().clearController();
                    },
                    child: Container(
                      height: 50,
                      margin: const EdgeInsets.only(top: 10),
                      decoration: BoxDecoration(
                        color: AppColors.appColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: Text(
                          "Back to home",
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Poppins',
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: BlocBuilder<FeedbackCubit, FeedbackState>(
                  builder: (context, state) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          onTap: () {
                            context.read<FeedbackCubit>().likedFeedbackState();
                            context.read<FeedbackCubit>().clearController();
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
                                (state is FeedbackLiked)
                                    ? SvgPicture.asset('assets/svgs/liked_feedback_pressed.svg')
                                    : SvgPicture.asset('assets/svgs/liked_experience.svg'),
                                const Text(
                                  'Loved it',
                                  style: TextStyle(
                                    color: Color(0xFF98A1B2),
                                    fontSize: 16,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            context
                                .read<FeedbackCubit>()
                                .unlikedFeedbackState();
                            context.read<FeedbackCubit>().clearController();
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
                                (state is FeedbackUnLiked)
                                    ? SvgPicture.asset('assets/svgs/unliked_feedback_pressed.svg')
                                    : SvgPicture.asset('assets/svgs/unliked_experience.svg'),
                                const Text(
                                  'Not Great',
                                  style: TextStyle(
                                    color: Color(0xFF98A1B2),
                                    fontSize: 16,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w600,
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
              BlocBuilder<KeyboardListenerCubit, KeyboardListenerState>(
                builder: (context, state) {
                  if (state is KeyboardClosed) {
                    return BlocBuilder<FeedbackCubit, FeedbackState>(
                      builder: (context, state) {
                        if (state is FeedbackLiked) {
                          return Column(
                            children:
                            state.selectionStatus.keys.map((itemName) {
                              return Padding(
                                padding:
                                const EdgeInsets.only(left: 30, right: 30),
                                child: InkWell(
                                  onTap: () {
                                    context.read<FeedbackCubit>().toggleLikedItem(itemName);
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
                                          fontFamily: 'Poppins',
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          );
                        }
                        if (state is FeedbackUnLiked) {
                          return Column(
                            children:
                            state.selectionStatus.keys.map((itemName) {
                              return Padding(
                                padding:
                                const EdgeInsets.only(left: 30, right: 30),
                                child: InkWell(
                                  onTap: () {
                                    context.read<FeedbackCubit>().toggleUnLikedItem(itemName);
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
                                          fontFamily: 'Poppins',
                                          fontSize: 16,
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
              BlocBuilder<FeedbackCubit, FeedbackState>(
                builder: (context, state) {
                  if (state is FeedbackLiked || state is FeedbackUnLiked) {
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
                                  .read<FeedbackCubit>()
                                  .textFeedbackController,
                              focusNode: context
                                  .read<FeedbackCubit>()
                                  .textFeedbackNode,
                              keyboardType: TextInputType.multiline,
                              expands: true,
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Poppins',
                                fontSize: 14.sp,
                              ),
                              decoration: const InputDecoration(
                                hintText: "Add text here (optional)",
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.all(8),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 30, right: 30),
                          child: InkWell(
                            onTap: () {
                              if (state is FeedbackLiked) {
                                if (state.selectionStatus.values
                                    .every((element) => element == false)) {
                                  AppUtils.showToast(context, 'Error', 'Please select at least one option', true);
                                  return;
                                }
                              }
                              if (state is FeedbackUnLiked) {
                                if (state.selectionStatus.values
                                    .toList()
                                    .every((element) => element == false)) {
                                  AppUtils.showToast(context, 'Error', 'Please select at least one option', true);
                                  return;
                                }
                              }
                              context
                                  .read<FeedbackCubit>()
                                  .toggleFeedbackCompleted();
                              context.read<FeedbackCubit>().clearController();
                            },
                            child: BlocBuilder<FeedbackCubit, FeedbackState>(
                              builder: (context, state) {
                                return GestureDetector(
                                  onTap: () {
                                    if (state is FeedbackLiked) {
                                      if (state.selectionStatus.values
                                          .every((element) => element == false)) {
                                        AppUtils.showToast(context, 'Error', 'Please select at least one option', true);
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
                                          .read<FeedbackCubit>()
                                          .submitFeedback('Liked',
                                          list,
                                          context
                                              .read<FeedbackCubit>()
                                              .textFeedbackController
                                              .text);
                                    }
                                    if (state is FeedbackUnLiked) {
                                      if (state.selectionStatus.values
                                          .toList()
                                          .every((element) => element == false)) {
                                        AppUtils.showToast(context, 'Error', 'Please select at least one option', true);
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
                                          .read<FeedbackCubit>()
                                          .submitFeedback('Unliked',
                                          list,
                                          context
                                              .read<FeedbackCubit>()
                                              .textFeedbackController
                                              .text);
                                    }
                                  },
                                  child: Container(
                                    height: 40,
                                    margin: const EdgeInsets.only(top: 10),
                                    decoration: BoxDecoration(
                                      color: AppColors.appColor,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Center(
                                      child: Text(
                                        "Submit",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'Poppins',
                                          fontSize: 16,
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
