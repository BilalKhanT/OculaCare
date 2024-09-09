import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:bloc/bloc.dart';
import '../../data/therapies_data/stories.dart';
import 'therapy_state.dart';
import 'timer_cubit.dart';
import 'music_cubit.dart';  // Import the MusicCubit
import 'package:flutter_tts/flutter_tts.dart';

class TherapyCubit extends Cubit<TherapyState> {
  final FlutterTts _flutterTts = FlutterTts();
  final TimerCubit _timerCubit;
  final MusicCubit _musicCubit;  // Add MusicCubit
  Timer? _animationTimer;
  double _topPosition = 0.0;
  double _leftPosition = 0.0;

  TherapyCubit(this._timerCubit, this._musicCubit) : super(TherapyInitial());

  void startTherapy(String title, int timeLimit, List<Map<String, dynamic>> steps, String soundPath) {
    _timerCubit.startTimer(timeLimit * 60); // Start the timer in TimerCubit
    _musicCubit.playMusic(soundPath);  // Start playing music using MusicCubit (no state emission)

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
        startBrockStringExercise(title, steps, timeLimit); // Call your new method here
        break;
      case "Eye Patch Therapy":
        startEyePatchTherapy(title, steps, timeLimit); // Call your new method here
        break;
      default:
        _startStepTherapy(title, steps); // Use default step therapy for others
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
    _flutterTts.speak(steps[stepIndex]['instruction']); // Speak first step instruction

    // Emit initial step progress for the first instruction
    emit(TherapyStepInProgress(
      therapyTitle: title,
      instruction: steps[stepIndex]['instruction'],
      svgPath: steps[stepIndex]['svgPath'],
      stepIndex: stepIndex,
      remainingTime: _timerCubit.state,
    ));


    // Listen for the timer update stream to track remaining time
    _timerCubit.stream.listen((remainingTime) {
      if (remainingTime <= 0) {
        _completeTherapy(title); // Therapy complete
      }
      // Check if it's time to move to the Lottie animation based on the duration of the first step
      else if (remainingTime <= (_timerCubit.initialTimeLimit - steps[stepIndex]['duration'])) {
        // Move to the Lottie animation after the first step completes
        stepIndex++;  // Move to the next step (which is the Lottie animation)

        // Emit the Lottie animation state when step 1 completes
        emit(TherapyLottieAnimationInProgress(
          therapyTitle: title,
          animationPath: steps[stepIndex]['svgPath'], // This is expected to be the Lottie animation path
          remainingTime: remainingTime,
        ));
      }
    });
  }


  void _startEyeRollingTherapy(String title, List<Map<String, dynamic>> steps) {
    int stepIndex = 0;

    // Speak the first step's instruction
    _flutterTts.speak(steps[stepIndex]['instruction']);

    // Emit the first step's state immediately (so the first step doesn't disappear)
    emit(TherapyStepInProgress(
      therapyTitle: title,
      instruction: steps[stepIndex]['instruction'],
      svgPath: steps[stepIndex]['svgPath'],
      stepIndex: stepIndex,
      remainingTime: _timerCubit.state,
    ));

    // Wait for the duration of the first step (e.g., 10 seconds) before showing the Rive animation
    Timer(Duration(seconds: steps[stepIndex]['duration']), () {
      stepIndex++;  // Move to the next step, which is the Rive animation

      // Emit state to trigger the Rive animation for the remaining time
      emit(TherapyRiveAnimationInProgress(
        therapyTitle: title,
        animationPath: 'assets/images/eye_rolling/eye_rolling',  // Path to the Rive animation
        remainingTime: (_timerCubit.state - steps[0]['duration']).toInt(),  // Cast the result to int
      ));

      // Continue with the remaining time for the Rive animation
      _timerCubit.stream.listen((remainingTime) {
        if (remainingTime <= 0) {
          _completeTherapy(title);  // Therapy complete
        }
      });
    });
  }
  double _dx = 2;  // Horizontal velocity
  double _dy = 2;  // Vertical velocity

  void _startAnimationTherapy(String title, List<Map<String, dynamic>> steps) {
    int stepIndex = 0;

    // Speak the instruction for the first step (if any)
    _flutterTts.speak(steps[stepIndex]['instruction']);

    // Emit the first step immediately to avoid any delay
    emit(TherapyStepInProgress(
      therapyTitle: title,
      instruction: steps[stepIndex]['instruction'],
      svgPath: steps[stepIndex]['svgPath'],
      stepIndex: stepIndex,
      remainingTime: _timerCubit.state,
    ));

    // Start object movement animation for "Jumping Stripes"
    _animationTimer = Timer.periodic(const Duration(milliseconds: 16), (timer) {
      _moveObject();  // Move the object like a bouncing ball

      // Emit animation progress with updated positions
      emit(TherapyAnimationInProgress(
        therapyTitle: title,
        remainingTime: _timerCubit.state,
        topPosition: _topPosition,
        leftPosition: _leftPosition,
      ));
    });

    // Listen to the timer to handle therapy completion
    _timerCubit.stream.listen((remainingTime) {
      if (remainingTime <= 0) {
        _completeTherapy(title);
      }
    });
  }

