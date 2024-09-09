import 'package:flutter/material.dart';
import 'package:OculaCare/presentation/therapy/widgets_therapy/custom_therapy_tile.dart';
import 'package:OculaCare/presentation/therapy/widgets_therapy/therapy_model.dart';
import '../../configs/presentation/constants/colors.dart';
import '../../data/therapies_data/bulgy_eyes.dart';
import '../../data/therapies_data/cataract_therapies.dart';
import '../../data/therapies_data/crossed_eye_therapies.dart';
import '../../data/therapies_data/pterygium_therapies.dart';

class DiseaseTherapiesScreen extends StatelessWidget {
  final String disease;

  DiseaseTherapiesScreen({required this.disease});

  @override
  Widget build(BuildContext context) {
    // Get therapies based on disease
    List<Map<String, dynamic>> therapies = _getTherapiesForDisease(disease);

    return Scaffold(
      backgroundColor: AppColors.screenBackground,
      appBar: AppBar(
        title: Text("$disease Therapies"),
        backgroundColor: AppColors.screenBackground,
      ),
      body:
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: therapies.length,
          itemBuilder: (context, index) {
            final therapy = therapies[index];
            return TherapyTile(
              therapy: therapy,
              screenHeight: MediaQuery.of(context).size.height,
              onTap: () {
                // Navigate to play the selected therapy
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  enableDrag: false,
                  isDismissible: false,
                  builder: (BuildContext bc) {
                    return TherapyModel(therapy: therapy);
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _getTherapiesForDisease(String disease) {
    if (disease == "Cataracts") return therapiesCataract;
    if (disease == "Bulgy Eyes") return bulgyEyeTherapies;
    if (disease == "Crossed Eyes") return crossedEyeTherapies;
    if (disease == "Pterygium") return pterygiumTherapies;
    return [];
  }
}