import 'package:bloc/bloc.dart';

class TestProgressionCubit extends Cubit<bool> {
  TestProgressionCubit() : super(false);

  String selectedTest = 'Vision Tests';

  void toggleProgression(bool flag) {
    if (flag) {
      selectedTest = 'Color Tests';
    }
    else {
      selectedTest = 'Vision Tests';
    }
    emit(flag);
  }
}