  void _moveObject() {
    // Assuming screen dimensions (adjust to your screen size or use MediaQuery)
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
      const Offset(0.0, 0.0),  // Top-left corner
      const Offset(1.0, 0.0),  // Top-right corner
      const Offset(1.0, 1.0),  // Bottom-right corner
      const Offset(0.0, 1.0),  // Bottom-left corner
    ];
    int currentCorner = 0;
    double dotOpacity = 1.0;
    int fadeDuration = 10; // Time to take for fading out

    // Emit the first step (instruction to cover the eye)
    _flutterTts.speak(steps[0]['instruction']);
    emit(TherapyStepInProgress(
      therapyTitle: title,
      instruction: steps[0]['instruction'],
      svgPath: steps[0]['svgPath'], // Show image only for step 1
      stepIndex: stepIndex,
      remainingTime: remainingTime,
    ));

    // Start the timer for dot transitions after Step 1
    _animationTimer = Timer.periodic(Duration(seconds: fadeDuration), (timer) {
      dotOpacity = 1.0;  // Reset the opacity to 1.0 (full opacity)
      stepIndex++;

      // Emit the state after step 1 without an image
      emit(TherapyMirrorEyeStretchInProgress(
        therapyTitle: title,
        instruction: steps[1]['instruction'],  // Continue instructions
        svgPath: steps[1]['svgPath'],  // No image after step 1
        stepIndex: stepIndex,
        dotPositions: [cornerPositions[currentCorner]],  // Set the container position
        dotOpacity: dotOpacity,
      ));

      // Gradually reduce opacity over the fade duration
      Timer.periodic(const Duration(milliseconds: 1000), (fadeTimer) {
        dotOpacity = max(0.0, dotOpacity - 0.1);  // Reduce opacity gradually ensuring it stays between 0 and 1
        emit(TherapyMirrorEyeStretchInProgress(
          therapyTitle: title,
          instruction: steps[1]['instruction'],
          svgPath: steps[1]['svgPath'],  // No image after step 1
          stepIndex: stepIndex,
          dotPositions: [cornerPositions[currentCorner]],  // Maintain current corner position
          dotOpacity: dotOpacity,
        ));

        if (dotOpacity <= 0.0) {
          fadeTimer.cancel();  // Stop reducing opacity when fully faded
          currentCorner = (currentCorner + 1) % cornerPositions.length;  // Move to the next corner, loop around
        }
      });
    });

    // Start and handle timer completion
    _timerCubit.startTimer(remainingTime);
    _timerCubit.stream.listen((remainingTime) {
      if (remainingTime <= 0) {
        _completeTherapy(title);  // Complete therapy when time runs out
      }
    });
  }


  void startEyePatchTherapy(String title, List<Map<String, dynamic>> steps, int totalTime) {
    int stepIndex = 0;
    int remainingTime = totalTime * 60; // Convert total time to seconds

    // Step 1: Show the first image and instructions
    _flutterTts.speak(steps[stepIndex]['instruction']);
    emit(TherapyStepInProgress(
      therapyTitle: title,
      instruction: steps[stepIndex]['instruction'],
      svgPath: steps[stepIndex]['svgPath'],  // Show image for step 1
      stepIndex: stepIndex,
      remainingTime: remainingTime,
    ));

    // After the duration of step 1, move to step 2
    Timer(Duration(seconds: steps[stepIndex]['duration']), () {
      stepIndex++;  // Move to step 2

      // Select a random story from the list
      String randomStory = stories[Random().nextInt(stories.length)];
      List<String> characters = randomStory.split('');  // Split story into individual characters

      String displayedText = "";  // This will store the progressively revealed story
      int charIndex = 0;  // Index to keep track of current character
      int charDelay = 50;  // Milliseconds delay between each character for smooth animation

      // Timer to reveal each character one by one (typing effect)
      Timer.periodic(Duration(milliseconds: charDelay), (timer) {
        if (charIndex < characters.length) {
          displayedText += characters[charIndex];  // Add the next character to the displayed text
          charIndex++;

          // Emit the progressively revealed story
          emit(TherapyStoryDisplayInProgress(
            therapyTitle: title,
            instruction: steps[stepIndex]['instruction'],
            story: displayedText,  // Emit the progressively revealed story
            remainingTime: _timerCubit.state,
          ));
        } else {
          timer.cancel();  // Stop the timer when all characters are displayed
        }
      });

      // Use TTS to read the story after it's fully displayed
      _flutterTts.speak(randomStory);
    });

    // Start the timer for overall therapy completion
    _timerCubit.startTimer(remainingTime);
    _timerCubit.stream.listen((remainingTime) {
      if (remainingTime <= 0) {
        _completeTherapy(title);  // Complete therapy when time runs out
      }
    });
  }






  void _completeTherapy(String title) {
    _musicCubit.stopMusic();  // Stop the music
    _flutterTts.stop();
    _animationTimer?.cancel();
    _timerCubit.stopTimer();
    emit(TherapyCompleted(therapyTitle: title));
  }

  void stopTherapy() {
    _animationTimer?.cancel(); // Cancel the ongoing bead transition timer
    _flutterTts.stop();        // Stop any ongoing text-to-speech
    _timerCubit.stopTimer();    // Stop the timer
    _musicCubit.stopMusic();    // Stop music
    emit(TherapyInitial());     // Emit initial state
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
