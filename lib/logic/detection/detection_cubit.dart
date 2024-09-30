import 'package:bloc/bloc.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../configs/global/app_globals.dart';
import '../../data/models/disease_result/disease_result_model.dart';
import 'detection_state.dart';

class DetectionCubit extends Cubit<DetectionState> {
  DetectionCubit() : super(DetectionInitial());

  var data = [
    {
      "patient_name": "John Doe",
      "email": 'hehe',
      "date": "2024-09-16",
      "treatment1": "Cataract Surgery",
      "precaution1":
          "Avoid direct sunlight, wear sunglasses, avoid strenuous activities",
      "left_eye": {"prediction": "Normal", "probability": "70%"},
      "right_eye": {"prediction": "Cataracts Detected", "probability": "85%"}
    },
    {
      "patient_name": "Jane Smith",
      "email": 'hehe',
      "date": "2024-09-12",
      "treatment1": "Pterygium Surgery",
      "precaution1":
          "Avoid dusty areas, wear protective eyewear, use lubricating drops",
      "treatment2": "Pterygium Surgery",
      "precaution2":
      "Avoid dusty areas, wear protective eyewear, use lubricating drops",
      "left_eye": {"prediction": "Pterygium Detected", "probability": "60%"},
      "right_eye": {"prediction": "Uveitis Detected", "probability": "5%"},
      "bulgy": {"prediction": "Bulgy Eyes Detected", "probability": "85%"},
    },
  ];

  Future<void> loadDiseaseResults() async {
    emit(DetectionLoading());
    await Future.delayed(const Duration(seconds: 0));
    try {
      if (globalResults.isEmpty) {
        List<DiseaseResultModel> diseaseResults =
            data.map((data) => DiseaseResultModel.fromJson(data)).toList();
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
