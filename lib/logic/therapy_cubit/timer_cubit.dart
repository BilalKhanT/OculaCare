import 'dart:async';
import 'package:bloc/bloc.dart';

class TimerCubit extends Cubit<int> {
  Timer? _timer;
  int _remainingTime = 0;
  int _initialTimeLimit = 0; // New field to store the initial time limit

  TimerCubit() : super(0);

  // Getter to retrieve the initial time limit
  int get initialTimeLimit => _initialTimeLimit;

  // Start the timer with a given duration
  void startTimer(int duration) {
    _initialTimeLimit = duration;  // Store the initial time limit
    _remainingTime = duration;
    _timer?.cancel(); // Cancel any existing timer
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        _remainingTime--;
        emit(_remainingTime); // Emit remaining time
      } else {
        timer.cancel(); // Stop timer when time runs out
        _completeTimer();
      }
    });
  }

  // Cancel the timer
  void stopTimer() {
    _timer?.cancel();
  }

  // Timer complete logic
  void _completeTimer() {
    emit(0); // Emit final state when timer is complete
  }

  @override
  Future<void> close() {
    _timer?.cancel(); // Ensure timer is cancelled when the cubit is closed
    return super.close();
  }
}
