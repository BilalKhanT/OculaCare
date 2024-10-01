import 'package:cculacare/logic/tests/vision_tests/snellan_initial_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:nb_utils/nb_utils.dart';

class SnellanInitialCubit extends Cubit<SnellanInitialState> {
  SnellanInitialCubit() : super(SnellanInitial());

  FlutterTts flutterTts = FlutterTts();

  Future<void> startSpeaking(String eye) async {
    emit(SnellanInitialLoading());
    await Future.delayed(const Duration(milliseconds: 300));

    await flutterTts.setLanguage('en-US');
    await flutterTts.setSpeechRate(0.3);
    await flutterTts.setVolume(1.0);
    await flutterTts.setPitch(1.0);
    await flutterTts.awaitSpeakCompletion(true);

    try {
      await flutterTts.speak(
          'Cover your $eye eye with one of your hand. Read slowly and loud the words you see on the screen. If you are unable to see the sequence say not visible. Tap on the mic button to start speaking and tap on it again when done speaking.');
    } catch (error) {
      log("Error in TTS: $error");
    }

    await Future.delayed(const Duration(seconds: 2));
    await flutterTts.stop();
    emit(SnellanInitialCompleted());
  }

  Future<void> stopSpeak() async {
    await flutterTts.stop();
  }
}
