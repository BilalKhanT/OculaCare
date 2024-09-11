import 'package:OculaCare/configs/app/remote/ml_model.dart';
import 'package:OculaCare/configs/global/app_globals.dart';
import 'package:OculaCare/data/repositories/tests/test_repo.dart';
import 'package:OculaCare/logic/tests/vision_tests/animal_track_score_state.dart';
import 'package:bloc/bloc.dart';
import 'package:intl/intl.dart';

import '../../../data/models/api_response/response_model.dart';
import '../../../data/models/tests/test_result_model.dart';
import '../../../data/repositories/local/preferences/shared_prefs.dart';

class AnimalTrackScoreCubit extends Cubit<AnimalTrackScoreState> {
  AnimalTrackScoreCubit() : super(AnimalTrackScoreInitial());

  TestRepository testRepo = TestRepository();
  MlModel ml = MlModel();
  bool api = false;

  void emitInitial() {
    emit(AnimalTrackScoreLoading());
    emit(AnimalTrackScoreInitial());
  }

  String getCurrentDateString() {
    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat('dd-MM-yyyy');
    String formattedDate = formatter.format(now);
    return formattedDate;
  }

  Future<void> analyseTrackScore(int score1, int score2, int score3) async {
    try {
      int totalScore = score1 + score2 + score3;
      if (api == false) {
        api = true;
        String analysis = determineVisionAcuity(totalScore);
        ResponseModel recommendation = await ml.getData(
            'The vision tracking test measures the ability to follow a moving object at different speeds and sizes. The test has three levels of difficulty, and each level gets progressively harder. The patient completed this test and result was $analysis, provide three recommendations to help the patient improve their vision tracking ability, write these points as if you are speaking directly to the patient, without any headings or subheadings just point.');
        ResponseModel impact = await ml.getData(
            'Now provide three potential impacts that this level of vision tracking ability might have on the patient’s daily activities. provide three impacts only, write them as if you are directly advising the patient, without adding any headings or subheadings just points.');
        String date = getCurrentDateString();
        TestResultModel data = TestResultModel(
            patientName: sharedPrefs.userName,
            date: date,
            testType: 'Vision Acuity Test',
            testName: 'Animal Track',
            testScore: score1 + score2 + score3,
            resultDescription: analysis,
            recommendation: recommendation.text,
            precautions: impact.text);
        await testRepo.addTestRecord(data);
        testResults.add(data);
        api = false;
      }
      emit(AnimalTrackScoreLoading());
      emit(AnimalTrackScoreLoaded());
    }
    catch (e) {
      api = false;
      emit(AnimalTrackScoreLoading());
      emit(AnimalTrackScoreLoaded());
    }
  }

  String determineVisionAcuity(int totalScore) {
    if (totalScore >= 50) {
      return "Excellent Vision Acuity: You have excellent vision tracking skills across all difficulty levels.";
    } else if (totalScore >= 40) {
      return "Good Vision Acuity: You have good vision tracking skills. You might struggle a bit at higher difficulties.";
    } else if (totalScore >= 25) {
      return "Average Vision Acuity: Your vision tracking skills are average. Higher speeds and smaller sizes are challenging.";
    } else if (totalScore >= 10) {
      return "Below Average Vision Acuity: You might have difficulty tracking moving objects at higher speeds and smaller sizes.";
    } else {
      return "Poor Vision Acuity: You have significant difficulty tracking moving objects. Consider consulting an eye specialist.";
    }
  }
}
