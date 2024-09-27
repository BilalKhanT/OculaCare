import 'package:equatable/equatable.dart';

abstract class TherapyFeedbackState extends Equatable {
  const TherapyFeedbackState();

  @override
  List<Object> get props => [];
}

class TherapyFeedbackInitial extends TherapyFeedbackState {}

class TherapyFeedbackLoading extends TherapyFeedbackState {}

class TherapyFeedbackCompleted extends TherapyFeedbackState {}

class TherapyFeedbackLiked extends TherapyFeedbackState {
  final Map<String, bool> selectionStatus;

  const TherapyFeedbackLiked(this.selectionStatus);

  @override
  List<Object> get props => [selectionStatus];
}

class TherapyFeedbackUnLiked extends TherapyFeedbackState {
  final Map<String, bool> selectionStatus;

  const TherapyFeedbackUnLiked(this.selectionStatus);

  @override
  List<Object> get props => [selectionStatus];
}

class TherapyFeedbackServerError extends TherapyFeedbackState {}
