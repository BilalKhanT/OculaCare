import 'package:equatable/equatable.dart';

abstract class UserProfileState extends Equatable {
  @override
  List<Object> get props => [];
}

class UserProfileStateInitial extends UserProfileState {}

class UserProfileStateLoading extends UserProfileState {}

class UserProfileStateSetUp extends UserProfileState {}

class UserProfileStateLoaded extends UserProfileState {

}

class UserProfileStateFailure extends UserProfileState {
  final String errorMsg;

  UserProfileStateFailure(this.errorMsg);
}