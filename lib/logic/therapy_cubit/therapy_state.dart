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

// State specific to Distance Gazing for different image sizes and positions
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

  const TherapyLottieAnimationInProgress({
    required this.therapyTitle,
    required this.remainingTime,
    required this.animationPath,
  });

  @override
  List<Object> get props => [therapyTitle, remainingTime, animationPath];
}

class TherapyYinYangAnimationInProgress extends TherapyState {
  final String therapyTitle;
  final int remainingTime;
  final String animationPath;
  final double scale;
  final double rotation;

  const TherapyYinYangAnimationInProgress({
    required this.therapyTitle,
    required this.remainingTime,
    required this.animationPath,
    required this.scale,
    required this.rotation,
  });

  @override
  List<Object> get props => [therapyTitle, remainingTime, animationPath, scale, rotation];
}

class TherapyRiveAnimationInProgress extends TherapyState {
  final String therapyTitle;
  final String animationPath;  // Path to the Rive animation
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
  final List<double> beadOpacities;  // Opacity for each bead

  const TherapyBrockStringInProgress({
    required this.therapyTitle,
    required this.remainingTime,
    required this.instruction,
    required this.svgPath,
    required this.beadIndex,
    required this.beadOpacities,  // Add bead opacities to the constructor
  });

  @override
  List<Object> get props => [
    therapyTitle,
    remainingTime,
    instruction,
    svgPath,
    beadIndex,
    beadOpacities,  // Ensure beadOpacities is included in props for equality checks
  ];
}

class TherapyMirrorEyeStretchInProgress extends TherapyState {
  final String therapyTitle;
  final String instruction;
  final String svgPath;
  final int stepIndex;
  final List<Offset> dotPositions;  // List of dot positions (corners)
  final double dotOpacity;  // Dot opacity for fading effect

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
  final String story;  // The randomly selected story
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
