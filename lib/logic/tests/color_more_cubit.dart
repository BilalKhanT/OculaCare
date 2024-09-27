import 'package:bloc/bloc.dart';
import 'color_more_state.dart';

class ColorMoreCubit extends Cubit<ColorMoreState> {
  ColorMoreCubit() : super(ColorMoreInitial());

  void toggle(bool flag) {
    emit(ColorMoreInitial());
    emit(ColorMoreToggled(flag));
  }
}
