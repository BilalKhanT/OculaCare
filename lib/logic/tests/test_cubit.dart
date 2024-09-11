import 'package:OculaCare/configs/global/app_globals.dart';
import 'package:OculaCare/data/models/tests/test_result_model.dart';
import 'package:OculaCare/data/repositories/local/preferences/shared_prefs.dart';
import 'package:OculaCare/data/repositories/tests/test_repo.dart';
import 'package:OculaCare/logic/tests/test_state.dart';
import 'package:bloc/bloc.dart';

class TestCubit extends Cubit<TestState> {
  TestCubit() : super(TestInitial());

  final TestRepository testRepository = TestRepository();

  Future<void> loadTests() async {
    emit(TestLoading());
    emit(TestLoaded());
  }

  Future<void> loadTestHistory() async {
    emit(TestLoading());
    if (testResults.isEmpty) {
      final List<TestResultModel> tests =
          await testRepository.getTestRecords(sharedPrefs.userName);
      for (var test in tests) {
        testResults.add(test);
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
    emit(TestProgression());
  }
}
