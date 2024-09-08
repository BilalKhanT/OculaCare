import 'package:equatable/equatable.dart';

abstract class TestMoreState extends Equatable {
  const TestMoreState();

  @override
  List<Object?> get props => [];
}

class TestMoreInitial extends TestMoreState {}

class TestMoreToggled extends TestMoreState {
  final bool flag;

  const TestMoreToggled(this.flag);
}

