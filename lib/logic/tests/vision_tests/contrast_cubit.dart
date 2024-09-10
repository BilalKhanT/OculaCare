import 'package:OculaCare/configs/app/remote/ml_model.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:bloc/bloc.dart';
import 'package:intl/intl.dart';
import 'dart:math';
import '../../../data/models/api_response/response_model.dart';
import '../../../data/models/tests/test_result_model.dart';
import '../../../data/repositories/local/preferences/shared_prefs.dart';
import '../../../data/repositories/tests/test_repo.dart';
import 'contrast_state.dart';

class ContrastCubit extends Cubit<ContrastState> {
  ContrastCubit() : super(ContrastInitial());

  final TestRepository testRepo = TestRepository();
  final _successAudioPlayer = AudioPlayer();
  final _errorAudioPlayer = AudioPlayer();
  final _bgAudioPlayer = AudioPlayer();
  MlModel ml = MlModel();
  final Random _random = Random();
  final List<double> _contrastLevels = [
    0.8,
    0.6,
    0.5,
    0.4,
    0.3,
    0.2,
    0.15,
    0.1,
    0.05,
    0.02,
  ];
  int _currentQuestionIndex = 0;
  int _score = 0;

  String getCurrentDateString() {
    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat('dd-MM-yyyy');
    String formattedDate = formatter.format(now);
    return formattedDate;
  }

  void emitInitial() {
    emit(ContrastInitial());
  }

  Future<void> startGame() async {
    _currentQuestionIndex = 0;
    _score = 0;
    await _bgAudioPlayer.setSource(AssetSource('audio/good-night-160166.mp3'));
    await _bgAudioPlayer.setVolume(0.1);
    _bgAudioPlayer.setReleaseMode(ReleaseMode.loop);
    await _bgAudioPlayer.resume();
    emit(ContrastGameInProgress());
    _nextQuestion();
  }

  Future<void> _nextQuestion() async {
    if (_currentQuestionIndex >= _contrastLevels.length) {
      await _endGame();
    } else {
      String correctWord = _generateRandomWord(4);
      List<String> options = _generateOptions(correctWord);
      emit(ContrastQuestion(
        correctWord: correctWord,
        options: options,
        contrast: _contrastLevels[_currentQuestionIndex],
      ));
      _currentQuestionIndex++;
    }
  }

  String _generateRandomWord(int length) {
    const String letters = 'ABCDEFGHIJKLMNOPRSTUVWXYZ';
    return List.generate(
        length, (_) => letters[_random.nextInt(letters.length)]).join();
  }

  List<String> _generateOptions(String correctWord) {
    Set<String> options = {correctWord};
    while (options.length < 3) {
      options.add(_generateRandomWord(correctWord.length));
    }
    return options.toList()..shuffle();
  }

  Future<void> selectOption(String selectedWord, String correctWord) async {
    if (selectedWord == correctWord) {
      _score++;
      await _successAudioPlayer.setSource(AssetSource('audio/correct.mp3'));
      await _successAudioPlayer.setPlaybackRate(2.0);
      await _successAudioPlayer.resume();
      _nextQuestion();
    } else {
      await _errorAudioPlayer.setSource(AssetSource('audio/error.mp3'));
      await _errorAudioPlayer.setPlaybackRate(2.0);
      await _errorAudioPlayer.resume();
      await _endGame();
    }
  }

  Future<void> _endGame() async {
    await _bgAudioPlayer.stop();
    await _successAudioPlayer.stop();
    await _errorAudioPlayer.stop();
    emit(ContrastLoading());
    String analysis = determineContrastSensitivity(_score);
    String date = getCurrentDateString();
    ResponseModel resp = await ml.getData(
        'Patient took contrast sensitivity test and this is the analysis $analysis, provide recommendations in form of points without any heading only 3 points, also generate text in such a way that youre talking to the patient directly.');
    ResponseModel resp_ = await ml.getData(
        'Additionally, mention any potential impacts daily activities without heading and only 3 points, also generate text in such a way that youre talking to the patient directly');
    TestResultModel data = TestResultModel(
        patientName: sharedPrefs.userName,
        date: date,
        testType: 'Vision Acuity Test',
        testName: 'Contrast Sensitivity',
        testScore: _score,
        resultDescription: analysis,
        recommendation: resp.text,
        precautions: resp_.text);
    bool flag = await testRepo.addTestRecord(data);
    print(flag);
    emit(ContrastGameOver(_score));
  }

  void closeGame() {
    _bgAudioPlayer.stop();
    _successAudioPlayer.stop();
    _errorAudioPlayer.stop();
    _currentQuestionIndex = 0;
    _score = 0;
  }

  String determineContrastSensitivity(int score) {
    if (score >= 10) {
      return "Excellent Contrast Sensitivity: You can distinguish objects even at very low contrast levels.";
    } else if (score >= 8) {
      return "Good Contrast Sensitivity: You can distinguish objects at moderately low contrast levels.";
    } else if (score >= 5) {
      return "Average Contrast Sensitivity: You can distinguish objects at moderate contrast levels.";
    } else if (score >= 3) {
      return "Below Average Contrast Sensitivity: You can distinguish objects only at higher contrast levels.";
    } else {
      return "Poor Contrast Sensitivity: You have difficulty distinguishing objects unless they are at very high contrast levels.";
    }
  }

}
