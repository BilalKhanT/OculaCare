import 'package:OculaCare/configs/app/remote/ml_model.dart';
import 'package:OculaCare/data/repositories/tests/test_repo.dart';
import 'package:OculaCare/logic/tests/vision_tests/animal_track_score_state.dart';
import 'package:bloc/bloc.dart';

class AnimalTrackScoreCubit extends Cubit<AnimalTrackScoreState> {
  AnimalTrackScoreCubit() : super(AnimalTrackScoreInitial());

  TestRepository testRepo = TestRepository();
  MlModel ml = MlModel();

  void emitInitial() {
    emit(AnimalTrackScoreInitial());
  }

  Future<void> analyseTrackScore() async {

  }
}