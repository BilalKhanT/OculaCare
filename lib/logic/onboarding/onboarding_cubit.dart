import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import '../../presentation/onboarding/data_onboarding/content_model.dart';
import 'onboarding_state.dart';

class OnBoardingCubit extends Cubit<OnBoardingState> {
  OnBoardingCubit() : super(OnBoardingInitial());

  int currentIndex = 0;
  PageController pageController = PageController(initialPage: 0);

  List<OnBoardingContent> contents = [
    OnBoardingContent(
        title: 'Timely Detection',
        image: 'assets/svgs/test_img.svg',
        discription:
            "Timely identify eye diseases with our advanced detection tools."),
    OnBoardingContent(
        title: 'Eye Therapies',
        image: 'assets/svgs/therapy_img.svg',
        discription:
            "Access personalized therapy plans to improve your eye health."),
    OnBoardingContent(
        title: 'Vision Tests',
        image: 'assets/svgs/disease_detect.svg',
        discription:
            "Take comprehensive vision tests to monitor your eye health."),
  ];

  void dispose() {
    pageController.dispose();
  }

  void setIndex(int index) {
    currentIndex = index;
    emit(OnBoardingLoading());
    emit(OnBoardingLoaded(index: currentIndex));
  }
}
