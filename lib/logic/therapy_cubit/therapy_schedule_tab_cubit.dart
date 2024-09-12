import 'package:bloc/bloc.dart';
import 'therapy_schedule_tab_state.dart';

class TherapyScheduleTabCubit extends Cubit<TherapyScheduleTabState> {
  TherapyScheduleTabCubit() : super(TherapyScheduleTabInitial());

  bool generalSelected = false;
  bool diseaseSpecificSelected = false;

  void toggleTab(int id) {
    if (id == 0) {
      generalSelected = true;
      diseaseSpecificSelected = false;
    } else if (id == 1) {
      generalSelected = false;
      diseaseSpecificSelected = true;
    }
    emit(TherapyScheduleTabToggled(generalSelected, diseaseSpecificSelected));
  }
}
