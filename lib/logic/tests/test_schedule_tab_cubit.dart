import 'package:OculaCare/logic/tests/test_schedule_tab_state.dart';
import 'package:bloc/bloc.dart';

class ScheduleTabCubit extends Cubit<ScheduleTabState> {
  ScheduleTabCubit() : super(ScheduleTabInitial());

  bool visionSelected = false;
  bool colorSelected = false;

  void toggleTab(int id) {
    if (id == 0) {
      visionSelected = true;
      colorSelected = false;
    } else if (id == 1) {
      visionSelected = false;
      colorSelected = true;
    }
    emit(ScheduleTabToggled(visionSelected, colorSelected));
  }
}