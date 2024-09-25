import 'dart:convert';
import 'package:OculaCare/data/repositories/local/preferences/shared_prefs.dart';
import 'package:OculaCare/logic/therapy_cubit/therapy_feedback_states.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:http/http.dart' as http;
import '../../configs/app/app_globals.dart';
import '../auth_cubit/auth_cubit.dart';
import '../keyboard_listener_cubit/keyboard_list_cubit.dart';
import '../keyboard_listener_cubit/keyboard_list_state.dart';

class TherapyFeedbackCubit extends Cubit<TherapyFeedbackState> {
  final KeyboardListenerCubit keyboardListenerCubit;
  TherapyFeedbackCubit(this.keyboardListenerCubit) : super(TherapyFeedbackInitial()) {
    listenToKeyboardFocus();
  }

  Map<String, bool> likedItems = {
    "Therapy was easy to follow": false,
    "I felt improvement after therapy": false,
    "Therapy instructions were clear": false,
    "Therapy reminders were helpful": false,
    "All of the above": false,
  };


  void likedFeedbackState() {
    emit(TherapyFeedbackLiked(likedItems));
  }

  void toggleLikedItem(String itemName) {
    if (state is TherapyFeedbackLiked) {
      final currentState = state as TherapyFeedbackLiked;
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

      emit(TherapyFeedbackLiked(newSelectionStatus));
    }
  }

  void selectAllLikedItems() {
    if (state is TherapyFeedbackLiked) {
      final currentState = state as TherapyFeedbackLiked;
      final newStatus =
      currentState.selectionStatus.map((key, value) => MapEntry(key, true));
      emit(TherapyFeedbackLiked(newStatus));
    }
  }

  Map<String, bool> unlikedItems = {
    "Therapy was difficult to follow": false,
    "I didn’t feel any improvement": false,
    "Therapy instructions were unclear": false,
    "Therapy reminders were not helpful": false,
    "All of the above": false,
  };

  void toggleUnLikedItem(String itemName) {
    if (state is TherapyFeedbackUnLiked) {
      final currentState = state as TherapyFeedbackUnLiked;
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

      emit(TherapyFeedbackUnLiked(newSelectionStatus));
    }
  }

  void selectAllUnLikedItems() {
    if (state is TherapyFeedbackUnLiked) {
      final currentState = state as TherapyFeedbackUnLiked;
      final newStatus =
      currentState.selectionStatus.map((key, value) => MapEntry(key, true));
      emit(TherapyFeedbackUnLiked(newStatus));
    }
  }

  void unlikedFeedbackState() {
    emit(TherapyFeedbackUnLiked(unlikedItems));
  }

  void emitInitial({AuthCubit? cubit}) {
    if (state is! TherapyFeedbackInitial) {
      emit(TherapyFeedbackInitial());
    }
    cubit?.closeKeyboard();
  }

  Future<void> submitFeedback(
      String category, List<String> data, String customFeedback) async {
    emit(TherapyFeedbackLoading());
    try {
      var url = Uri.parse('$ipServer/api/feedback/submit');
      var response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': sharedPrefs.email,
          'category': category,
          'defaults': data,
          'customMessage': customFeedback,
        }),
      );
      if (response.statusCode == 200) {
        emit(TherapyFeedbackCompleted());
      } else {
        emit(TherapyFeedbackServerError());
      }
    } catch (e) {
      emit(TherapyFeedbackServerError());
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
    emit(TherapyFeedbackCompleted());
  }
}
