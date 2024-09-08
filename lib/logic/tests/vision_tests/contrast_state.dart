import 'package:equatable/equatable.dart';

abstract class ContrastState extends Equatable {
  const ContrastState();

  @override
  List<Object?> get props => [];
}

class ContrastInitial extends ContrastState {}

class ContrastGameInProgress extends ContrastState {}

class ContrastGameOver extends ContrastState {
  final int score;

  const ContrastGameOver(this.score);

  @override
  List<Object?> get props => [score];
}

class ContrastQuestion extends ContrastState {
  final String correctWord;
  final List<String> options;
  final double contrast;

  const ContrastQuestion({
    required this.correctWord,
    required this.options,
    required this.contrast,
  });

  @override
  List<Object?> get props => [correctWord, options, contrast];
}
