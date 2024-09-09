import 'package:OculaCare/data/models/tests/test_result_model.dart';
import 'package:OculaCare/data/repositories/local/preferences/shared_prefs.dart';
import 'package:OculaCare/data/repositories/tests/test_repo.dart';
import 'package:OculaCare/logic/tests/test_state.dart';
import 'package:bloc/bloc.dart';

class TestCubit extends Cubit<TestState> {
  TestCubit() : super(TestInitial());

  final TestRepository testRepository = TestRepository();
  List<TestResultModel> testHistory = [];

  Future<void> loadTests() async {
    emit(TestLoading());
    emit(TestLoaded());
  }

  Future<void> loadTestHistory() async {
    emit(TestLoading());
    if (testHistory.isEmpty) {
      final List<TestResultModel> tests = await testRepository.getTestRecords(sharedPrefs.userName);
      for (var test in tests) {
        testHistory.add(test);
      }
      emit(TestHistory(tests));
    }
    else {
      emit(TestHistory(testHistory));
    }
  }

  Future<void> loadTestProgression() async {
    emit(TestLoading());
    emit(TestProgression());
  }
}