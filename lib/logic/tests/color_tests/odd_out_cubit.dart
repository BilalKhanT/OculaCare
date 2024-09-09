import 'package:bloc/bloc.dart';
import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:intl/intl.dart';

import '../../../configs/app/remote/ml_model.dart';
import '../../../data/models/api_response/response_model.dart';
import '../../../data/models/tests/test_result_model.dart';
import '../../../data/repositories/local/preferences/shared_prefs.dart';
import '../../../data/repositories/tests/test_repo.dart';

part 'odd_out_state.dart';

class ColorModel {
  final List<Color> colors;
  final Color light;

  const ColorModel({
    required this.colors,
    required this.light,
  });
}

class OddOutCubit extends Cubit<OddOutState> {
  OddOutCubit() : super(OddOutState.initial());

  final TestRepository testRepo = TestRepository();
  final MlModel ml = MlModel();
  final _audioPlayer = AudioPlayer();
  final _errorPlayer = AudioPlayer();
  final _successPlayer = AudioPlayer();
  Timer? _timer;
  int _timeLeft = 10;
  int questions = 0;
  bool _isHandlingSelection = false;

  void startGame() {
    _playCalmingAudio();
    _nextQuestion();
    emit(state.copyWith(status: OddOutStatus.playing));
  }

  void emitInitial() {
    emit(OddOutState.initial());
  }

  void restartGame() {
    questions = 0;
    emit(OddOutState.initial());
    startGame();
  }

  Future<void> _playCalmingAudio() async {
    await _audioPlayer.setSource(AssetSource('audio/good-night-160166.mp3'));
    await _audioPlayer.setVolume(0.1);
    _audioPlayer.setReleaseMode(ReleaseMode.loop);
    await _audioPlayer.resume();
  }

  void _nextQuestion() {
    if (_isHandlingSelection) return;
    _isHandlingSelection = true;

    _resetTimer();
    questions += 1;
    final gridColors = _generateGridColors();
    final correctIndex = _getOddOutIndex(gridColors);

    emit(state.copyWith(
      gridColors: gridColors.colors,
      selectedIndex: -1,
      correctIndex: correctIndex,
      timeLeft: 10,
      questionsAsked: state.questionsAsked + 1,
      score: state.score,
      livesLeft: state.livesLeft,
      status: OddOutStatus.playing,
    ));

    _isHandlingSelection = false;
  }

  ColorModel _generateGridColors() {
    final baseColor =
        Colors.primaries[Random().nextInt(Colors.primaries.length)];
    final lighterShade = baseColor.withOpacity(0.7);
    final gridColors = List<Color>.generate(16, (index) => baseColor);

    final randomIndex = Random().nextInt(16);
    gridColors[randomIndex] = lighterShade;

    return ColorModel(colors: gridColors, light: lighterShade);
  }

  int _getOddOutIndex(ColorModel gridColors) {
    final lighterShade = gridColors.colors.firstWhere(
      (color) => color == gridColors.light,
      orElse: () => Colors.transparent,
    );
    return gridColors.colors.indexOf(lighterShade);
  }

  void _resetTimer() {
    _timer?.cancel();
    _timeLeft = 10;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft == 0) {
        _timer?.cancel();
        _onTimeUp();
      } else {
        _timeLeft--;
        emit(state.copyWith(timeLeft: _timeLeft));
      }
    });
  }

  void _onTimeUp() {
    _handleWrongSelection();
  }

  Future<void> selectBlock(int index) async {
    if (_isHandlingSelection) return;

    _isHandlingSelection = true;

    if (index == state.correctIndex) {
      await _successPlayer.setSource(AssetSource('audio/correct.mp3'));
      await _successPlayer.setPlaybackRate(2.0);
      await _successPlayer.resume();
      emit(state.copyWith(
        score: state.score + 1,
        selectedIndex: index,
      ));
      _isHandlingSelection = false;
      if (questions > 10) {
        endGame();
      } else {
        Future.delayed(const Duration(milliseconds: 200), _nextQuestion);
      }
    } else {
      _isHandlingSelection = false;
      _handleWrongSelection();
    }
  }

  Future<void> _handleWrongSelection() async {
    if (_isHandlingSelection) return;
    await _errorPlayer.setSource(AssetSource('audio/error.mp3'));
    await _errorPlayer.setPlaybackRate(2.0);
    await _errorPlayer.resume();
    final updatedLives = state.livesLeft - 1;
    if (updatedLives <= 0 || questions >= 10) {
      endGame();
    } else {
      emit(state.copyWith(
        livesLeft: updatedLives,
        selectedIndex: -1,
      ));
      _nextQuestion();
    }
  }

  String getCurrentDateString() {
    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat('dd-MM-yyyy');
    String formattedDate = formatter.format(now);
    return formattedDate;
  }

  void endGame() async {
    _audioPlayer.stop();
    _errorPlayer.stop();
    _successPlayer.stop();
    emit(OddOutState.initial()
        .copyWith(status: OddOutStatus.loading, score: state.score));
    final date = getCurrentDateString();
    ResponseModel response = await ml.getData(
        'The "Odd One Out" test is a color perception test that helps assess color sensitivity and subtle color differentiation skills by identifying a square with a slightly different color in a grid of squares. The patient recently took this test and spotted the different-colored square correctly ${state.score} out of 10 times. Based on this score, please provide a brief analysis in 2 lines of the patient’s color differentiation ability without a heading. Generate text as if you are talking directly to the patient. Consider if the score indicates normal color differentiation (score 9-10), mild difficulty (score 7-8), moderate difficulty (score 4-6), or significant difficulty (score 0-3).');

    ResponseModel resp = await ml.getData(
        'Also, provide recommendations in the form of points (without any heading) with only 3 points. Generate text as if you are talking directly to the patient.');

    ResponseModel resp_ = await ml.getData(
        'Additionally, mention any potential impacts of color differentiation difficulties in daily activities without heading and with only 3 points. Generate text as if you are talking directly to the patient.');
    TestResultModel data = TestResultModel(
        patientName: sharedPrefs.userName,
        date: date,
        testType: 'Color Perception Test',
        testName: 'Odd One Out',
        testScore: state.score,
        resultDescription: response.text,
        recommendation: resp.text,
        precautions: resp_.text);
    bool flag = await testRepo.addTestRecord(data);
    print(flag);
    emit(OddOutState.initial()
        .copyWith(status: OddOutStatus.gameOver, score: state.score));
    _timer?.cancel();
  }
}
