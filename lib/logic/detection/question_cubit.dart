import 'dart:developer';

import 'package:cculacare/data/repositories/symptoms_based_check/symptom_checker_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:go_router/go_router.dart';
import '../../configs/routes/route_names.dart';
import '../../data/models/disease_result/qa_model.dart';
import '../image_capture/img_capture_cubit.dart';
import 'question_state.dart';

class QuestionCubit extends Cubit<QuestionState> {
  QuestionCubit() : super(QuestionInitial());

  SymptomCheckerRepo symptomCheckerRepo = SymptomCheckerRepo();
  FlutterTts flutterTts = FlutterTts();

  Future<void> startSpeaking(String res,) async {
    try {
      await flutterTts.speak(
          res);
    } catch (error) {
      log("Error in TTS: $error");
    }
    await flutterTts.stop();
  }

  Future<void> completeCheck(BuildContext context, Diagnosis res,) async {
    try {
      await flutterTts.speak(
          res.analysis!);
    } catch (error) {
      log("Error in TTS: $error");
    }
    context.read<ImageCaptureCubit>().initializeCamera();
    context.go(RouteNames.imgCaptureRoute, extra: res);
    await flutterTts.stop();
  }


  Future<void> initiateSymptomCheck() async {
    emit(QuestionLoading());
    await flutterTts.setLanguage('en-US');
    await flutterTts.setSpeechRate(0.3);
    await flutterTts.setVolume(1.0);
    await flutterTts.setPitch(1.0);
    await flutterTts.awaitSpeakCompletion(true);
    final qaResponse = await symptomCheckerRepo.startConversation('I might be suffering from an eye disease');
    if (qaResponse != null) {

        emit(QuestionLoaded(question: qaResponse.nextQuestion!));
    }
    else {
      emit(QuestionError());
    }
  }

  Future<void> nextQuestion(String response) async {
    emit(QuestionLoading());
    final qaResponse = await symptomCheckerRepo.continueConversation(response);
    if (qaResponse != null) {
      if (qaResponse.diagnosis != null) {
        emit(QuestionFinished(result: qaResponse));
      }
      else {
        emit(QuestionLoaded(question: qaResponse.nextQuestion!));
      }

    }
  }
}
