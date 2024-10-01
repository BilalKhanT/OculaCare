import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

import '../../data/models/disease_result/disease_result_model.dart';
import '../../data/models/tests/test_result_model.dart';
import '../../data/models/therapy/therapy_results_model.dart';

class AppGlobals {}
String ipServer = dotenv.env['SERVER_IP'] ?? '';
String flask = dotenv.env['FLASK'] ?? '';
List<DiseaseResultModel> globalResults = [];
List<TherapyModel> globalTherapies = [];
Map<DateTime, int> globalTherapyProgressData = {};
Map<String, int> barChartData = {};
Map<String, Map<DateTime, int>> categoryDateTherapyCount = {};
List<TestResultModel> testResults = [];
int trackLevel = 0;
InputImage? faceImage;
bool isHome = true;
bool isMore = false;

void clearGlobalDataOnLogout() {
  testResults.clear();
  globalResults.clear();
  globalTherapies.clear();
  globalTherapyProgressData.clear();
  barChartData.clear();
  categoryDateTherapyCount.clear();
}
