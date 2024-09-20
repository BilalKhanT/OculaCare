import 'package:equatable/equatable.dart';

abstract class PassState extends Equatable {

  const PassState();

  @override
  List<Object> get props => [];
}

class PassInitial extends PassState {}

class PassLoading extends PassState {}