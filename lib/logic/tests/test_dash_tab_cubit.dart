import 'package:OculaCare/logic/tests/test_dash_tab_state.dart';
import 'package:bloc/bloc.dart';

class TestDashTabCubit extends Cubit<TestDashTabState> {
  TestDashTabCubit() : super(TestDashTabInitial());

  bool testSelected = false;
  bool historySelected = false;
  bool progressionSelected = false;

  void toggleTab(int id) {
    if (id == 0) {
      testSelected = true;
      progressionSelected = false;
      historySelected = false;
    } else if (id == 1) {
      progressionSelected = false;
      testSelected = false;
      historySelected = true;
    } else {
      historySelected = false;
      testSelected = false;
      progressionSelected = true;
    }
    emit(
        TestDashTabToggled(testSelected, historySelected, progressionSelected));
  }
}
