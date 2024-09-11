import 'package:OculaCare/logic/tests/test_progression_state.dart';
import 'package:bloc/bloc.dart';
import 'package:intl/intl.dart';

import '../../configs/global/app_globals.dart';

class TestProgressionCubit extends Cubit<TestProgressionState> {
  TestProgressionCubit() : super(TestProgressionInitial());

  String selectedTest = 'Snellan Chart';

  void toggleProgression(String testName) {
    String test = '';
    if (testName == 'Contrast Test') {
      test = 'Contrast Sensitivity';
    } else {
      test = testName;
    }
    selectedTest = testName;
    Map<DateTime, double> scores = {};
    final DateFormat dateFormat = DateFormat('dd-MM-yyyy');

    for (var t in testResults.where((t) => t.testName == test)) {
      DateTime testDate = dateFormat.parse(t.date);
      scores[testDate] = t.testScore.toDouble();
    }
    emit(TestProgressionToggled(scores));
  }
}
