import 'package:animate_do/animate_do.dart';
import 'package:cculacare/presentation/therapy/widgets_therapy/custom_therapy_tile.dart';
import 'package:cculacare/presentation/therapy/widgets_therapy/therapy_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../configs/presentation/constants/colors.dart';
import '../../data/therapies_data/bulgy_eyes.dart';
import '../../data/therapies_data/cataract_therapies.dart';
import '../../data/therapies_data/crossed_eye_therapies.dart';
import '../../data/therapies_data/pterygium_therapies.dart';

class DiseaseTherapiesScreen extends StatelessWidget {
  final String disease;

  const DiseaseTherapiesScreen({super.key, required this.disease});

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> therapies = _getTherapiesForDisease(disease);
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppColors.screenBackground,
      appBar: AppBar(
        title: Text(
          "$disease Therapies",
          style: TextStyle(
            fontFamily: 'MontserratMedium',
            fontWeight: FontWeight.w800,
            fontSize: screenWidth * 0.05,
            color: AppColors.textPrimary,
          ),
        ),
        backgroundColor: AppColors.screenBackground,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.appColor),
          onPressed: () {
            context.pop();
          },
        ),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: FadeInUp(
          duration: const Duration(milliseconds: 600),
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: therapies.length,
            itemBuilder: (context, index) {
              final therapy = therapies[index];
              return FadeIn(
                duration: Duration(milliseconds: 1000 + (index * 100)),
                child: TherapyTile(
                  therapy: therapy,
                  screenHeight: MediaQuery.of(context).size.height,
                  onTap: () {
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
                ),
              );
            },
          ),
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
