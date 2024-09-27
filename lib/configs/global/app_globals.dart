import '../../data/models/disease_result/disease_result_model.dart';
import '../../data/models/tests/test_result_model.dart';
import '../../data/models/therapy/therapy_results_model.dart';

class AppGlobals {}

String ipAddress = 'http://192.168.0.105:8080';
String ipServer = 'https://oculacare-backend.onrender.com';
List<DiseaseResultModel> globalResults = [];
List<TherapyModel> globalTherapies = [];
Map<DateTime, int> globalTherapyProgressData = {};
Map<String, int> barChartData = {};
Map<String, Map<DateTime, int>> categoryDateTherapyCount = {};
List<TestResultModel> testResults = [];
int trackLevel = 0;

void clearGlobalDataOnLogout() {
  testResults.clear();
  globalResults.clear();
  globalTherapies.clear();
  globalTherapyProgressData.clear();
  barChartData.clear();
  categoryDateTherapyCount.clear();
}
