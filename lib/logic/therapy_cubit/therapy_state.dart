import 'dart:ui';
import 'package:OculaCare/data/models/therapy/therapy_results_model.dart';
import 'package:equatable/equatable.dart';

abstract class TherapyState extends Equatable {
  const TherapyState();

  @override
  List<Object> get props => [];
}

class TherapyInitial extends TherapyState {}

class TherapyLoading extends TherapyState {
  @override
  List<Object> get props => [];
}

class TherapyHistoryLoaded extends TherapyState {
  final List<TherapyModel> therapyHistory;

  const TherapyHistoryLoaded(this.therapyHistory);

  @override
  List<Object> get props => [therapyHistory];
}


class TherapySaved extends TherapyState {}

class TherapySaveError extends TherapyState {
  final String message;
  const TherapySaveError(this.message);
}

class TherapyStepInProgress extends TherapyState {
  final String therapyTitle;
  final String instruction;
  final String svgPath;
  final int stepIndex;
  final int remainingTime;

  const TherapyStepInProgress({
    required this.therapyTitle,
    required this.instruction,
    required this.svgPath,
    required this.stepIndex,
    required this.remainingTime,
  });

  @override
  List<Object> get props => [therapyTitle, instruction, svgPath, stepIndex, remainingTime];
}

class TherapyTimerUpdate extends TherapyState {
  final int remainingTime;

  const TherapyTimerUpdate(this.remainingTime);

  @override
  List<Object> get props => [remainingTime];
}

class TherapyAnimationInProgress extends TherapyState {
  final String therapyTitle;
  final int remainingTime;
  final double topPosition;
  final double leftPosition;

  const TherapyAnimationInProgress({
    required this.therapyTitle,
    required this.remainingTime,
    required this.topPosition,
    required this.leftPosition,
  });

  @override
  List<Object> get props => [therapyTitle, remainingTime, topPosition, leftPosition];
}

class TherapyDistanceGazingInProgress extends TherapyState {
  final String therapyTitle;
  final String instruction;
  final String svgPathFar;
  final double farSize;
  final double nearSize;
  final int remainingTime;

  const TherapyDistanceGazingInProgress({
    required this.therapyTitle,
    required this.instruction,
    required this.svgPathFar,
    required this.farSize,
    required this.nearSize,
    required this.remainingTime,
  });

  @override
  List<Object> get props => [therapyTitle, instruction, svgPathFar, farSize, nearSize, remainingTime];
}

class TherapyLottieAnimationInProgress extends TherapyState {
  final String therapyTitle;
  final int remainingTime;
  final String animationPath;
  final String instruction;

  const TherapyLottieAnimationInProgress({
    required this.therapyTitle,
    required this.remainingTime,
    required this.animationPath,
    required this.instruction,
  });

  @override
  List<Object> get props => [therapyTitle, remainingTime, animationPath, instruction];
}

class TherapyYinYangAnimationInProgress extends TherapyState {
  final String therapyTitle;
  final int remainingTime;
  final String instructions;
  final String animationPath;
  final double scale;
  final double rotation;

  const TherapyYinYangAnimationInProgress({
    required this.therapyTitle,
    required this.remainingTime,
    required this.instructions,
    required this.animationPath,
    required this.scale,
    required this.rotation,
  });

  @override
  List<Object> get props => [therapyTitle, remainingTime, instructions, animationPath, scale, rotation];
}

class TherapyRiveAnimationInProgress extends TherapyState {
  final String therapyTitle;
  final String animationPath;
  final int remainingTime;

  const TherapyRiveAnimationInProgress({
    required this.therapyTitle,
    required this.animationPath,
    required this.remainingTime,
  });

  @override
  List<Object> get props => [therapyTitle, animationPath, remainingTime];
}

class TherapyBrockStringInProgress extends TherapyState {
  final String therapyTitle;
  final int remainingTime;
  final String instruction;
  final String svgPath;
  final int beadIndex;
  final List<double> beadOpacities;

  const TherapyBrockStringInProgress({
    required this.therapyTitle,
    required this.remainingTime,
    required this.instruction,
    required this.svgPath,
    required this.beadIndex,
    required this.beadOpacities,
  });

  @override
  List<Object> get props => [
    therapyTitle,
    remainingTime,
    instruction,
    svgPath,
    beadIndex,
    beadOpacities,
  ];
}

class TherapyMirrorEyeStretchInProgress extends TherapyState {
  final String therapyTitle;
  final String instruction;
  final String svgPath;
  final int stepIndex;
  final List<Offset> dotPositions;
  final double dotOpacity;

  const TherapyMirrorEyeStretchInProgress({
    required this.therapyTitle,
    required this.instruction,
    required this.svgPath,
    required this.stepIndex,
    required this.dotPositions,
    required this.dotOpacity,
  });

  @override
  List<Object> get props => [
    therapyTitle,
    instruction,
    svgPath,
    stepIndex,
    dotPositions,
    dotOpacity,
  ];
}

class TherapyStoryDisplayInProgress extends TherapyState {
  final String therapyTitle;
  final String instruction;
  final String story;
  final int remainingTime;

  const TherapyStoryDisplayInProgress({
    required this.therapyTitle,
    required this.instruction,
    required this.story,
    required this.remainingTime,
  });

  @override
  List<Object> get props => [therapyTitle, instruction, story, remainingTime];
}


class TherapyBlinkingAnimationInProgress extends TherapyState {
  final String therapyTitle;
  final String animationPath;
  final String instruction;
  final int remainingTime;

  const TherapyBlinkingAnimationInProgress({
    required this.therapyTitle,
    required this.animationPath,
    required this.instruction,
    required this.remainingTime,
  });
}

class TherapyProgressionInitial extends TherapyState {}

class TherapyProgressionLoaded extends TherapyState {
  final Map<DateTime, int> therapyProgressData;

  const TherapyProgressionLoaded(this.therapyProgressData);

  @override
  List<Object> get props => [therapyProgressData];
}


class TherapyProgressError extends TherapyState {
  final String therapyProgressErr;

  const TherapyProgressError({required this.therapyProgressErr});

  @override
  List<Object> get props => [therapyProgressErr];
}

class TherapyHistoryError extends TherapyState {
  final String errorMessage;

  const TherapyHistoryError(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

class TherapyError extends TherapyState {
  final String therapyErr;

  const TherapyError({required this.therapyErr});

  @override
  List<Object> get props => [therapyErr];
}


class TherapyCompleted extends TherapyState {
  final String therapyTitle;

  const TherapyCompleted({required this.therapyTitle});

  @override
  List<Object> get props => [therapyTitle];
}
