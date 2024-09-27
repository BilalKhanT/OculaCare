import 'package:bloc/bloc.dart';
import 'package:cculacare/logic/tests/test_state.dart';
import 'package:intl/intl.dart';

import '../../configs/global/app_globals.dart';
import '../../data/models/tests/test_result_model.dart';
import '../../data/repositories/local/preferences/shared_prefs.dart';
import '../../data/repositories/tests/test_repo.dart';

class TestCubit extends Cubit<TestState> {
  TestCubit() : super(TestInitial());

  final TestRepository testRepository = TestRepository();
  final DateFormat dateFormat = DateFormat('dd-MM-yyyy');

  Future<void> loadTests() async {
    emit(TestLoading());
    emit(TestLoaded());
  }

  Future<void> loadTestHistory() async {
    emit(TestLoading());
    if (testResults.isEmpty || sharedPrefs.historyFetched == false) {
      sharedPrefs.historyFetched = true;
      final List<TestResultModel> tests =
          await testRepository.getTestRecords(sharedPrefs.email);
      for (var test in tests) {
        bool exists = testResults.any((existingTest) =>
            existingTest.patientName == test.patientName &&
            existingTest.date == test.date &&
            existingTest.testName == test.testName &&
            existingTest.testScore == test.testScore &&
            existingTest.precautions == test.precautions);
        if (!exists) {
          testResults.add(test);
        }
      }
    }

    List<TestResultModel> vision = [];
    List<TestResultModel> color = [];

    for (var i in testResults) {
      if (i.testType == 'Color Perception Test') {
        color.add(i);
      } else {
        vision.add(i);
      }
    }
    emit(TestHistory(vision, color));
  }

  Future<void> loadTestProgression() async {
    emit(TestLoading());
    if (testResults.isEmpty || sharedPrefs.historyFetched == false) {
      sharedPrefs.historyFetched = true;
      final List<TestResultModel> tests =
          await testRepository.getTestRecords(sharedPrefs.email);
      for (var test in tests) {
        bool exists = testResults.any((existingTest) =>
            existingTest.patientName == test.patientName &&
            existingTest.date == test.date &&
            existingTest.testName == test.testName &&
            existingTest.testScore == test.testScore &&
            existingTest.precautions == test.precautions);
        if (!exists) {
          testResults.add(test);
        }
      }
    }

    Map<DateTime, int> dateTestCount = {};

    for (var result in testResults) {
      DateTime testDate = dateFormat.parse(result.date);
      dateTestCount.update(testDate, (value) => value + 1, ifAbsent: () => 1);
    }
    emit(TestProgression(dateTestCount));
  }
}
