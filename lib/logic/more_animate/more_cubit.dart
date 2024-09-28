import 'package:bloc/bloc.dart';
import 'package:cculacare/logic/more_animate/more_state.dart';

class MoreCubit extends Cubit<MoreState> {
  MoreCubit() : super(MoreStateInitial());

  void emitHomeAnimation() {
    emit(MoreStateAnimate());
  }

  void emitInitial() {
    emit(MoreStateInitial());
  }
}
