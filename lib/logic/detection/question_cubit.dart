import 'package:bloc/bloc.dart';
import '../../data/models/disease_result/question_model.dart';
import 'question_state.dart';

class QuestionCubit extends Cubit<QuestionState> {
  QuestionCubit() : super(QuestionInitial());

  List<Question> questions = [
    Question(
      questionText: "Have you experienced any of the following vision changes?",
      options: [
        "Blurred vision",
        "Double vision",
        "Light sensitivity",
        "No vision issues"
      ],
      relevance: {
        "Cataracts": "Blurred vision",
        "Uveitis": "Light sensitivity",
        "Pterygium": "Double vision",
      },
    ),
    Question(
      questionText: "Have you noticed any of the following in your eyes?",
      options: [
        "Eye redness",
        "Itching or a gritty sensation",
        "Swelling of the conjunctiva",
        "No redness or irritation"
      ],
      relevance: {
        "Uveitis": "Eye redness",
        "Pterygium": "Itching or a gritty sensation",
        "Cataracts": "Swelling of the conjunctiva",
      },
    ),
    Question(
      questionText: "Have you experienced any of the following?",
      options: [
        "Eye discharge",
        "Dry eyes",
        "Halo around lights",
        "No tearing or discharge"
      ],
      relevance: {
        "Uveitis": "Eye discharge",
        "Pterygium": "Dry eyes",
        "Cataracts": "Halo around lights",
      },
    ),
    Question(
      questionText: "Have you felt any pain or discomfort in your eye area?",
      options: [
        "Mild eye pain",
        "Severe eye pain",
        "Eye pressure or heaviness",
        "No pain or discomfort"
      ],
      relevance: {
        "Uveitis": "Severe eye pain",
        "Pterygium": "Mild eye pain",
        "Cataracts": "Eye pressure or heaviness",
      },
    ),
    Question(
      questionText: "Have you experienced any of the following light-related issues?",
      options: [
        "Glare from lights",
        "Sensitivity to light",
        "Difficulty adjusting to bright light",
        "No light issues"
      ],
      relevance: {
        "Cataracts": "Glare from lights",
        "Uveitis": "Sensitivity to light",
        "Pterygium": "Difficulty adjusting to bright light",
      },
    ),
  ];

  void startQuestionnaire() {
    emit(QuestionLoaded(
      questions: questions,
      currentQuestionIndex: 0,
      selectedAnswers: const {},
    ));
  }

  void selectOption(String selectedOption) {
    final currentState = state as QuestionLoaded;
    final question = currentState.questions[currentState.currentQuestionIndex];

    final updatedAnswers = Map<String, String>.from(currentState.selectedAnswers);
    updatedAnswers[question.questionText] = selectedOption;

    if (currentState.currentQuestionIndex < currentState.questions.length - 1) {
      emit(QuestionLoaded(
        questions: currentState.questions,
        currentQuestionIndex: currentState.currentQuestionIndex + 1,
        selectedAnswers: updatedAnswers,
      ));
    } else {
      final result = _determineResult(updatedAnswers);
      emit(QuestionFinished(result: result));
    }
  }

  String _determineResult(Map<String, String> answers) {
    Map<String, int> relevanceCount = {
      "Cataracts": 0,
      "Uveitis": 0,
      "Pterygium": 0,
    };

    for (var question in questions) {
      final answer = answers[question.questionText];
      if (answer != null) {
        question.relevance.forEach((disease, relevantOption) {
          if (relevantOption == answer) {
            relevanceCount[disease] = relevanceCount[disease]! + 1;
          }
        });
      }
    }

    final maxRelevance = relevanceCount.entries.reduce((a, b) => a.value > b.value ? a : b);

    if (maxRelevance.value == 0) {
      return "No model needed";
    }

    return "Call ${maxRelevance.key} model";
  }
}
