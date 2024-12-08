import 'package:flutter/material.dart';

import '../../../configs/presentation/constants/colors.dart';
import '../../../logic/hospital_locator_cubit/hospital_locator_cubit.dart';
import '../../widgets/btn_flat.dart';

class SearchBottomSheet extends StatelessWidget {
  final HospitalCubit cubit;

  const SearchBottomSheet({Key? key, required this.cubit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: cubit.sourceController,
            decoration: const InputDecoration(labelText: 'Source'),
          ),
          TextField(
            controller: cubit.destinationController,
            decoration: const InputDecoration(labelText: 'Destination'),
          ),
          const SizedBox(height: 20),
          ButtonFlat(
            btnColor: AppColors.appColor,
            textColor: AppColors.screenBackground,
            onPress: () {
              final source = cubit.sourceController.text.split(", ");
              final destination = cubit.destinationController.text;

              if (source.length == 2 && destination.isNotEmpty) {
                final double sourceLat = double.parse(source[0]);
                final double sourceLong = double.parse(source[1]);

                final destinationParts = destination.split(", ");
                final double destinationLat = double.parse(destinationParts[0]);
                final double destinationLong =
                    double.parse(destinationParts[1]);

                cubit.startNavigation(sourceLat, sourceLong, destinationLat,
                    destinationLong, 'driving');
                Navigator.pop(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Invalid location data")),
                );
              }
            },
            text: 'Start Navigation',
          ),
        ],
      ),
    );
  }
}
