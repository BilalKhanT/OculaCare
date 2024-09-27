import 'package:cculacare/logic/therapy_cubit/therapy_dashboard_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TherapyDashboardCubit extends Cubit<TherapyDashboardStates> {
  TherapyDashboardCubit() : super(TherapyDashboardInitialState());

  void loadInitial() {
    emit(TherapyDashboardInitialState());
  }

  void loadHistory() {
    emit(TherapyDashboardHistoryState());
  }

  void loadProgression() {
    emit(TherapyDashboardProgressionState());
  }
}
