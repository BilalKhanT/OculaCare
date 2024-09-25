import 'package:OculaCare/configs/app/app_globals.dart';
import 'package:OculaCare/data/models/tests/score_model.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AnimalTrackState {
  final int score;
  final int mistaps;
  final bool isGameOver;
  final int level;

  AnimalTrackState({this.score = 0, this.mistaps = 0, this.isGameOver = false, this.level = 0});

  AnimalTrackState copyWith({int? score, int? mistaps, bool? isGameOver, int? level}) {
    return AnimalTrackState(
      score: score ?? this.score,
      mistaps: mistaps ?? this.mistaps,
      isGameOver: isGameOver ?? this.isGameOver,
      level: level ?? this.level,
    );
  }
}


class AnimalTrackCubit extends Cubit<AnimalTrackState> {
  AnimalTrackCubit() : super(AnimalTrackState());

  final _bgAudioPlayer = AudioPlayer();
  final _successAudioPlayer = AudioPlayer();
  final _errorAudioPlayer = AudioPlayer();
  int levelOneScore = 0;
  int levelTwoScore = 0;
  int levelThreeScore = 0;
  int score = 0;

  Future<void> startGame() async {
    trackLevel = 0;
    levelOneScore = 0;
    levelTwoScore = 0;
    levelThreeScore = 0;
    score = 0;
    await _bgAudioPlayer.setSource(AssetSource('audio/good-night-160166.mp3'));
    await _bgAudioPlayer.setVolume(0.1);
    _bgAudioPlayer.setReleaseMode(ReleaseMode.loop);
    await _bgAudioPlayer.resume();
  }

  void incrementScore() async {
    await _successAudioPlayer.stop();
    await _errorAudioPlayer.stop();
    await _successAudioPlayer.setSource(AssetSource('audio/success.mp3'));
    await _successAudioPlayer.setPlaybackRate(2.0);
    await _successAudioPlayer.resume();

    if (trackLevel == 0) {
      if (levelOneScore < 20) {
        levelOneScore++;
      }
    } else if (trackLevel == 1) {
      if (levelTwoScore < 20) {
        levelTwoScore++;
      }
    } else if (trackLevel == 2) {
      if (levelThreeScore < 20) {
        levelThreeScore++;
      }
    }
    emit(state.copyWith(score: state.score + 1));
  }

  void incrementMistaps() async {
    await _errorAudioPlayer.stop();
    await _successAudioPlayer.stop();
    await _errorAudioPlayer.setSource(AssetSource('audio/error.mp3'));
    await _errorAudioPlayer.setPlaybackRate(2.0);
    await _errorAudioPlayer.resume();
    emit(state.copyWith(mistaps: state.mistaps + 1));
  }

  void end() {
    _bgAudioPlayer.stop();
    _errorAudioPlayer.stop();
    _successAudioPlayer.stop();
  }

  ScoreModel endGame() {
    _bgAudioPlayer.stop();
    _errorAudioPlayer.stop();
    _successAudioPlayer.stop();
    ScoreModel scoreModel = ScoreModel(
        score1: levelOneScore, score2: levelTwoScore, score3: levelThreeScore);
    trackLevel = 0;
    levelOneScore = 0;
    levelTwoScore = 0;
    levelThreeScore = 0;
    emit(state.copyWith(isGameOver: true));
    return scoreModel;
  }
}
