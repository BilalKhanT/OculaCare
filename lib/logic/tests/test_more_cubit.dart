import 'package:OculaCare/logic/tests/test_more_state.dart';
import 'package:bloc/bloc.dart';

class TestMoreCubit extends Cubit<TestMoreState> {
  TestMoreCubit() : super(TestMoreInitial());

  void toggle(bool flag) {
    emit(TestMoreInitial());
    emit(TestMoreToggled(flag));
  }
}


