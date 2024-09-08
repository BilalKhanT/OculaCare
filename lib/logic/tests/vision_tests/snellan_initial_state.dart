import 'package:equatable/equatable.dart';

abstract class SnellanInitialState extends Equatable {
  const SnellanInitialState();

  @override
  List<Object?> get props => [];
}

class SnellanInitial extends SnellanInitialState {}

class SnellanInitialLoading extends SnellanInitialState {}

class SnellanInitialCompleted extends SnellanInitialState {}