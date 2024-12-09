import 'package:cculacare/data/models/disease_result/qa_model.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/disease_result/question_model.dart';

abstract class QuestionState extends Equatable {
  const QuestionState();

  @override
  List<Object?> get props => [];
}

class QuestionInitial extends QuestionState {}

class QuestionLoading extends QuestionState {}

class QuestionLoaded extends QuestionState {
  final String question;

  const QuestionLoaded({
    required this.question,
  });

  @override
  List<Object?> get props => [question];
}

class QuestionFinished extends QuestionState {
  final QaResponse result;

  const QuestionFinished({required this.result});

  @override
  List<Object?> get props => [result];
}

class QuestionError extends QuestionState {}
