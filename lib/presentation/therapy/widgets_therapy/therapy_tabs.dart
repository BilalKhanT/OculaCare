import 'package:flutter/material.dart';

import '../../../configs/presentation/constants/colors.dart';

class TherapyTabs extends StatelessWidget {
  final bool therapySelected;
  final bool historySelected;
  final bool progressionSelected;
  final Function onSelectTherapy;
  final Function onSelectHistory;
  final Function onSelectProgression;

  TherapyTabs({
    required this.therapySelected,
    required this.historySelected,
    required this.progressionSelected,
    required this.onSelectTherapy,
    required this.onSelectHistory,
    required this.onSelectProgression,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildTab(context, 'Therapies', therapySelected, onSelectTherapy),
          SizedBox(width: MediaQuery.of(context).size.height * 0.035),
          _buildTab(context, 'History', historySelected, onSelectHistory),
          SizedBox(width: MediaQuery.of(context).size.height * 0.035),
          _buildTab(context, 'Progression', progressionSelected, onSelectProgression),
        ],
      ),
    );
  }

  Widget _buildTab(BuildContext context, String title, bool isSelected, Function onTap) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? AppColors.appColor : Colors.transparent,
              width: 4.0,
            ),
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 1.0),
        child: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: MediaQuery.of(context).size.width * 0.045,
            color: isSelected ? AppColors.appColor : Colors.black,
          ),
        ),
      ),
    );
  }
}
