import 'package:flutter/material.dart';

import '../../onboarding/data_onboarding/content_model.dart';

class EducationWidgetHomeView extends StatelessWidget {
  const EducationWidgetHomeView({
    super.key,
    required this.model,
  });
  final EducationModel model;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: Container(
        width: MediaQuery.sizeOf(context).width * 0.5,
        height: MediaQuery.sizeOf(context).height * 0.36,
        decoration: BoxDecoration(
          color: Colors.transparent,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Image.asset(
          model.image,
          width: MediaQuery.sizeOf(context).width * 0.5,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
