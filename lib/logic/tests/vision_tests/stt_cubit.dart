import 'package:OculaCare/logic/tests/vision_tests/stt_state.dart';
import 'package:bloc/bloc.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class SttCubit extends Cubit<SttState> {
  SttCubit() : super(SttInitial()) {
    initializeSpeech();
  }

  String recognisedText = '';

  late stt.SpeechToText speech;

  Future<void> initializeSpeech() async {
    speech = stt.SpeechToText();
    await speech.initialize(
      onError: (val) => recognisedText = '',
      onStatus: (val) => log(val),
    );
  }

  Future<void> startSpeaking() async {
    emit(SttListening());
    recognisedText = '';
    speech.listen(
      onResult: (result) {
        recognisedText = result.recognizedWords;
      },
    );
  }

  Future<String> stopSpeaking() async {
    await Future.delayed(const Duration(seconds: 1));
    await speech.stop();
    emit(SttInitial());
    return recognisedText;
  }

  Future<void> disposeStt() async {
    await speech.stop();
  }
}
