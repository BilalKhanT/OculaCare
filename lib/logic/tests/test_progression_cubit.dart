import 'package:bloc/bloc.dart';
import 'package:cculacare/logic/tests/test_progression_state.dart';
import 'package:intl/intl.dart';

import '../../configs/global/app_globals.dart';

class TestProgressionCubit extends Cubit<TestProgressionState> {
  TestProgressionCubit() : super(TestProgressionInitial());

  String selectedTest = 'Snellan Chart';

  void toggleProgression(String testName) {
    String test = '';
    selectedTest = testName;
    if (testName == 'Contrast Test') {
      test = 'Contrast Sensitivity';
    } else {
      test = testName;
    }
    Map<DateTime, double> scores = {};
    final DateFormat dateFormat = DateFormat('dd-MM-yyyy');
    final filteredResults = testResults
        .where((t) => t.testName == test)
        .toList()
      ..sort((a, b) =>
          dateFormat.parse(a.date).compareTo(dateFormat.parse(b.date)));

    for (var t in filteredResults) {
      DateTime testDate = dateFormat.parse(t.date);
      scores[testDate] = t.testScore.toDouble();
    }

    emit(TestProgressionToggled(scores));
  }
}
