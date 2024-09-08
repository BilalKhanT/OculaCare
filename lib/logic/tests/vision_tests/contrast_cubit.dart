import 'package:audioplayers/audioplayers.dart';
import 'package:bloc/bloc.dart';
import 'dart:math';
import 'contrast_state.dart';

class ContrastCubit extends Cubit<ContrastState> {
  ContrastCubit() : super(ContrastInitial());

  final _successAudioPlayer = AudioPlayer();
  final _errorAudioPlayer = AudioPlayer();
  final _bgAudioPlayer = AudioPlayer();

  final Random _random = Random();
  final List<double> _contrastLevels = [
    0.8,
    0.7,
    0.6,
    0.5,
    0.4,
    0.3,
    0.2,
    0.15,
    0.1,
    0.05,
    0.02
  ]; // Progressive contrast levels
  int _currentQuestionIndex = 0;
  int _score = 0;

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
      await _bgAudioPlayer.stop();
      await _successAudioPlayer.stop();
      await _errorAudioPlayer.stop();
      emit(ContrastGameOver(_score));
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
    } else {
      await _errorAudioPlayer.setSource(AssetSource('audio/error.mp3'));
      await _errorAudioPlayer.setPlaybackRate(2.0);
      await _errorAudioPlayer.resume();
    }
    _nextQuestion();
  }

  void closeGame() {
    _bgAudioPlayer.stop();
    _successAudioPlayer.stop();
    _errorAudioPlayer.stop();
    _currentQuestionIndex = 0;
    _score = 0;
  }
}
