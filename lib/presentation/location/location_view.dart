import 'package:OculaCare/configs/presentation/constants/colors.dart';
import 'package:OculaCare/presentation/location/widget/location_set_view.dart';
import 'package:OculaCare/presentation/widgets/cstm_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../configs/routes/route_names.dart';
import '../../logic/location_cubit/location_cubit.dart';
import '../../logic/location_cubit/location_state.dart';

class LocationScreen extends StatelessWidget {
  const LocationScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.screenBackground,
      appBar: AppBar(
        backgroundColor: AppColors.screenBackground,
        leading: IconButton(
            onPressed: () {
              context.pop();
            },
            icon: const Icon(
              Icons.arrow_back_ios_new,
              size: 30,
              color: AppColors.appColor,
            )),
        title: const Text(
          'Address',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'MontserratMedium',
          ),
        ),
      ),
      body: SafeArea(
        child: BlocBuilder<LocationCubit, LocationState>(
          builder: (context, state) {
            if (state is LocationLoading) {
              return const Center(
                child: DotLoader(loaderColor: AppColors.appColor),
              );
            } else if (state is LocationError) {
              return Center(
                child: Text(
                  state.message,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                  ),
                ),
              );
            } else if (state is LocationLoaded) {
              final marker = Marker(
                markerId: const MarkerId('currentLocation'),
                position:
                    LatLng(state.position.latitude, state.position.longitude),
              );
              return const SizedBox.shrink();
            } else if (state is LocationSet) {
              return LocationSetView(
                position: state.initialPosition,
                userAddress: state.address,
                lat: state.latitude,
                long: state.longitude,
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
