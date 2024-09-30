import 'package:bloc/bloc.dart';
import 'package:cculacare/data/models/disease_result/medicine_model.dart';
import 'package:cculacare/logic/detection/med_state.dart';

class MedCubit extends Cubit<MedState> {
  MedCubit() : super(MedInitial());

  final List<List<MedicineModel>> medData = [
    //Cataracts
    [
      MedicineModel(
        image: 'assets/images/cat1.png',
        name: 'N-Acetylcarnosine',
        dosage: '1-2 drops in each eye, 2-3 times a day',
        usage:
            'Helps in delaying cataract progression by reducing oxidative stress on the lens',
        duration: 6,
      ),
      MedicineModel(
        image: 'assets/images/cat2.png',
        name: 'Vitamin C Supplements',
        dosage: '500 mg per day',
        usage:
            'Helps to reduce the risk of cataract development by protecting the lens from free radical damage',
        duration: 3,
      ),
      MedicineModel(
        image: 'assets/images/cat3.png',
        name: 'Zeaxanthin Supplements',
        dosage: '2 mg of zeaxanthin per day',
        usage:
            'Helps to protect eye against the formation of cataracts',
        duration: 6,
      ),
    ],
    //Pterygium
    [
      MedicineModel(
        image: 'assets/images/pet1.png',
        name: 'Artificial Tears',
        dosage: '1-2 drops in the affected eye(s) as needed',
        usage:
            'Lubricating eye drops can help alleviate dryness and irritation associated with pterygium',
        duration: 1,
      ),
      MedicineModel(
        image: 'assets/images/pet2.png',
        name: 'Loteprednol Etabonate',
        dosage:
            '1 drop in the affected eye(s) 2-4 times a day for a week or two, then tapered down',
        usage:
            'A mild steroid used to reduce inflammation and redness in the eye',
        duration: 2,
      ),
      MedicineModel(
        image: 'assets/images/pet3.png',
        name: 'Cyclosporine A Eye Drops',
        dosage: '1 drop in the affected eye(s) twice a day',
        usage:
            'Reduces inflammation and improve tear production, especially when dryness is a major symptom',
        duration: 6,
      ),
    ],
    //Uveitis
    [
      MedicineModel(
        image: 'assets/images/uv1.png',
        name: 'Prednisolone Acetate',
        dosage: '1 drop in the affected eye(s) 4-6 times daily',
        usage: 'A corticosteroid used to reduce inflammation within the eye',
        duration: 3,
      ),
      MedicineModel(
        image: 'assets/images/uv2.png',
        name: 'Cyclopentolate',
        dosage: '1 drop in the affected eye(s) 3-4 times daily',
        usage:
            'Helps to reduce pain and prevent synechiae by dilating the pupil',
        duration: 1,
      ),
      MedicineModel(
        image: 'assets/images/uv3.png',
        name: 'Methotrexate',
        dosage: '7.5-25 mg orally once a week',
        usage:
            'Suppresses the immune system and control inflammation',
        duration: 3,
      ),
    ],
    //Bulgy
    [
      MedicineModel(
        image: 'assets/images/bul1.png',
        name: 'Prednisone',
        dosage: 'Typically 20-40 mg orally per day',
        usage:
            'Reduces inflammation and swelling, alleviating the bulging caused by thyroid eye disease',
        duration: 2,
      ),
      MedicineModel(
        image: 'assets/images/bul2.png',
        name: 'Selenium Supplements',
        dosage: '100-200 mcg per day',
        usage: 'Reduces oxidative stress and improve the eye condition',
        duration: 6,
      ),
      MedicineModel(
        image: 'assets/images/eye_drop.png',
        name: 'Orbital Decongestants',
        dosage: '1 drop in the affected eye(s) twice daily',
        usage:
            'Reduces redness, swelling, and pressure in the eyes, providing symptomatic relief',
        duration: 2,
      ),
    ],
  ];

  Future<void> emitToggled(int index, int subIndex) async {
    emit(MedLoading());
    await Future.delayed(const Duration(milliseconds: 50));
    emit(MedInitial());
    emit(MedToggled(medData[index][subIndex], subIndex));
  }
}
