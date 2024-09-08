import 'dart:math';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:bloc/bloc.dart';

class IshiharaCubit extends Cubit<IshiharaState> {
  final Random _random = Random();
  final AudioPlayer _audioPlayer = AudioPlayer();
  final AudioPlayer _successPlayer = AudioPlayer();
  final AudioPlayer _errorPlayer = AudioPlayer();
  int? answerSelected;

  IshiharaCubit()
      : super(IshiharaState(
          currentIndex: 0,
          currentQuestion: 1,
          selectedAnswer: -1,
          correctAnswers: 0,
          testCompleted: false,
          plates: [],
        ));

  void startGame() {
    _initializePlates();
    _startBackgroundAudio();
  }

  // Start playing the background audio on loop.
  void _startBackgroundAudio() async {
    await _audioPlayer.setSource(AssetSource('audio/good-night-160166.mp3'));
    await _audioPlayer.setVolume(0.1);
    _audioPlayer.setReleaseMode(ReleaseMode.loop);
    await _audioPlayer.resume();
  }

  // Initialize the plates with random numbers in the constructor body
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
      }
      else {
        await _errorPlayer.setSource(AssetSource('audio/error.mp3'));
        await _errorPlayer.setPlaybackRate(2.0);
        await _errorPlayer.resume();
      }

      if (state.currentQuestion >= 10) {
        answerSelected = null;
        closeGame();
        emit(state.copyWith(testCompleted: true));
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
    }
    else {
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

  IshiharaState({
    required this.currentIndex,
    required this.currentQuestion,
    required this.selectedAnswer,
    required this.correctAnswers,
    required this.testCompleted,
    required this.plates,
    this.numberColor = Colors.black, // Default color
  });

  IshiharaState copyWith({
    int? currentIndex,
    int? currentQuestion,
    int? selectedAnswer,
    int? correctAnswers,
    bool? testCompleted,
    List<int>? plates,
    Color? numberColor,
  }) {
    return IshiharaState(
      currentIndex: currentIndex ?? this.currentIndex,
      currentQuestion: currentQuestion ?? this.currentQuestion,
      selectedAnswer: selectedAnswer ?? this.selectedAnswer,
      correctAnswers: correctAnswers ?? this.correctAnswers,
      testCompleted: testCompleted ?? this.testCompleted,
      plates: plates ?? this.plates,
      numberColor: numberColor ?? this.numberColor,
    );
  }
}
