import 'package:equatable/equatable.dart';
import '../../data/models/disease_result/question_model.dart';

abstract class QuestionState extends Equatable {
  const QuestionState();

  @override
  List<Object?> get props => [];
}

class QuestionInitial extends QuestionState {}

class QuestionLoaded extends QuestionState {
  final List<Question> questions;
  final int currentQuestionIndex;
  final Map<String, String> selectedAnswers;

  const QuestionLoaded({
    required this.questions,
    required this.currentQuestionIndex,
    required this.selectedAnswers,
  });

  @override
  List<Object?> get props => [questions, currentQuestionIndex, selectedAnswers];
}

class QuestionFinished extends QuestionState {
  final String result;

  const QuestionFinished({required this.result});

  @override
  List<Object?> get props => [result];
}
