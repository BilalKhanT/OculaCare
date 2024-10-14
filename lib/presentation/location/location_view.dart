import 'package:cculacare/presentation/location/widget/location_set_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../configs/presentation/constants/colors.dart';
import '../../logic/location_cubit/location_cubit.dart';
import '../../logic/location_cubit/location_state.dart';
import '../widgets/cstm_loader.dart';

class LocationScreen extends StatelessWidget {
  final bool isBook;
  const LocationScreen({Key? key, required this.isBook}) : super(key: key);
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
              return const SizedBox.shrink();
            } else if (state is LocationSet) {
              return LocationSetView(
                position: state.initialPosition,
                userAddress: state.address,
                lat: state.latitude,
                long: state.longitude,
                isBook: isBook,
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
