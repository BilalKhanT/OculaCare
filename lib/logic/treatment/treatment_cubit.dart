import 'package:bloc/bloc.dart';
import 'package:cculacare/data/models/disease_result/disease_result_model.dart';
import 'package:cculacare/logic/treatment/treatment_state.dart';

class TreatmentCubit extends Cubit<TreatmentState> {
  TreatmentCubit() : super(TreatmentInitial());

  String selectedOption = 'Left Eye';

  void toggleOption(String val, DiseaseResultModel res) {
    selectedOption = val;
    if (val == 'Left Eye') {
      loadLeftEye(res);
    } else if (val == 'Right Eye') {
      loadRightEye(res);
    } else if (val == 'Bulgy Eyes') {
      loadBulgy(res);
    }
  }

  void loadLeftEye(DiseaseResultModel result) {
    emit(TreatmentInitial());
    emit(TreatmentLeft(result));
  }

  void loadRightEye(DiseaseResultModel result) {
    emit(TreatmentInitial());
    emit(TreatmentRight(result));
  }

  void loadBulgy(DiseaseResultModel result) {
    emit(TreatmentInitial());
    emit(TreatmentBulgy(result));
  }

}
