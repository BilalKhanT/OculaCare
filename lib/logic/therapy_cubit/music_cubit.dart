import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:bloc/bloc.dart';

class MusicCubit extends Cubit<void> {
  final AssetsAudioPlayer _audioPlayer = AssetsAudioPlayer();

  MusicCubit() : super(null);

  void playMusic(String soundPath) {
    _audioPlayer.open(
      Audio(soundPath),
      autoStart: true,
      loopMode:
          LoopMode.single,
    );
  }

  void stopMusic() {
    _audioPlayer.stop();
  }

  @override
  Future<void> close() {
    _audioPlayer.dispose();
    return super.close();
  }
}
