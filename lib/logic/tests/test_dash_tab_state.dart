import 'package:equatable/equatable.dart';

sealed class TestDashTabState extends Equatable {
  const TestDashTabState();

  @override
  List<Object> get props => [];
}

final class TestDashTabInitial extends TestDashTabState {}

final class TestDashTabToggled extends TestDashTabState {
  final bool isTest;
  final bool isHistory;
  final bool isProgression;

  const TestDashTabToggled(this.isTest, this.isHistory, this.isProgression);

  @override
  List<Object> get props => [isTest, isHistory, isProgression];
}
