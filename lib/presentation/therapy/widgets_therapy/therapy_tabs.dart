import 'package:flutter/material.dart';
import '../../../configs/presentation/constants/colors.dart';

class TherapyTabs extends StatelessWidget {
  final bool therapySelected;
  final bool historySelected;
  final bool progressionSelected;
  final Function onSelectTherapy;
  final Function onSelectHistory;
  final Function onSelectProgression;

  const TherapyTabs({
    super.key,
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
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
        child: Row(
          children: [
            _buildTab(context, 'Therapies', therapySelected, onSelectTherapy),
            SizedBox(width: MediaQuery.of(context).size.width * 0.02),
            _buildTab(context, 'History', historySelected, onSelectHistory),
            SizedBox(width: MediaQuery.of(context).size.width * 0.02),
            _buildTab(context, 'Progression', progressionSelected,
                onSelectProgression),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(
      BuildContext context, String title, bool isSelected, Function onTap) {
    return Padding(
      padding: const EdgeInsets.only(left: 5.0),
      child: GestureDetector(
        onTap: () => onTap(),
        child: Container(
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.appColor.withOpacity(0.85)
                : Colors.white,
            borderRadius: BorderRadius.circular(25),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 6.0),
          child: Text(
            title,
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.bold,
              fontSize: MediaQuery.of(context).size.width * 0.04,
              color: isSelected ? AppColors.whiteColor : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
