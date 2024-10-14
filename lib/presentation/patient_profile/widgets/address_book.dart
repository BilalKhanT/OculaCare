import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../configs/presentation/constants/colors.dart';
import '../../../configs/routes/route_names.dart';
import '../../../logic/location_cubit/location_cubit.dart';
import '../../widgets/btn_flat.dart';

class AddressBook extends StatelessWidget {
  const AddressBook({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.sizeOf(context).height;
    double screenWidth = MediaQuery.sizeOf(context).width;
    return Scaffold(
      backgroundColor: AppColors.screenBackground,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: const Icon(
            Icons.arrow_back_ios_new_outlined,
            color: AppColors.appColor,
          ),
        ),
        backgroundColor: AppColors.screenBackground,
        title: Text(
          'Address Book',
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'MontserratMedium',
            fontWeight: FontWeight.w800,
            fontSize: screenWidth * 0.05,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(child: Container()),
              SizedBox(
                height: screenHeight * 0.05,
              ),
              ButtonFlat(
                  btnColor: AppColors.appColor,
                  textColor: AppColors.whiteColor,
                  onPress: () {
                    context
                        .read<LocationCubit>()
                        .setLocation();
                    context.push(RouteNames.locationRoute, extra: true);
                  },
                  text: 'Add new address'),
            ],
          ),
        ),
      ),
    );
  }
}
