import 'package:bloc/bloc.dart';
import 'package:cculacare/data/repositories/detection/detection_repo.dart';
import 'package:cculacare/data/repositories/local/preferences/shared_prefs.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../configs/global/app_globals.dart';
import '../../data/models/disease_result/disease_result_model.dart';
import 'detection_state.dart';

class DetectionCubit extends Cubit<DetectionState> {
  DetectionCubit() : super(DetectionInitial());

  final DetectionRepo detectionRepo = DetectionRepo();

  Future<void> loadDiseaseResults() async {
    emit(DetectionLoading());
    await Future.delayed(const Duration(seconds: 0));
    try {
      if (globalResults.isEmpty || sharedPrefs.resultsFetched == false) {
        sharedPrefs.resultsFetched = true;
        globalResults.clear();
        List<DiseaseResultModel> diseaseResults = await detectionRepo.getPatientDiseaseResults();
        if (diseaseResults.isEmpty) {
          emit(DetectionServerError());
        } else {
          for (var res in diseaseResults) {
            globalResults.add(res);
          }
          emit(DetectionLoaded(globalResults));
        }
      } else {
        emit(DetectionLoaded(globalResults));
      }
    } catch (e) {
      log(e);
      emit(DetectionServerError());
    }
  }
}
