
import 'package:bloc/bloc.dart';
import 'package:cculacare/logic/tests/vision_tests/snellan_test_state.dart';
import 'package:intl/intl.dart';
import '../../../configs/app/remote/ml_model.dart';
import '../../../configs/global/app_globals.dart';
import '../../../data/models/api_response/response_model.dart';
import '../../../data/models/tests/test_result_model.dart';
import '../../../data/repositories/local/preferences/shared_prefs.dart';
import '../../../data/repositories/tests/test_repo.dart';

class SnellanTestCubit extends Cubit<SnellanTestState> {
  SnellanTestCubit() : super(SnellanTestInitial());

  final TestRepository testRepo = TestRepository();
  int initialIndex = 0;
  int subIndex = 0;
  int score = 0;
  int wrongGuesses = 0;
  MlModel ml = MlModel();
  bool api = false;

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
    ['PR'],
    ['BK', 'LW'],
    ['AF', 'OP', 'GM'],
    ['FP', 'CN', 'LO', 'GR'],
    ['AN', 'GC', 'AB', 'OP', 'ZY'],
    ['NX', 'ZS', 'PJ', 'VN', 'KP', 'AY'],
    ['UK', 'MJ', 'PB', 'NJ', 'PR', 'LP', 'OC'],
    ['IF', 'PV', 'MA', 'KM', 'ZM', 'PG', 'IB', 'OM'],
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
    // await initListening();
  }

  String getCurrentDateString() {
    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat('dd-MM-yyyy');
    String formattedDate = formatter.format(now);
    return formattedDate;
  }

  Future<void> moveNext(String res) async {
    await nextRow(snellanList[initialIndex], res);
  }

  Future<void> nextRow(List<String> check, String res) async {
    String normalizedRecognizedText =
        res.replaceAll(' ', '').toUpperCase();
    if (check.contains(normalizedRecognizedText)) {
      score += 1;
      wrongGuesses = 0;
    } else if (normalizedRecognizedText.replaceAll(' ', '').toUpperCase() ==
        'NOTVISIBLE') {
      emit(SnellanTestAnalysing());
      String fraction = calculateVisionAcuity();
      await endSnellenTest();
      emit(SnellanTestCompleted(score, fraction));
      return;
    } else {
      wrongGuesses++;
    }
    int maxWrongGuesses = getMaxWrongGuessesForRow();
    if (wrongGuesses >= maxWrongGuesses) {
      emit(SnellanTestAnalysing());
      String fraction = calculateVisionAcuity();
      await endSnellenTest();
      emit(SnellanTestCompleted(score, fraction));
      return;
    }
    subIndex++;
    if (subIndex < check.length) {
      emit(SnellanTestNext(
          snellanList[initialIndex], subIndex, calculateFontSize()));
    } else {
      initialIndex++;
      subIndex = 0;
      wrongGuesses = 0;
      if (initialIndex < snellanList.length) {
        emit(SnellanTestNext(
            snellanList[initialIndex], subIndex, calculateFontSize()));
        // await initListening();
      } else {
        emit(SnellanTestAnalysing());
        String fraction = calculateVisionAcuity();
        await endSnellenTest();
        emit(SnellanTestCompleted(score, fraction));
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
    emit(const SnellanTestCompleted(0, ''));
  }

  Future<void> endSnellenTest() async {
    if (api == true) return;
    try {
      api = true;
      String fraction = calculateVisionAcuity();
      ResponseModel response = await ml.getData(
          'The Snellen chart test is a standard eye exam that measures how well you can see at a distance. The patient recently took this test and achieved a visual acuity of $fraction. Please provide a brief analysis in 2 lines of the patient’s visual acuity without a heading. Generate text as if you are talking directly to the patient. Consider if the vision is normal (6/6), slightly reduced (6/9), or progressively worse for lower fractions.');

      ResponseModel resp = await ml.getData(
          'Also, provide recommendations in the form of points (without any heading or subheadings) with only 3 points. Generate text as if you are talking directly to the patient.');

      ResponseModel resp_ = await ml.getData(
          'Additionally, mention any three potential impacts of reduced visual acuity in daily activities in form of points without headings or subheadings. Generate text as if you are talking directly to the patient.');
      String date = getCurrentDateString();
      TestResultModel data = TestResultModel(
          email: sharedPrefs.email,
          patientName: sharedPrefs.userName,
          date: date,
          testType: 'Vision Acuity Test',
          testName: 'Snellan Chart',
          testScore: int.parse(fraction.split('/')[1]),
          resultDescription: response.text,
          recommendation: resp.text,
          precautions: resp_.text);
      await testRepo.addTestRecord(data);
      testResults.add(data);
      api = false;
    } catch (e) {
      api = false;
    }
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
        return "6/6";
    }
  }
}
