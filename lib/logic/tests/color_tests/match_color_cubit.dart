import 'dart:async';
import 'package:OculaCare/configs/app/remote/ml_model.dart';
import 'package:OculaCare/configs/global/app_globals.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:bloc/bloc.dart';
import 'package:intl/intl.dart';

import '../../../data/models/api_response/response_model.dart';
import '../../../data/models/tests/test_result_model.dart';
import '../../../data/repositories/local/preferences/shared_prefs.dart';
import '../../../data/repositories/tests/test_repo.dart';

abstract class MatchColorState {}

class MatchColorGameInitial extends MatchColorState {}

class MatchColorGameLoading extends MatchColorState {}

class MatchColorGameInProgress extends MatchColorState {
  final Color currentColor;
  final int level;
  final int score;
  final int timeLeft;
  final int livesLeft;
  final List<Color> options;

  MatchColorGameInProgress({
    required this.currentColor,
    required this.level,
    required this.score,
    required this.timeLeft,
    required this.livesLeft,
    required this.options,
  });

  MatchColorGameInProgress copyWith({
    Color? currentColor,
    int? level,
    int? score,
    int? timeLeft,
    int? livesLeft,
    List<Color>? options,
  }) {
    return MatchColorGameInProgress(
      currentColor: currentColor ?? this.currentColor,
      level: level ?? this.level,
      score: score ?? this.score,
      timeLeft: timeLeft ?? this.timeLeft,
      livesLeft: livesLeft ?? this.livesLeft,
      options: options ?? this.options,
    );
  }
}

class MatchColorGameOver extends MatchColorState {
  final int score;

  MatchColorGameOver(this.score);
}

class MatchColorCubit extends Cubit<MatchColorState> {
  MatchColorCubit() : super(MatchColorGameInitial());

  final TestRepository testRepo = TestRepository();
  final _audioPlayer = AudioPlayer();
  final _errorPlayer = AudioPlayer();
  final _successPlayer = AudioPlayer();
  final MlModel ml = MlModel();
  Timer? _timer;
  int _timeLeft = 10;
  int _questionCount = 0;
  int _score = 0;
  int _livesLeft = 3;
  Color? _lastColor;
  bool api = false;

  void emitInitial() {
    emit(MatchColorGameInitial());
  }

  void startGame() {
    _playCalmingAudio();
    _nextQuestion();
  }

  void restartGame() {
    _questionCount = 0;
    _score = 0;
    _livesLeft = 3;
    _timeLeft = 10;
    _lastColor = null;
    startGame();
  }

  Future<void> _playCalmingAudio() async {
    await _audioPlayer.setSource(AssetSource('audio/good-night-160166.mp3'));
    await _audioPlayer.setVolume(0.1);
    _audioPlayer.setReleaseMode(ReleaseMode.loop);
    await _audioPlayer.resume();
  }

  void _nextQuestion() {
    _questionCount++;
    if (_questionCount > 10) {
      endGame();
      return;
    }

    _resetTimer();
    final nextColor = _getRandomColorWithoutRepeat();
    final options = _generateOptions(nextColor);

    emit(MatchColorGameInProgress(
      currentColor: nextColor,
      level: _questionCount,
      score: _score,
      timeLeft: _timeLeft,
      livesLeft: _livesLeft,
      options: options,
    ));
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
        if (state is MatchColorGameInProgress) {
          emit((state as MatchColorGameInProgress)
              .copyWith(timeLeft: _timeLeft));
        }
      }
    });
  }

  void _onTimeUp() {
    _livesLeft--;
    if (_livesLeft <= 0) {
      endGame();
    } else {
      _nextQuestion();
    }
  }

  Future<void> chooseColor(Color selectedColor) async {
    if (state is! MatchColorGameInProgress) return;

    final currentState = state as MatchColorGameInProgress;
    if (selectedColor == currentState.currentColor) {
      await _successPlayer.setSource(AssetSource('audio/correct.mp3'));
      await _successPlayer.setPlaybackRate(2.0);
      await _successPlayer.resume();
      _score++;
      _nextQuestion();
    } else {
      await _errorPlayer.setSource(AssetSource('audio/error.mp3'));
      await _errorPlayer.setPlaybackRate(2.0);
      await _errorPlayer.resume();
      _livesLeft--;
      if (_livesLeft <= 0) {
        endGame();
      } else {
        emit(currentState.copyWith(livesLeft: _livesLeft));
      }
    }
  }

  Future<void> endGame() async {
    _audioPlayer.stop();
    _errorPlayer.stop();
    _successPlayer.stop();
    emit(MatchColorGameLoading());
    if (api == false) {
      api = true;
      final date = getCurrentDateString();
      ResponseModel response = await ml.getData(
          'The "Match Color Game" test assesses the ability to accurately recognize and match colors under time constraints. In this test, paint flows from the top of the screen, and the patient must select one of four buckets that matches the color of the flowing paint. The patient recently took this test and matched the correct colors $_score out of 10 times. Based on this score, please provide a brief analysis in 2 lines of the patient’s color recognition and matching skills without a heading. Generate text as if you are talking directly to the patient. Consider if the score indicates excellent color recognition (score 9-10), good recognition with some errors (score 7-8), moderate difficulty (score 4-6), or significant difficulty (score 0-3).');

      ResponseModel resp = await ml.getData(
          'Also, provide recommendations in the form of points (without any heading or subheadings) with only 3 points. Generate text as if you are talking directly to the patient.');

      ResponseModel resp_ = await ml.getData(
          'Additionally, mention only 3 points potential impacts of difficulties in color recognition and matching in daily activities without heading or subheadings. Generate text as if you are talking directly to the patient.');
      TestResultModel data = TestResultModel(
          patientName: sharedPrefs.userName,
          date: date,
          testType: 'Color Perception Test',
          testName: 'Match Color',
          testScore: _score,
          resultDescription: response.text,
          recommendation: resp.text,
          precautions: resp_.text);
      await testRepo.addTestRecord(data);
      testResults.add(data);
    }
    api = false;
    emit(MatchColorGameOver(_score));
  }

  String getCurrentDateString() {
    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat('dd-MM-yyyy');
    String formattedDate = formatter.format(now);
    return formattedDate;
  }

  Color _getRandomColorWithoutRepeat() {
    final colors = [
      Colors.red,
      Colors.green,
      Colors.yellow,
      Colors.pink,
      Colors.blue
    ];
    colors.remove(_lastColor);
    final nextColor = (colors..shuffle()).first;
    _lastColor = nextColor;
    return nextColor;
  }

  List<Color> _generateOptions(Color correctColor) {
    final distinctColors = [
      Colors.orange,
      Colors.purple,
      Colors.cyan,
      Colors.amber,
      Colors.deepOrangeAccent
    ];
    distinctColors.removeWhere((color) => color == correctColor);

    Color correctShade = correctColor.withOpacity(0.7);

    distinctColors.shuffle();
    List<Color> options = [
      correctColor,
      correctShade,
      distinctColors[0],
      distinctColors[1]
    ];
    options.shuffle();

    return options;
  }

  void closeCubit() {
    _audioPlayer.stop();
    _errorPlayer.stop();
    _successPlayer.stop();
    _timer?.cancel();
  }
}
