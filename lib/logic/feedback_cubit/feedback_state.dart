import 'package:equatable/equatable.dart';

sealed class FeedbackState extends Equatable {
  const FeedbackState();

  @override
  List<Object> get props => [];
}

final class FeedbackInitial extends FeedbackState {}

final class FeedbackLoading extends FeedbackState {}

final class FeedbackCompleted extends FeedbackState {}

final class FeedbackLiked extends FeedbackState {
  final Map<String, bool> selectionStatus;

  const FeedbackLiked(this.selectionStatus);

  @override
  List<Object> get props => [selectionStatus];
}

final class FeedbackUnLiked extends FeedbackState {
  final Map<String, bool> selectionStatus;

  const FeedbackUnLiked(this.selectionStatus);

  @override
  List<Object> get props => [selectionStatus];
}