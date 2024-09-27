import 'package:OculaCare/configs/global/app_globals.dart';
import 'package:OculaCare/data/models/disease_result/disease_result_model.dart';
import 'package:OculaCare/logic/detection/detection_state.dart';
import 'package:bloc/bloc.dart';
import 'package:nb_utils/nb_utils.dart';

class DetectionCubit extends Cubit<DetectionState> {
  DetectionCubit() : super(DetectionInitial());

  var data = [
    {
      "patient_name": "John Doe",
      "date": "2024-09-16",
      "treatment": "Cataract Surgery",
      "causes": "Aging, UV exposure, smoking",
      "medicine_recommendations":
          "Post-surgery: Antibiotic eye drops, Anti-inflammatory eye drops",
      "impacts": "Improved vision, reduced eye strain, brighter colors",
      "precautions":
          "Avoid direct sunlight, wear sunglasses, avoid strenuous activities",
      "left_eye": {
        "prediction": "Mild cataract detected",
        "probability": "70%"
      },
      "right_eye": {
        "prediction": "Moderate cataract detected",
        "probability": "85%"
      }
    },
    {
      "patient_name": "Jane Smith",
      "date": "2024-09-12",
      "treatment": "Pterygium Surgery",
      "causes": "Prolonged exposure to wind and dust",
      "medicine_recommendations":
          "Post-surgery: Steroid eye drops, artificial tears",
      "impacts": "Reduced irritation, improved appearance",
      "precautions":
          "Avoid dusty areas, wear protective eyewear, use lubricating drops",
      "left_eye": {"prediction": "Pterygium detected", "probability": "60%"},
      "right_eye": {"prediction": "No significant issues", "probability": "5%"}
    },
  ];

  Future<void> loadDiseaseResults() async {
    emit(DetectionLoading());
    await Future.delayed(const Duration(seconds: 3));
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
          emit(DetectionLoaded(diseaseResults));
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
