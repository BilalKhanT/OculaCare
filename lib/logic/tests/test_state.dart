import 'package:equatable/equatable.dart';

sealed class TestState extends Equatable {
  const TestState();

  @override
  List<Object?> get props => [];
}

class TestInitial extends TestState {}

class TestLoading extends TestState {}

class TestLoaded extends TestState {}

class TestHistory extends TestState {}

class TestProgression extends TestState {}