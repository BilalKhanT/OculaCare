import 'package:bloc/bloc.dart';
import 'package:cculacare/logic/tests/test_more_state.dart';

class TestMoreCubit extends Cubit<TestMoreState> {
  TestMoreCubit() : super(TestMoreInitial());

  void toggle(bool flag) {
    emit(TestMoreInitial());
    emit(TestMoreToggled(flag));
  }
}
