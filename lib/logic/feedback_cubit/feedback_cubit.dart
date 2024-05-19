import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../auth_cubit/auth_cubit.dart';
import '../keyboard_listener_cubit/keyboard_list_cubit.dart';
import '../keyboard_listener_cubit/keyboard_list_state.dart';
import 'feedback_state.dart';

class FeedbackCubit extends Cubit<FeedbackState> {
  final KeyboardListenerCubit keyboardListenerCubit;
  FeedbackCubit(this.keyboardListenerCubit) : super(FeedbackInitial()) {
    listenToKeyboardFocus();
  }

  //liked feedback track
  Map<String, bool> likedItems = {
    "Easy to capture image": false,
    "Easy to track my past results": false,
    "Easy to take tests": false,
    "Easy to see my therapy points": false,
    "All of the above": false,
  };
  void likedFeedbackState() {
    emit(FeedbackLiked(likedItems));
  }

  void toggleLikedItem(String itemName) {
    if (state is FeedbackLiked) {
      final currentState = state as FeedbackLiked;
      final newStatus = !currentState.selectionStatus[itemName]!;
      emit(FeedbackLiked(
          {...currentState.selectionStatus, itemName: newStatus}));
    }
  }

  void selectAllLikedItems() {
    if (state is FeedbackLiked) {
      final currentState = state as FeedbackLiked;
      final newStatus =
      currentState.selectionStatus.map((key, value) => MapEntry(key, true));
      emit(FeedbackLiked(newStatus));
    }
  }

  //unliked feedback track

  Map<String, bool> unlikedItems = {
    "Difficult to capture image": false,
    "Difficult to track my past results": false,
    "Difficult to take tests": false,
    "Difficult to see my therapy points": false,
    "All of the above": false,
  };
  void toggleUnLikedItem(String itemName) {
    if (state is FeedbackUnLiked) {
      final currentState = state as FeedbackUnLiked;
      final newStatus = !currentState.selectionStatus[itemName]!;
      emit(FeedbackUnLiked(
          {...currentState.selectionStatus, itemName: newStatus}));
    }
  }

  void selectAllUnLikedItems() {
    if (state is FeedbackUnLiked) {
      final currentState = state as FeedbackUnLiked;
      final newStatus =
      currentState.selectionStatus.map((key, value) => MapEntry(key, true));
      emit(FeedbackUnLiked(newStatus));
    }
  }

  void unlikedFeedbackState() {
    emit(FeedbackUnLiked(unlikedItems));
  }

  void emitInitial({AuthCubit? cubit}) {
    if (state is! FeedbackInitial) {
      emit(FeedbackInitial());
    }
    cubit?.closeKeyboard();
  }

  //submit feedback
  Future<void> submitFeedback(
      List<String> data, String customFeedback, int rating) async {
    emit(FeedbackLoading());
    // FeedbackRepository feedbackRepo = FeedbackRepository();
    // await feedbackRepo.postFeedback(data, customFeedback, rating);
    emit(FeedbackCompleted());
  }

  //text feedback
  final textFeedbackController = TextEditingController();
  final FocusNode textFeedbackNode = FocusNode();

  void _onFocusChanged() async {
    if (textFeedbackNode.hasFocus) {
      keyboardListenerCubit.emit(KeyboardOpened());
    } else {
      await 150.milliseconds.delay;
      keyboardListenerCubit.emit(KeyboardClosed());
    }
  }

  void listenToKeyboardFocus() {
    textFeedbackNode.addListener(_onFocusChanged);
  }

  void clearController() {
    if (textFeedbackController.text.isNotEmpty) {
      textFeedbackController.clear();
    }
  }

  //feedback completed
  void toggleFeedbackCompleted() {
    emit(FeedbackCompleted());
  }
}