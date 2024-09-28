import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import '../../../data/repositories/local/preferences/shared_prefs.dart';
import '../../widgets/need_to_setup_profile_widget.dart';
import 'custom_therapy_tile.dart';
import 'therapy_model.dart';

class GeneralEyeExercises extends StatelessWidget {
  final List<Map<String, dynamic>> exercisesList;
  final double screenHeight;
  final double screenWidth;

  const GeneralEyeExercises({
    Key? key,
    required this.exercisesList,
    required this.screenHeight,
    required this.screenWidth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      shrinkWrap: true,
      itemCount: exercisesList.length,
      itemBuilder: (context, index) {
        final therapy = exercisesList[index];
        return FadeIn(
          duration: Duration(
              milliseconds: 1000 + (index * 100)),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 2.0),
            child: TherapyTile(
              therapy: therapy,
              screenHeight: screenHeight,
              onTap: () {
                if (!sharedPrefs.isProfileSetup) {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return const Dialog(child: NeedToSetupProfileWidget());
                    },
                  );
                  return;
                }
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
          ),
        );
      },
    );
  }
}
