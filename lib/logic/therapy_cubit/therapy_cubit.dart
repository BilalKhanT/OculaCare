import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:bloc/bloc.dart';
import 'package:intl/intl.dart';
import '../../data/repositories/local/preferences/shared_prefs.dart';
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
  List<Map<String, dynamic>> therapyHistory = [];

  Future<void> loadTherapyHistory(String patientName) async {
    emit(TherapyLoading());
    if (therapyRepository.therapyRecords.isEmpty) {
      final List<Map<String, dynamic>> therapies = await therapyRepository.getTherapyRecords(patientName);
      therapyRepository.therapyRecords.addAll(therapies);
      therapyHistory = List<Map<String, dynamic>>.from(therapyRepository.therapyRecords);
      emit(TherapyHistoryLoaded(therapyRepository.therapyRecords));
    } else {
      therapyHistory = List<Map<String, dynamic>>.from(therapyRepository.therapyRecords);
      emit(TherapyHistoryLoaded(List<Map<String, dynamic>>.from(therapyRepository.therapyRecords)));
    }
  }


  void startTherapy(String title, int timeLimit, List<Map<String, dynamic>> steps, String soundPath) {
    _timerCubit.startTimer(timeLimit * 60);
    _musicCubit.playMusic(soundPath);

    switch (title) {
      case "Jumping Stripes" || "Mirror Eye Stretch":
        _startAnimationTherapy(title, steps);
        break;
      case "Kaleidoscope Focus":
        _startKaleidoscopeTherapy(title, steps);
        break;
      case "Yin-Yang Clarity":
        _startYinYangTherapy(title, steps);
        break;
      case "Eye Rolling":
        _startEyeRollingTherapy(title, steps);
        break;
      case "Figure Eight Focus":
        _startFigureEightTherapy(title, steps);
        break;
      case "Brock String Exercise":
        startBrockStringExercise(title, steps, timeLimit);
        break;
      case "Eye Patch Therapy":
        startEyePatchTherapy(title, steps, timeLimit);
        break;
      default:
        _startStepTherapy(title, steps);
        break;
    }
  }


  void _startYinYangTherapy(String title, List<Map<String, dynamic>> steps) {
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

    // Size and rotation changes
    _animationTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      double scale = random.nextBool() ? 0.8 : 0.4;
      double rotation = random.nextDouble() * 360;
      emit(TherapyYinYangAnimationInProgress(
        therapyTitle: title,
        animationPath: steps[stepIndex]['svgPath'],
        remainingTime: _timerCubit.state,
        scale: scale,
        rotation: rotation,
      ));
    });
  }

  void _startKaleidoscopeTherapy(String title, List<Map<String, dynamic>> steps) {
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
        _completeTherapy(title);
      }
      else if (remainingTime <= (_timerCubit.initialTimeLimit - steps[stepIndex]['duration'])) {
        stepIndex++;

        emit(TherapyLottieAnimationInProgress(
          therapyTitle: title,
          animationPath: steps[stepIndex]['svgPath'],
          remainingTime: remainingTime,
        ));
      }
    });
  }


  void _startEyeRollingTherapy(String title, List<Map<String, dynamic>> steps) {
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
        animationPath: 'assets/images/eye_rolling/eye_rolling',
        remainingTime: (_timerCubit.state - steps[0]['duration']).toInt(),
      ));

      _timerCubit.stream.listen((remainingTime) {
        if (remainingTime <= 0) {
          _completeTherapy(title);
        }
      });
    });
  }
  double _dx = 4;
  double _dy = 4;

  void _startAnimationTherapy(String title, List<Map<String, dynamic>> steps) {
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
        _completeTherapy(title);
      }
    });
  }

  void _moveObject() {
    double screenWidth = 400;
    double screenHeight = 800;

    // Update the object's position based on velocity
    _topPosition += _dy;
    _leftPosition += _dx;

    // Check for collision with the edges of the screen and bounce
    if (_topPosition <= 0 || _topPosition >= screenHeight - 100) {  // Assuming object height is 100
      _dy = -_dy;  // Reverse vertical direction
    }
    if (_leftPosition <= 0 || _leftPosition >= screenWidth - 100) {  // Assuming object width is 100
      _dx = -_dx;  // Reverse horizontal direction
    }
  }






  void _startStepTherapy(String title, List<Map<String, dynamic>> steps) {
    int stepIndex = 0;

    _flutterTts.speak(steps[stepIndex]['instruction']);

    // Emit the first step's state immediately
    emit(TherapyStepInProgress(
      therapyTitle: title,
      instruction: steps[stepIndex]['instruction'],
      svgPath: steps[stepIndex]['svgPath'],
      stepIndex: stepIndex,
      remainingTime: _timerCubit.state,
    ));

    // Listen to timer updates
    _timerCubit.stream.listen((remainingTime) {
      if (remainingTime <= 0) {
        _completeTherapy(title);
      } else if (remainingTime % steps[stepIndex]['duration'] == 0) {
        stepIndex++;
        if (stepIndex < steps.length) {
          _flutterTts.speak(steps[stepIndex]['instruction']);


          print(title);
          // Conditional check for "Distance Gazing" to handle the size change logic
          if (title == "Distance Gazing" && stepIndex == 1) {
            print("here");
            // Step 2 of "Distance Gazing" therapy: emit a state with a smaller size
            emit(TherapyDistanceGazingInProgress(
              therapyTitle: title,
              instruction: steps[stepIndex]['instruction'],
              svgPathFar: steps[stepIndex]['svgPath'],   // No near object at this step
              farSize: 24,  // Small size for the far object
              nearSize: 0,  // No near object
              remainingTime: _timerCubit.state,
            ));
          }
          else if (title == "Focus Shifting" && stepIndex == 2) {
            print("here");
            // Step 2 of "Distance Gazing" therapy: emit a state with a smaller size
            emit(TherapyDistanceGazingInProgress(
              therapyTitle: title,
              instruction: steps[stepIndex]['instruction'],
              svgPathFar: steps[stepIndex]['svgPath'],   // No near object at this step
              farSize: 24,  // Small size for the far object
              nearSize: 0,  // No near object
              remainingTime: _timerCubit.state,
            ));
          }
          else {
            // Default behavior for other therapies or other steps
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


  void _startFigureEightTherapy(String title, List<Map<String, dynamic>> steps) {
    int stepIndex = 0;

    // Speak the first step's instruction
    _flutterTts.speak(steps[stepIndex]['instruction']);

    // Emit the first step's state (with instructions and image)
    emit(TherapyStepInProgress(
      therapyTitle: title,
      instruction: steps[stepIndex]['instruction'],
      svgPath: steps[stepIndex]['svgPath'],
      stepIndex: stepIndex,
      remainingTime: _timerCubit.state,
    ));

    // Wait for the duration of the first step (e.g., 20 seconds) before transitioning to animation
    Timer(Duration(seconds: steps[stepIndex]['duration']), () {
      stepIndex++;  // Move to the next step, which is the Lottie animation

      // Emit state to trigger the Lottie animation
      emit(TherapyLottieAnimationInProgress(
        therapyTitle: title,
        animationPath: steps[stepIndex]['svgPath'],  // Path to the Lottie animation
        remainingTime: (_timerCubit.state - steps[0]['duration']).toInt(),  // Ensure time is adjusted
      ));

      // Continue tracking the remaining time for the animation
      _timerCubit.stream.listen((remainingTime) {
        if (remainingTime <= 0) {
          _completeTherapy(title);  // Complete the therapy when time runs out
        }
      });
    });
  }


// Distance Gazing therapy logic (as discussed earlier)
//   void _startDistanceGazingTherapy(String title, List<Map<String, dynamic>> steps) {
//     int stepIndex = 0;
//
//     // Emit the first step with instruction
//     _flutterTts.speak(steps[stepIndex]['instruction']);
//     emit(TherapyStepInProgress(
//       therapyTitle: title,
//       instruction: steps[stepIndex]['instruction'],
//       svgPath: steps[stepIndex]['svgPath'],
//       stepIndex: stepIndex,
//       remainingTime: _timerCubit.state,
//     ));
//
//     // Listen to the timer updates for step transitions
//     _timerCubit.stream.listen((remainingTime) {
//       if (remainingTime <= 0) {
//         _completeTherapy(title); // Complete therapy
//       } else if (remainingTime <= (_timerCubit.initialTimeLimit - steps[stepIndex]['duration'])) {
//         stepIndex++;
//
//         if (stepIndex == 1) {
//           // Step 2: Show the far object (small size, 24px)
//           emit(TherapyDistanceGazingInProgress(
//             therapyTitle: title,
//             instruction: steps[stepIndex]['instruction'],
//             svgPathFar: steps[stepIndex]['svgPath'],
//             farSize: 24,  // Far object small size
//             nearSize: 0,  // No near object
//             remainingTime: remainingTime,
//           ));
//         } else if (stepIndex == 2) {
//           // Step 3: Show both near (512px) and far (24px) objects
//           emit(TherapyDistanceGazingInProgress(
//             therapyTitle: title,
//             instruction: steps[stepIndex]['instruction'],
//             svgPathFar: 'assets/images/distance_gazing/far.png', // Far object
//             svgPathNear: 'assets/images/distance_gazing/near.png', // Near object
//             farSize: 24,  // Far object small
//             nearSize: 512,  // Near object large
//             remainingTime: remainingTime,
//           ));
//         } else if (stepIndex == 3) {
//           // Step 4: Relax and close eyes, display the final instruction
//           emit(TherapyStepInProgress(
//             therapyTitle: title,
//             instruction: steps[stepIndex]['instruction'],
//             svgPath: steps[stepIndex]['svgPath'], // Close eyes image
//             stepIndex: stepIndex,
//             remainingTime: remainingTime,
//           ));
//         }
//       }
//     });
//   }


  void startBrockStringExercise(String title, List<Map<String, dynamic>> steps, int totalTime) {
    int beadIndex = 0;  // Start with the first bead
    int remainingTime = totalTime * 60; // Convert to seconds
    int instructionTime = steps[0]['duration']; // Get the initial instruction duration
    Timer? beadTimer;  // Declare the beadTimer for bead transitions

    // Emit the first instruction and bead focus
    print('Starting Brock String Therapy');
    _flutterTts.speak(steps[0]['instruction']);
    emit(TherapyBrockStringInProgress(
      therapyTitle: title,
      remainingTime: remainingTime,
      instruction: steps[0]['instruction'],
      svgPath: steps[0]['svgPath'],
      beadIndex: beadIndex, // Focus on the first bead
      beadOpacities: [1.0, 0.2, 0.2], // Nearest bead full opacity, others faded
    ));
    print('Emitted initial state: BeadIndex = $beadIndex, Opacities = [1.0, 0.2, 0.2]');

    // Start a periodic timer for bead transitions
    beadTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      // Reset beadIndex when all beads have been focused on
      if (beadIndex > 2) {
        beadIndex = 0; // Restart the cycle for a smooth experience
      }

      // Determine the bead to focus on based on the current bead index
      List<double> beadOpacities;
      String instruction;
      switch (beadIndex) {
        case 0:
          instruction = "Focus on the red bead";
          beadOpacities = [1.0, 0.2, 0.2];  // Nearest bead full opacity
          break;
        case 1:
          instruction = "Now focus on the yellow bead";
          beadOpacities = [0.2, 1.0, 0.2];  // Middle bead full opacity
          break;
        case 2:
          instruction = "Now focus on the green bead";
          beadOpacities = [0.2, 0.2, 1.0];  // Farthest bead full opacity
          break;
        default:
          print('Invalid beadIndex');
          timer.cancel();
          return;
      }

      // Speak the instruction and emit the state
      print('Speaking: $instruction');
      _flutterTts.speak(instruction);
      emit(TherapyBrockStringInProgress(
        therapyTitle: title,
        remainingTime: remainingTime,
        instruction: instruction,
        svgPath: steps[beadIndex]['svgPath'],
        beadIndex: beadIndex,
        beadOpacities: beadOpacities,
      ));
      print('Emitted state: BeadIndex = $beadIndex, Opacities = $beadOpacities');

      beadIndex++;  // Move to the next bead
    });

    // Continue displaying the beads and remaining time after the bead phase ends
    _timerCubit.startTimer(remainingTime);
    _timerCubit.stream.listen((remainingTime) {
      if (remainingTime <= 0) {
        _completeTherapy(title);  // Complete therapy if time is up
      }
    });

    // Store the bead timer so it can be canceled when therapy stops
    _animationTimer = beadTimer;
    print('Stored animation timer');
  }

  void startMirrorEyeStretch(String title, List<Map<String, dynamic>> steps, int totalTime, double screenWidth, double screenHeight) {
    int stepIndex = 0;
    int remainingTime = totalTime * 60; // Convert to seconds
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
        _completeTherapy(title);
      }
    });
  }


  void startEyePatchTherapy(String title, List<Map<String, dynamic>> steps, int totalTime) {
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

      // Select a random story from the list
      String randomStory = stories[Random().nextInt(stories.length)];
      List<String> characters = randomStory.split('');

      String displayedText = "";
      int charIndex = 0;
      int charDelay = 50;
      Timer.periodic(Duration(milliseconds: charDelay), (timer) {
        if (charIndex < characters.length) {
          displayedText += characters[charIndex];
          charIndex++;

          // Emit the progressively revealed story
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
        _completeTherapy(title);
      }
    });
  }

  void _completeTherapy(String title) async {
    _musicCubit.stopMusic();
    _flutterTts.stop();
    _animationTimer?.cancel();
    _timerCubit.stopTimer();

    // Emit the loading state
    emit(TherapyLoading());

    String formattedDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
    Map<String, dynamic> therapyData = {
      'patient_name': sharedPrefs.userName,
      'date': formattedDate,
      'therapy_type': title,
      'therapy_name': title,
      'duration': _timerCubit.initialTimeLimit - _timerCubit.state,
    };

    bool isSuccess = await therapyRepository.addTherapyRecord(therapyData);

    if (isSuccess) {
      therapyHistory.add(therapyData);
      therapyRepository.therapyRecords.add(therapyData);
      print('After adding new therapy, therapyHistory length: ${therapyHistory.length}');
      print('Updated therapyHistory: $therapyHistory');
      print('Updated therapyRecords in repository: ${therapyRepository.therapyRecords}');
      emit(TherapyHistoryLoaded(therapyRepository.therapyRecords));
      emit(TherapyCompleted(therapyTitle: title));
    } else {
      emit(const TherapySaveError('Failed to save therapy data'));
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
