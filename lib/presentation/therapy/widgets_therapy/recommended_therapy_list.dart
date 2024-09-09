import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../configs/presentation/constants/colors.dart';
import '../../../configs/routes/route_names.dart';

class DiseaseCardList extends StatelessWidget {
  final List<Map<String, String>> diseases = [
    {"name": "Cataracts", "image": "assets/images/cataracts_bg.png"},
    {"name": "Bulgy Eyes", "image": "assets/images/bulgy_eyes_bg.png"},
    {"name": "Crossed Eyes", "image": "assets/images/crossed_eyes_bg.png"},
    {"name": "Pterygium", "image": "assets/images/pterygium_bg.png"},
  ];

  final double screenHeight;
  final double screenWidth;

  DiseaseCardList({super.key, required this.screenHeight, required this.screenWidth});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: screenHeight * 0.22, // Reduced height slightly
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: diseases.length,
          itemBuilder: (context, index) {
            final disease = diseases[index];

            return GestureDetector(
              onTap: () {
                // Navigate to the DiseaseTherapiesScreen when a disease is selected
                context.push(RouteNames.diseaseTherapies, extra: disease['name']);
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 15), // Add more space between containers
                width: screenWidth * 0.45, // Decrease the width slightly
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15.0),
                  image: DecorationImage(
                    image: AssetImage(disease['image']!), // Display disease image as background
                    fit: BoxFit.scaleDown,
                  ),
                ),
                child: Stack(
                  children: [
                    // Disease name positioned at the bottom-right corner
                    Positioned(
                      bottom: 10,
                      right: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.appColor, // Solid color background
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          disease['name']!,
                          style: TextStyle(
                            fontSize: screenWidth * 0.03,
                            fontWeight: FontWeight.bold,
                            color: Colors.white, // White text on solid background
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
