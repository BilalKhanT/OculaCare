import 'package:equatable/equatable.dart';

abstract class ColorMoreState extends Equatable {
  const ColorMoreState();

  @override
  List<Object?> get props => [];
}

class ColorMoreInitial extends ColorMoreState {}

class ColorMoreToggled extends ColorMoreState {
  final bool flag;

  const ColorMoreToggled(this.flag);
}
