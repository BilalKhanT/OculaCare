import 'package:equatable/equatable.dart';

abstract class MoreState extends Equatable {
  @override
  List<Object> get props => [];
}

class MoreStateInitial extends MoreState {}

class MoreStateAnimate extends MoreState {}
