import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:OculaCare/data/models/therapy/therapy_results_model.dart';
import 'package:OculaCare/data/repositories/local/preferences/shared_prefs.dart';
import 'package:bloc/bloc.dart';
import 'package:intl/intl.dart';
import '../../configs/app/app_globals.dart';
import '../../data/repositories/therapy/therapy_repo.dart';
import '../../data/therapies_data/stories.dart';
import 'therapy_state.dart';
import 'timer_cubit.dart';
import 'music_cubit.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TherapyCubit extends Cubit<TherapyState> {
  final FlutterTts _flutterTts = FlutterTts();
  final TimerCubit _timerCubit;
  final MusicCubit _musicCubit;
  Timer? _animationTimer;
  double _topPosition = 0.0;
  double _leftPosition = 0.0;

  TherapyCubit(this._timerCubit, this._musicCubit) : super(TherapyInitial());

  final TherapyRepository therapyRepository = TherapyRepository();

  Future<void> loadTherapyHistory(String patientName) async {
    emit(TherapyLoading());
    try {
      if (globalTherapies.isEmpty || sharedPrefs.therapyFetched == false) {
        globalTherapies.clear();
        sharedPrefs.therapyFetched = true;
        await therapyRepository.getTherapyRecord(patientName);
      }
        emit(TherapyHistoryLoaded(globalTherapies));
    } catch (e) {
      emit(TherapyError(therapyErr: 'Failed to load therapy history: $e'));
    }
  }



  Future<void> mapTherapies(String patientName) async {
    if (globalTherapies.isNotEmpty && globalTherapyProgressData.isNotEmpty && categoryDateTherapyCount.isNotEmpty) {
      emit(TherapyProgressionLoaded(globalTherapyProgressData));
      return;
    }

    emit(TherapyLoading());
    try {
      if (globalTherapies.isEmpty || sharedPrefs.therapyFetched == false) {
        globalTherapies.clear();
        sharedPrefs.therapyFetched = true;
        await therapyRepository.getTherapyRecord(patientName);
      }

      if (globalTherapies.isNotEmpty) {
        globalTherapyProgressData = {};
        categoryDateTherapyCount = {};
        final DateFormat dateFormat = DateFormat('dd-MM-yyyy');

        for (var therapy in globalTherapies) {
          try {
            DateTime date = dateFormat.parse(therapy.date);

            globalTherapyProgressData.update(
              date,
                  (existingDuration) => existingDuration + therapy.duration,
              ifAbsent: () => therapy.duration,
            );
            if (categoryDateTherapyCount.containsKey(therapy.therapyType)) {
              categoryDateTherapyCount[therapy.therapyType]!.update(
                date,
                    (existingCount) => existingCount + 1,
                ifAbsent: () => 1,
              );
            } else {
              categoryDateTherapyCount[therapy.therapyType] = {date: 1};
            }

          } catch (e) {
            print("Error parsing date: ${therapy.date}, Error: $e");
          }
        }
        emit(TherapyProgressionLoaded(globalTherapyProgressData));
      } else {
        emit(const TherapyProgressionLoaded({}));
      }
    } catch (e) {
      emit(TherapyProgressError(therapyProgressErr: 'Failed to load therapy history: $e'));
    }
  }



  void startTherapy(String title, int timeLimit, List<Map<String, dynamic>> steps, String soundPath, String category) {
    _timerCubit.startTimer(timeLimit * 60);
    _musicCubit.playMusic(soundPath);

    switch (title) {
      case "Jumping Stripes" || "Mirror Eye Stretch":
        _startAnimationTherapy(title, steps, category);
        break;
      case "Kaleidoscope Focus":
        _startKaleidoscopeTherapy(title, steps, category);
        break;
      case "Yin-Yang Clarity":
        _startYinYangTherapy(title, steps, category);
        break;
      case "Eye Rolling":
        _startEyeRollingTherapy(title, steps, category);
        break;
      case "Figure Eight Focus":
        _startFigureEightTherapy(title, steps, category);
        break;
      case "Brock String Exercise":
        startBrockStringExercise(title, steps, timeLimit, category);
        break;
      case "Eye Patch Therapy":
        startEyePatchTherapy(title, steps, timeLimit, category);
        break;
      case "Blinking Exercise":
        _startBlinkingExerciseTherapy(title, steps, category);
        break;
      default:
        _startStepTherapy(title, steps, category);
        break;
    }
  }


  void _startBlinkingExerciseTherapy(String title, List<Map<String, dynamic>> steps, String category) {
    int stepIndex = 0;
    Future<void> _playStep(int stepIndex) async {
      if (steps[stepIndex]['svgPath'].endsWith('.json')) {
        emit(TherapyBlinkingAnimationInProgress(
          therapyTitle: title,
          animationPath: steps[stepIndex]['svgPath'],
          instruction: steps[stepIndex]['instruction'],
          remainingTime: _timerCubit.state,
        ));
      } else {
        emit(TherapyStepInProgress(
          therapyTitle: title,
          instruction: steps[stepIndex]['instruction'],
          svgPath: steps[stepIndex]['svgPath'],
          stepIndex: stepIndex,
          remainingTime: _timerCubit.state,
        ));
      }
      await _flutterTts.speak(steps[stepIndex]['instruction']);
      await Future.delayed(Duration(seconds: steps[stepIndex]['duration']));
    }
    Future<void> _executeSteps() async {
      if (stepIndex >= steps.length) {
        _completeTherapy(title, category);
        return;
      }
      await _playStep(stepIndex);
      stepIndex++;
      await _executeSteps();
    }
    _executeSteps();
  }







  void _startYinYangTherapy(String title, List<Map<String, dynamic>> steps, String category) {
    int stepIndex = 0;
    final random = Random();

    _flutterTts.speak(steps[stepIndex]['instruction']);
    emit(TherapyStepInProgress(
      therapyTitle: title,
      instruction: steps[stepIndex]['instruction'],
      svgPath: steps[stepIndex]['svgPath'],
      stepIndex: stepIndex,
      remainingTime: _timerCubit.state,
    ));
    _animationTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      double scale = random.nextBool() ? 0.8 : 0.4;
      double rotation = random.nextDouble() * 360;
      emit(TherapyYinYangAnimationInProgress(
        therapyTitle: title,
        animationPath: steps[stepIndex]['svgPath'],
        instructions: steps[stepIndex]['instruction'],
        remainingTime: _timerCubit.state,
        scale: scale,
        rotation: rotation,
      ));
    });
  }

  void _startKaleidoscopeTherapy(String title, List<Map<String, dynamic>> steps, String category) {
    int stepIndex = 0;
    _flutterTts.speak(steps[stepIndex]['instruction']);
    emit(TherapyStepInProgress(
      therapyTitle: title,
      instruction: steps[stepIndex]['instruction'],
      svgPath: steps[stepIndex]['svgPath'],
      stepIndex: stepIndex,
      remainingTime: _timerCubit.state,
    ));
    _timerCubit.stream.listen((remainingTime) {
      if (remainingTime <= 0) {
        _completeTherapy(title, category);
      }
      else if (remainingTime <= (_timerCubit.initialTimeLimit - steps[stepIndex]['duration'])) {
        stepIndex++;
        emit(TherapyLottieAnimationInProgress(
          therapyTitle: title,
          animationPath: steps[stepIndex]['svgPath'],
          remainingTime: remainingTime,
          instruction: steps[stepIndex]['instruction'],
        ));
      }
    });
  }

  void _startEyeRollingTherapy(String title, List<Map<String, dynamic>> steps, String category) {
    int stepIndex = 0;
    _flutterTts.speak(steps[stepIndex]['instruction']);
    emit(TherapyStepInProgress(
      therapyTitle: title,
      instruction: steps[stepIndex]['instruction'],
      svgPath: steps[stepIndex]['svgPath'],
      stepIndex: stepIndex,
      remainingTime: _timerCubit.state,
    ));
    Timer(Duration(seconds: steps[stepIndex]['duration']), () {
      stepIndex++;
      emit(TherapyRiveAnimationInProgress(
        therapyTitle: title,
        animationPath: 'assets/images/eye_rolling/eyemovement.riv',
        remainingTime: (_timerCubit.state - steps[0]['duration']).toInt(),
      ));
      _timerCubit.stream.listen((remainingTime) {
        if (remainingTime <= 0) {
          _completeTherapy(title, category);
        }
      });
    });
  }
  double _dx = 4;
  double _dy = 4;

  void _startAnimationTherapy(String title, List<Map<String, dynamic>> steps, String category) {
    int stepIndex = 0;
    _flutterTts.speak(steps[stepIndex]['instruction']);
    emit(TherapyStepInProgress(
      therapyTitle: title,
      instruction: steps[stepIndex]['instruction'],
      svgPath: steps[stepIndex]['svgPath'],
      stepIndex: stepIndex,
      remainingTime: _timerCubit.state,
    ));
    _animationTimer = Timer.periodic(const Duration(milliseconds: 16), (timer) {
      _moveObject();
      emit(TherapyAnimationInProgress(
        therapyTitle: title,
        remainingTime: _timerCubit.state,
        topPosition: _topPosition,
        leftPosition: _leftPosition,
      ));
    });
    _timerCubit.stream.listen((remainingTime) {
      if (remainingTime <= 0) {
        _completeTherapy(title, category);
      }
    });
  }

  void _moveObject() {
    double screenWidth = 400;
    double screenHeight = 800;
    _topPosition += _dy;
    _leftPosition += _dx;
    if (_topPosition <= 0 || _topPosition >= screenHeight - 100) {
      _dy = -_dy;
    }
    if (_leftPosition <= 0 || _leftPosition >= screenWidth - 100) {
      _dx = -_dx;
    }
  }

  void _startStepTherapy(String title, List<Map<String, dynamic>> steps, String category) {
    int stepIndex = 0;
    _flutterTts.speak(steps[stepIndex]['instruction']);
    emit(TherapyStepInProgress(
      therapyTitle: title,
      instruction: steps[stepIndex]['instruction'],
      svgPath: steps[stepIndex]['svgPath'],
      stepIndex: stepIndex,
      remainingTime: _timerCubit.state,
    ));
    _timerCubit.stream.listen((remainingTime) {
      if (remainingTime <= 0) {
        _completeTherapy(title, category);
      } else if (remainingTime % steps[stepIndex]['duration'] == 0) {
        stepIndex++;
        if (stepIndex < steps.length) {
          _flutterTts.speak(steps[stepIndex]['instruction']);
          if (title == "Distance Gazing" && (stepIndex == 1 || stepIndex == 5) ) {
            emit(TherapyDistanceGazingInProgress(
              therapyTitle: title,
              instruction: steps[stepIndex]['instruction'],
              svgPathFar: steps[stepIndex]['svgPath'],
              farSize: 24,
              nearSize: 0,
              remainingTime: _timerCubit.state,
            ));
          }
          else if (title == "Focus Shifting" && stepIndex == 2) {
            emit(TherapyDistanceGazingInProgress(
              therapyTitle: title,
              instruction: steps[stepIndex]['instruction'],
              svgPathFar: steps[stepIndex]['svgPath'],
              farSize: 24,
              nearSize: 0,
              remainingTime: _timerCubit.state,
            ));
          }
          else {
            emit(TherapyStepInProgress(
              therapyTitle: title,
              instruction: steps[stepIndex]['instruction'],
              svgPath: steps[stepIndex]['svgPath'],
              stepIndex: stepIndex,
              remainingTime: _timerCubit.state,
            ));
          }
        }
      }
    });
  }


  void _startFigureEightTherapy(String title, List<Map<String, dynamic>> steps, String category) {
    int stepIndex = 0;
    _flutterTts.speak(steps[stepIndex]['instruction']);
    emit(TherapyStepInProgress(
      therapyTitle: title,
      instruction: steps[stepIndex]['instruction'],
      svgPath: steps[stepIndex]['svgPath'],
      stepIndex: stepIndex,
      remainingTime: _timerCubit.state,
    ));
    Timer(Duration(seconds: steps[stepIndex]['duration']), () {
      stepIndex++;
      emit(TherapyLottieAnimationInProgress(
        therapyTitle: title,
        animationPath: steps[stepIndex]['svgPath'],
        remainingTime: (_timerCubit.state - steps[0]['duration']).toInt(),
        instruction: steps[stepIndex]['instruction'],
      ));
      _timerCubit.stream.listen((remainingTime) {
        if (remainingTime <= 0) {
          _completeTherapy(title, category);
        }
      });
    });
  }

  void startBrockStringExercise(String title, List<Map<String, dynamic>> steps, int totalTime, String category) {
    int beadIndex = 0;
    int remainingTime = totalTime * 60;
    Timer? beadTimer;

    _flutterTts.speak(steps[0]['instruction']);
    emit(TherapyBrockStringInProgress(
      therapyTitle: title,
      remainingTime: remainingTime,
      instruction: steps[0]['instruction'],
      svgPath: steps[0]['svgPath'],
      beadIndex: beadIndex,
      beadOpacities: const [1.0, 0.2, 0.2],
    ));

    beadTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      if (beadIndex > 2) {
        beadIndex = 0;
      }
      List<double> beadOpacities;
      String instruction;
      switch (beadIndex) {
        case 0:
          instruction = "Focus on the red bead";
          beadOpacities = [1.0, 0.2, 0.2];
          break;
        case 1:
          instruction = "Now focus on the yellow bead";
          beadOpacities = [0.2, 1.0, 0.2];
          break;
        case 2:
          instruction = "Now focus on the green bead";
          beadOpacities = [0.2, 0.2, 1.0];
          break;
        default:
          timer.cancel();
          return;
      }
      _flutterTts.speak(instruction);
      emit(TherapyBrockStringInProgress(
        therapyTitle: title,
        remainingTime: remainingTime,
        instruction: instruction,
        svgPath: steps[beadIndex]['svgPath'],
        beadIndex: beadIndex,
        beadOpacities: beadOpacities,
      ));
      beadIndex++;
    });

    _timerCubit.startTimer(remainingTime);
    _timerCubit.stream.listen((remainingTime) {
      if (remainingTime <= 0) {
        _completeTherapy(title, category);
      }
    });
    _animationTimer = beadTimer;
  }

  void startMirrorEyeStretch(String title, List<Map<String, dynamic>> steps, int totalTime, double screenWidth, double screenHeight, String category) {
    int stepIndex = 0;
    int remainingTime = totalTime * 60;
    List<Offset> cornerPositions = [
      const Offset(0.0, 0.0),
      const Offset(1.0, 0.0),
      const Offset(1.0, 1.0),
      const Offset(0.0, 1.0),
    ];
    int currentCorner = 0;
    double dotOpacity = 1.0;
    int fadeDuration = 10;

    _flutterTts.speak(steps[0]['instruction']);
    emit(TherapyStepInProgress(
      therapyTitle: title,
      instruction: steps[0]['instruction'],
      svgPath: steps[0]['svgPath'],
      stepIndex: stepIndex,
      remainingTime: remainingTime,
    ));

    _animationTimer = Timer.periodic(Duration(seconds: fadeDuration), (timer) {
      dotOpacity = 1.0;
      stepIndex++;

      emit(TherapyMirrorEyeStretchInProgress(
        therapyTitle: title,
        instruction: steps[1]['instruction'],
        svgPath: steps[1]['svgPath'],
        stepIndex: stepIndex,
        dotPositions: [cornerPositions[currentCorner]],
        dotOpacity: dotOpacity,
      ));

      Timer.periodic(const Duration(milliseconds: 1000), (fadeTimer) {
        dotOpacity = max(0.0, dotOpacity - 0.1);
        emit(TherapyMirrorEyeStretchInProgress(
          therapyTitle: title,
          instruction: steps[1]['instruction'],
          svgPath: steps[1]['svgPath'],
          stepIndex: stepIndex,
          dotPositions: [cornerPositions[currentCorner]],
          dotOpacity: dotOpacity,
        ));

        if (dotOpacity <= 0.0) {
          fadeTimer.cancel();
          currentCorner = (currentCorner + 1) % cornerPositions.length;
        }
      });
    });

    _timerCubit.startTimer(remainingTime);
    _timerCubit.stream.listen((remainingTime) {
      if (remainingTime <= 0) {
        _completeTherapy(title, category);
      }
    });
  }


  void startEyePatchTherapy(String title, List<Map<String, dynamic>> steps, int totalTime, String category) {
    int stepIndex = 0;
    int remainingTime = totalTime * 60;

    _flutterTts.speak(steps[stepIndex]['instruction']);
    emit(TherapyStepInProgress(
      therapyTitle: title,
      instruction: steps[stepIndex]['instruction'],
      svgPath: steps[stepIndex]['svgPath'],
      stepIndex: stepIndex,
      remainingTime: remainingTime,
    ));

    Timer(Duration(seconds: steps[stepIndex]['duration']), () {
      stepIndex++;

      String randomStory = stories[Random().nextInt(stories.length)];
      List<String> characters = randomStory.split('');

      String displayedText = "";
      int charIndex = 0;
      int charDelay = 50;
      Timer.periodic(Duration(milliseconds: charDelay), (timer) {
        if (charIndex < characters.length) {
          displayedText += characters[charIndex];
          charIndex++;

          emit(TherapyStoryDisplayInProgress(
            therapyTitle: title,
            instruction: steps[stepIndex]['instruction'],
            story: displayedText,
            remainingTime: _timerCubit.state,
          ));
        } else {
          timer.cancel();
        }
      });
      _flutterTts.speak(randomStory);
    });
    _timerCubit.startTimer(remainingTime);
    _timerCubit.stream.listen((remainingTime) {
      if (remainingTime <= 0) {
        _completeTherapy(title, category);
      }
    });
  }

  void _completeTherapy(String title, String category) async {
    _musicCubit.stopMusic();
    _flutterTts.stop();
    _animationTimer?.cancel();
    _timerCubit.stopTimer();

    emit(TherapyLoading());

    String formattedDate = DateFormat('dd-MM-yyyy').format(DateTime.now());

    TherapyModel newTherapy = TherapyModel(
      email: sharedPrefs.email,
      patientName: sharedPrefs.userName,
      date: formattedDate,
      therapyType: category,
      therapyName: title,
      duration: _timerCubit.initialTimeLimit - _timerCubit.state,
    );
    Map<String, dynamic> therapyData = newTherapy.toJson();

    try {
      bool isSaved = await therapyRepository.addTherapyRecord(therapyData);

      if (isSaved) {
        globalTherapies.add(newTherapy);
        emit(TherapyHistoryLoaded(globalTherapies));
        emit(TherapyProgressionLoaded(globalTherapyProgressData));
        emit(TherapyCompleted(therapyTitle: title, therapyModel: newTherapy));
      } else {
        emit(const TherapyError(therapyErr: 'Failed to save therapy'));
      }
    } catch (e) {
      emit(const TherapyError(therapyErr: 'Error saving therapy'));
    }
  }



  void stopTherapy() {
    _animationTimer?.cancel();
    _flutterTts.stop();
    _timerCubit.stopTimer();
    _musicCubit.stopMusic();
    emit(TherapyInitial());
  }


  void resetTherapy() {
    emit(TherapyInitial());
  }

  @override
  Future<void> close() {
    _animationTimer?.cancel();
    return super.close();
  }
}
