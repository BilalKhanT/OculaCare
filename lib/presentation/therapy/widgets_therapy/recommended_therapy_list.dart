import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../configs/presentation/constants/colors.dart';
import '../../../configs/routes/route_names.dart';
import '../../../data/repositories/local/preferences/shared_prefs.dart';
import '../../widgets/need_to_setup_profile_widget.dart';

class DiseaseCardList extends StatelessWidget {
  final List<Map<String, String>> diseases = [
    {"name": "Cataracts", "image": "assets/images/cataracts_bg.png"},
    {"name": "Bulgy Eyes", "image": "assets/images/bulgy_eyes_bg.png"},
    {"name": "Uveitis", "image": "assets/images/crossed_eyes_bg.png"},
    {"name": "Pterygium", "image": "assets/images/pterygium_bg.png"},
  ];

  final double screenHeight;
  final double screenWidth;

  DiseaseCardList(
      {super.key, required this.screenHeight, required this.screenWidth});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: screenHeight * 0.25,
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: diseases.length,
        itemBuilder: (context, index) {
          final disease = diseases[index];

          return GestureDetector(
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
              context.push(RouteNames.diseaseTherapies, extra: disease['name']);
            },
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 5.0, vertical: 20.0),
              child: Container(
                width: screenWidth * 0.45,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15.0),
                  image: DecorationImage(
                    image: AssetImage(disease['image']!),
                    fit: BoxFit.scaleDown,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.textPrimary.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 0.5,
                      offset: const Offset(0, 0),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    Positioned(
                      bottom: 10,
                      right: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.appColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          disease['name']!,
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            fontSize: MediaQuery.of(context).size.width * 0.03,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
