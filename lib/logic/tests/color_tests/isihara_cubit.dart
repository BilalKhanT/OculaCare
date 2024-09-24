import 'dart:math';
import 'package:OculaCare/configs/app/remote/ml_model.dart';
import 'package:OculaCare/configs/global/app_globals.dart';
import 'package:OculaCare/data/models/tests/test_result_model.dart';
import 'package:OculaCare/data/repositories/local/preferences/shared_prefs.dart';
import 'package:OculaCare/data/repositories/tests/test_repo.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:bloc/bloc.dart';
import 'package:intl/intl.dart';

import '../../../data/models/api_response/response_model.dart';

class IshiharaCubit extends Cubit<IshiharaState> {
  final TestRepository testRepo = TestRepository();
  final Random _random = Random();
  final AudioPlayer _audioPlayer = AudioPlayer();
  final AudioPlayer _successPlayer = AudioPlayer();
  final AudioPlayer _errorPlayer = AudioPlayer();
  String analysis = '';
  MlModel ml = MlModel();
  int? answerSelected;
  bool api = false;

  IshiharaCubit()
      : super(IshiharaState(
          currentIndex: 0,
          currentQuestion: 1,
          selectedAnswer: -1,
          correctAnswers: 0,
          testCompleted: false,
          plates: [],
        ));

  String getCurrentDateString() {
    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat('dd-MM-yyyy');
    String formattedDate = formatter.format(now);
    return formattedDate;
  }

  void startGame() {
    _initializePlates();
    _startBackgroundAudio();
  }

  void _startBackgroundAudio() async {
    await _audioPlayer.setSource(AssetSource('audio/good-night-160166.mp3'));
    await _audioPlayer.setVolume(0.1);
    _audioPlayer.setReleaseMode(ReleaseMode.loop);
    await _audioPlayer.resume();
  }

  void _initializePlates() {
    final List<int> plates =
        List.generate(10, (index) => _random.nextInt(90) + 10);
    emit(state.copyWith(plates: plates, numberColor: _getRandomColor()));
  }

  void selectAnswer(int answer) {
    answerSelected = answer;
  }

  Future<bool> checkAnswer() async {
    if (answerSelected != null) {
      if (answerSelected == state.plates[state.currentIndex]) {
        await _successPlayer.setSource(AssetSource('audio/correct.mp3'));
        await _successPlayer.setPlaybackRate(2.0);
        await _successPlayer.resume();
        emit(state.copyWith(correctAnswers: state.correctAnswers + 1));
      } else {
        await _errorPlayer.setSource(AssetSource('audio/error.mp3'));
        await _errorPlayer.setPlaybackRate(2.0);
        await _errorPlayer.resume();
      }

      if (state.currentQuestion >= 10) {
        answerSelected = null;
        closeGame();
        emit(state.copyWith(loading: true));
        if (api == false) {
          try {
            api = true;
            final String date = getCurrentDateString();
            ResponseModel response = await ml.getData(
                'The Ishihara test is a color vision test that detects color blindness by having individuals identify numbers or patterns within a series of colored plates. The test consists of 10 questions, where each correct answer indicates the ability to distinguish specific colors.The patient recently took the Ishihara test and scored ${state.correctAnswers} out of 10.Based on this score, please provide a small analysis in 2 lines of the patient color vision without heading also generate text in such a way that youre talking to the patient directly. Consider if the score indicates normal color vision(score 9-10), mild(score 7-8), moderate(score 4-6).');
            ResponseModel resp = await ml.getData(
                'Also, provide recommendations in form of points without any heading or subheadings only 3 points, also generate text in such a way that youre talking to the patient directly.');
            ResponseModel resp_ = await ml.getData(
                'Additionally, mention any potential impacts of color blindness in daily activities without heading or subheadings and only 3 points, also generate text in such a way that youre talking to the patient directly');
            TestResultModel data = TestResultModel(
              email: sharedPrefs.email,
                patientName: sharedPrefs.userName,
                date: date,
                testType: 'Color Perception Test',
                testName: 'Isihara Plates',
                testScore: state.correctAnswers,
                resultDescription: response.text,
                recommendation: resp.text,
                precautions: resp_.text);
            await testRepo.addTestRecord(data);
            testResults.add(data);
            api = false;
          } catch (e) {
            api = false;
          }
        }
        emit(state.copyWith(testCompleted: true, loading: false));
      } else {
        answerSelected = null;
        emit(state.copyWith(
          currentIndex: state.currentIndex + 1,
          currentQuestion: state.currentQuestion + 1,
          selectedAnswer: -1,
          numberColor: _getRandomColor(),
        ));
      }
      return true;
    } else {
      return false;
    }
  }

  Color _getRandomColor() {
    return Color.fromARGB(
      255,
      _random.nextInt(256),
      _random.nextInt(256),
      _random.nextInt(256),
    );
  }

  void restartTest() {
    _initializePlates();
    answerSelected = null;
    emit(state.copyWith(
      currentIndex: 0,
      currentQuestion: 1,
      selectedAnswer: -1,
      correctAnswers: 0,
      plates: [],
      testCompleted: false,
    ));
  }

  void closeGame() {
    _audioPlayer.stop();
    _successPlayer.stop();
    _errorPlayer.stop();
    answerSelected = null;
  }
}

class IshiharaState {
  final int currentIndex;
  final int currentQuestion;
  final int selectedAnswer;
  final int correctAnswers;
  final bool testCompleted;
  final List<int> plates;
  final Color numberColor;
  final bool loading;

  IshiharaState({
    required this.currentIndex,
    required this.currentQuestion,
    required this.selectedAnswer,
    required this.correctAnswers,
    required this.testCompleted,
    required this.plates,
    this.numberColor = Colors.black,
    this.loading = false,
  });

  IshiharaState copyWith({
    int? currentIndex,
    int? currentQuestion,
    int? selectedAnswer,
    int? correctAnswers,
    bool? testCompleted,
    List<int>? plates,
    Color? numberColor,
    bool? loading,
  }) {
    return IshiharaState(
      currentIndex: currentIndex ?? this.currentIndex,
      currentQuestion: currentQuestion ?? this.currentQuestion,
      selectedAnswer: selectedAnswer ?? this.selectedAnswer,
      correctAnswers: correctAnswers ?? this.correctAnswers,
      testCompleted: testCompleted ?? this.testCompleted,
      plates: plates ?? this.plates,
      numberColor: numberColor ?? this.numberColor,
      loading: loading ?? this.loading,
    );
  }
}
