import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../data/repositories/feedback_repo/feedback_repo.dart';
import '../../data/repositories/local/preferences/shared_prefs.dart';
import '../auth_cubit/auth_cubit.dart';
import '../keyboard_listener_cubit/keyboard_list_cubit.dart';
import '../keyboard_listener_cubit/keyboard_list_state.dart';
import 'feedback_state.dart';

class FeedbackCubit extends Cubit<FeedbackState> {
  final KeyboardListenerCubit keyboardListenerCubit;
  FeedbackCubit(this.keyboardListenerCubit) : super(FeedbackInitial()) {
    listenToKeyboardFocus();
  }

  final FeedbackRepository feedbackRepository = FeedbackRepository();

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
      final newSelectionStatus = {
        ...currentState.selectionStatus,
        itemName: newStatus
      };
      if (itemName == "All of the above" && newStatus) {
        newSelectionStatus.updateAll((key, value) => true);
      } else if (itemName == "All of the above" && !newStatus) {
        newSelectionStatus.updateAll((key, value) => false);
      } else {
        newSelectionStatus["All of the above"] =
            newSelectionStatus.values.every((element) => element == true);
      }
      emit(FeedbackLiked(newSelectionStatus));
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
      final newSelectionStatus = {
        ...currentState.selectionStatus,
        itemName: newStatus
      };
      if (itemName == "All of the above" && newStatus) {
        newSelectionStatus.updateAll((key, value) => true);
      } else if (itemName == "All of the above" && !newStatus) {
        newSelectionStatus.updateAll((key, value) => false);
      } else {
        newSelectionStatus["All of the above"] =
            newSelectionStatus.values.every((element) => element == true);
      }
      emit(FeedbackUnLiked(newSelectionStatus));
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

  Future<void> submitFeedback(
      String category, List<String> data, String customFeedback) async {
    emit(FeedbackLoading());
    try {
      bool isSuccess = await feedbackRepository.submitTherapyFeedback(
        sharedPrefs.email,
        category,
        data,
        customFeedback,
      );
      if (isSuccess) {
        emit(FeedbackCompleted());
      } else {
        emit(FeedbackServerError());
      }
    } catch (e) {
      emit(FeedbackServerError());
    }
  }

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

  void toggleFeedbackCompleted() {
    emit(FeedbackCompleted());
  }
}
