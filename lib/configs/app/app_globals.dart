import 'package:OculaCare/data/models/therapy/therapy_results_model.dart';

import '../../data/models/disease_result/disease_result_model.dart';

class AppGlobals {

}
String ipAddress = 'http://192.168.0.105:8080';
Set<DiseaseResultModel> globalResults = {};
String ipServer= 'https://oculacare-backend.onrender.com';
List <TherapyModel> globalTherapies = [];
Map<DateTime, int> globalTherapyProgressData = {};
Map<String, int> barChartData = {};
Map<String, Map<DateTime, int>> categoryDateTherapyCount = {};
