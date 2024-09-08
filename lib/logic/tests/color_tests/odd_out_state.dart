part of 'odd_out_cubit.dart';

enum OddOutStatus { initialLoading, playing, gameOver }

class OddOutState {
  final OddOutStatus status;
  final List<Color> gridColors;
  final int correctIndex;
  final int selectedIndex;
  final int timeLeft;
  final int livesLeft;
  final int score;
  final int questionsAsked;

  OddOutState({
    required this.status,
    required this.gridColors,
    required this.correctIndex,
    required this.selectedIndex,
    required this.timeLeft,
    required this.livesLeft,
    required this.score,
    required this.questionsAsked,
  });

  factory OddOutState.initial() {
    return OddOutState(
      status: OddOutStatus.initialLoading,
      gridColors: List<Color>.filled(16, Colors.transparent),
      correctIndex: -1,
      selectedIndex: -1,
      timeLeft: 10,
      livesLeft: 3,
      score: 0,
      questionsAsked: 0,
    );
  }

  OddOutState copyWith({
    OddOutStatus? status,
    List<Color>? gridColors,
    int? correctIndex,
    int? selectedIndex,
    int? timeLeft,
    int? livesLeft,
    int? score,
    int? questionsAsked,
  }) {
    return OddOutState(
      status: status ?? this.status,
      gridColors: gridColors ?? this.gridColors,
      correctIndex: correctIndex ?? this.correctIndex,
      selectedIndex: selectedIndex ?? this.selectedIndex,
      timeLeft: timeLeft ?? this.timeLeft,
      livesLeft: livesLeft ?? this.livesLeft,
      score: score ?? this.score,
      questionsAsked: questionsAsked ?? this.questionsAsked,
    );
  }
}
