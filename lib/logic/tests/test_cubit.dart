import 'package:OculaCare/logic/tests/test_state.dart';
import 'package:bloc/bloc.dart';

class TestCubit extends Cubit<TestState> {
  TestCubit() : super(TestInitial());

  Future<void> loadTests() async {
    emit(TestLoading());
    emit(TestLoaded());
  }

  Future<void> loadTestHistory() async {
    emit(TestLoading());
    await Future.delayed(const Duration(seconds: 4));
    emit(TestHistory());
  }

  Future<void> loadTestProgression() async {
    emit(TestLoading());
    emit(TestProgression());
  }
}