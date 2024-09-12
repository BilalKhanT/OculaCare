import 'dart:async';
import 'package:bloc/bloc.dart';

class TimerCubit extends Cubit<int> {
  Timer? _timer;
  int _remainingTime = 0;
  int _initialTimeLimit = 0;

  TimerCubit() : super(0);

  int get initialTimeLimit => _initialTimeLimit;

  void startTimer(int duration) {
    _initialTimeLimit = duration;
    _remainingTime = duration;
    _timer?.cancel(); // Cancel any existing timer
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        _remainingTime--;
        emit(_remainingTime);
      } else {
        timer.cancel();
        _completeTimer();
      }
    });
  }

  void stopTimer() {
    _timer?.cancel();
  }

  void _completeTimer() {
    emit(0);
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
