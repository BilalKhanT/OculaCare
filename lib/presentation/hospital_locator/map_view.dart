import 'package:cculacare/data/models/address/address_model.dart';
import 'package:cculacare/presentation/hospital_locator/widgets/map_with_hospital.dart';
import 'package:cculacare/presentation/hospital_locator/widgets/map_with_navigation.dart';
import 'package:cculacare/presentation/widgets/cstm_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../configs/presentation/constants/colors.dart';
import '../../logic/bookmark_cubit/bookmark_cubit.dart';
import '../../logic/hospital_locator_cubit/hospital_locator_cubit.dart';
import '../../logic/hospital_locator_cubit/hospital_locator_states.dart';

class MapView extends StatelessWidget {
  const MapView({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<HospitalCubit>();
    cubit.loadHospitals();
    context.read<BookmarkCubit>().fetchBookmarks();

    return Scaffold(
      backgroundColor: AppColors.screenBackground,
      body: BlocBuilder<HospitalCubit, HospitalState>(
        builder: (context, state) {
          if (state is HospitalLoading) {
            return const Center(
              child: DotLoader(loaderColor: AppColors.appColor),
            );
          } else if (state is HospitalError) {
            return Center(child: Text(state.message));
          } else if (state is HospitalLoaded) {
            return SafeArea(
                child: MapWithHospitalsWidget(
                    hospitals: state.hospital, cubit: cubit, lat: state.lat, long: state.long,));
          } else if (state is HospitalNavigationStarted) {
            return SafeArea(
              child: MapWithNavigationWidget(
                lat: state.lat, long: state.long,
                polylineCoordinates: state.polylineCoordinates,
                cubit: cubit,
                flag: true,
              ),
            );
          }
          return Container();
        },
      ),
    );
  }
}
