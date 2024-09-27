import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

abstract class ToggleCaptureButtonState extends Equatable {
  @override
  List<Object> get props => [];
}

class ToggleCaptureButtonStateInitial extends ToggleCaptureButtonState {}

class ToggleCaptureButtonStateTrue extends ToggleCaptureButtonState {
  final bool disable;
  final int status;

  ToggleCaptureButtonStateTrue(this.disable, this.status);
}

class ToggleCaptureButtonCubit extends Cubit<ToggleCaptureButtonState> {
  ToggleCaptureButtonCubit() : super(ToggleCaptureButtonStateInitial());

  toggleButton(bool disable, int status) {
    emit(ToggleCaptureButtonStateInitial());
    emit(ToggleCaptureButtonStateTrue(disable, status));
  }
}
