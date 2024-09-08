import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'isihara_cubit.dart';

abstract class RadioBtnState extends Equatable {
  const RadioBtnState();

  @override
  List<Object?> get props => [];
}

class RadioBtnInitial extends RadioBtnState {}

class RadioBtnChanged extends RadioBtnState {}

class RadioBtnCubit extends Cubit<RadioBtnState> {
  RadioBtnCubit() : super(RadioBtnInitial());

  int answer = -1;

  void changeValue(int value, BuildContext context) {
    answer = value;
    context.read<IshiharaCubit>().answerSelected = value;
    emit(RadioBtnInitial());
    emit(RadioBtnChanged());
  }
}
