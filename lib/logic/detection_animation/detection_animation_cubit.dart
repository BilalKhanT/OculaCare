import 'package:bloc/bloc.dart';
import 'package:cculacare/logic/detection_animation/detection_animation_state.dart';

class DetectionAnimationCubit extends Cubit<DetectionAnimationState> {
  DetectionAnimationCubit() : super(DetectionAnimationStateInitial());

  void emitHomeAnimation() {
    emit(DetectionAnimationStateAnimate());
  }

  void emitInitial() {
    emit(DetectionAnimationStateInitial());
  }
}
