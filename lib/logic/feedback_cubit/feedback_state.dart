import 'package:equatable/equatable.dart';

abstract class FeedbackState extends Equatable {
  const FeedbackState();

  @override
  List<Object> get props => [];
}

class FeedbackInitial extends FeedbackState {}

class FeedbackLoading extends FeedbackState {}

class FeedbackCompleted extends FeedbackState {}

class FeedbackLiked extends FeedbackState {
  final Map<String, bool> selectionStatus;

  const FeedbackLiked(this.selectionStatus);

  @override
  List<Object> get props => [selectionStatus];
}

class FeedbackUnLiked extends FeedbackState {
  final Map<String, bool> selectionStatus;

  const FeedbackUnLiked(this.selectionStatus);

  @override
  List<Object> get props => [selectionStatus];
}

class FeedbackServerError extends FeedbackState {}
