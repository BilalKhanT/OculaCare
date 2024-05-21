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
    return SizedBox(
      width: MediaQuery.sizeOf(context).width * 0.5,
      height: MediaQuery.sizeOf(context).height * 0.36,
      child: Image.asset(
        model.image,
        width: MediaQuery.sizeOf(context).width * 0.5,
        fit: BoxFit.contain,
      ),
    );
  }
}
