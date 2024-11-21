import 'package:bloc/bloc.dart';
import 'package:audioplayers/audioplayers.dart';


class MusicCubit extends Cubit<void> {
  final AudioPlayer _audioPlayer = AudioPlayer();

  MusicCubit() : super(null);

  Future<void> playMusic(String soundPath) async {
    await _audioPlayer.setSource(AssetSource(soundPath));
    await _audioPlayer.setVolume(0.1);
    _audioPlayer.setReleaseMode(ReleaseMode.loop);
    await _audioPlayer.resume();
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
