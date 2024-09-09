import 'package:OculaCare/logic/tests/vision_tests/snellan_test_state.dart';
import 'package:bloc/bloc.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class SnellanTestCubit extends Cubit<SnellanTestState> {
  SnellanTestCubit() : super(SnellanTestInitial()) {
    _speech = stt.SpeechToText();
  }

  int initialIndex = 0;
  int subIndex = 0;
  int score = 0;
  int wrongGuesses = 0;
  String recognizedText = "";
  late stt.SpeechToText _speech;

  final List<double> snellanDistances = [
    60.0,
    36.0,
    24.0,
    18.0,
    12.0,
    9.0,
    6.0,
    5.0,
    4.0,
    3.0,
  ];

  List<List<String>> snellanList = [
    ['AP'],
    ['BK', 'LW'],
    ['EA', 'OP', 'NL'],
    ['FP', 'CN', 'LO', 'GR'],
    ['DE', 'GC', 'AS', 'OP', 'ZY'],
    ['NX', 'ZS', 'PJ', 'VN', 'KP', 'AY'],
    ['UK', 'MJ', 'EB', 'NJ', 'RS', 'LP', 'OC'],
    ['IF', 'SV', 'MA', 'KX', 'ZM', 'BG', 'IK', 'OM'],
  ];

  Future<void> loadSnellanTest() async {
    emit(SnellanTestLoading());
    initialIndex = 0;
    subIndex = 0;
    score = 0;
    wrongGuesses = 0;
    emit(SnellanTestLoaded());
  }

  Future<void> startTest() async {
    score = 0;
    initialIndex = 0;
    subIndex = 0;
    wrongGuesses = 0;
    emit(SnellanTestLoading());
    await Future.delayed(const Duration(seconds: 1));
    emit(SnellanTestNext(
        snellanList[initialIndex], subIndex, calculateFontSize()));
    await initListening();
  }

  Future<void> initListening() async {
    try {
      bool available = await _speech.initialize(
        onError: (val) => log("Error: $val"),
        onStatus: (val) => log("Status: $val"),
      );

      if (available) {
        startListening();
      } else {
        emit(SnellanTestError());
      }
    } catch (e) {
      emit(SnellanTestError());
    }
  }

  void startListening() {
    _speech.listen(
      onResult: (result) {
        recognizedText = result.recognizedWords;
      },
      listenFor: const Duration(seconds: 5),
      pauseFor: const Duration(seconds: 5),
    );

    Future.delayed(const Duration(seconds: 5), () async {
      await _speech.stop();
      await nextRow(snellanList[initialIndex]);
    });
  }

  Future<void> nextRow(List<String> check) async {
    String normalizedRecognizedText =
        recognizedText.replaceAll(' ', '').toUpperCase();

    if (check.contains(normalizedRecognizedText)) {
      score += 1;
      wrongGuesses = 0;
    } else if (normalizedRecognizedText.replaceAll(' ', '').toUpperCase() ==
        'NOTVISIBLE') {
      emit(SnellanTestCompleted(score, calculateVisionAcuity()));
      return;
    } else {
      wrongGuesses++;
    }
    int maxWrongGuesses = getMaxWrongGuessesForRow();
    if (wrongGuesses >= maxWrongGuesses) {
      emit(SnellanTestCompleted(score, calculateVisionAcuity()));
      return;
    }
    subIndex++;
    if (subIndex < check.length) {
      emit(SnellanTestNext(
          snellanList[initialIndex], subIndex, calculateFontSize()));
      await initListening();
    } else {
      initialIndex++;
      subIndex = 0;
      wrongGuesses = 0;
      if (initialIndex < snellanList.length) {
        emit(SnellanTestNext(
            snellanList[initialIndex], subIndex, calculateFontSize()));
        await initListening();
      } else {
        emit(SnellanTestCompleted(score, calculateVisionAcuity()));
      }
    }
  }

  int getMaxWrongGuessesForRow() {
    if (initialIndex <= 2) {
      return 1;
    } else if (initialIndex <= 4) {
      return 2;
    } else {
      return 3;
    }
  }

  Future<void> emitCompleted() async {
    await _speech.stop();
    emit(const SnellanTestCompleted(0, ''));
  }

  double calculateFontSize() {
    const double tanTheta = 0.00145;
    if (initialIndex >= snellanDistances.length) return 16.0;
    double distance = snellanDistances[initialIndex];
    double fontSize = distance * tanTheta * 800;
    return fontSize;
  }

  String calculateVisionAcuity() {
    if (initialIndex >= snellanDistances.length) return "6/6";

    switch (initialIndex) {
      case 0:
        return "6/60";
      case 1:
        return "6/36";
      case 2:
        return "6/24";
      case 3:
        return "6/18";
      case 4:
        return "6/12";
      case 5:
        return "6/9";
      case 6:
        return "6/6";
      case 7:
        return "6/6";
      default:
        return "6/60";
    }
  }
}
