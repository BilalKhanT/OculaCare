import 'package:bloc/bloc.dart';
import 'package:cculacare/logic/home_cubit/home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeStateInitial());

  void emitHomeAnimation() {
    emit(HomeStateAnimate());
  }

  void emitInitial() {
    emit(HomeStateInitial());
  }
}
