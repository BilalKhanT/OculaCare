import 'package:cculacare/presentation/hospital_locator/widgets/cstm_address_field.dart';
import 'package:cculacare/presentation/hospital_locator/widgets/hospital_info_bottom_model.dart';
import 'package:cculacare/presentation/widgets/cstm_loader.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../configs/presentation/constants/colors.dart';
import '../../data/models/hospital_locator_model/hospital_model.dart';
import '../../data/repositories/local/preferences/shared_prefs.dart';
import '../../logic/hospital_locator_cubit/hospital_locator_cubit.dart';
import '../../logic/hospital_locator_cubit/hospital_locator_states.dart';
import '../widgets/btn_flat.dart';

class MapView extends StatelessWidget {
  const MapView({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<HospitalCubit>();
    cubit.loadHospitals();

    return Scaffold(
      body: BlocBuilder<HospitalCubit, HospitalState>(
        builder: (context, state) {
          if (state is HospitalLoading) {
            return const Center(child: DotLoader(loaderColor: AppColors.appColor,));
          } else if (state is HospitalError) {
            return Center(child: Text(state.message));
          } else if (state is HospitalLoaded) {
            return _buildMapWithHospitals(context, state.hospital, cubit);
          } else if (state is HospitalNavigationStarted) {
            return _buildMapWithNavigation(context, state.polylineCoordinates, cubit);
          }
          return Container();
        },
      ),
    );
  }

  Widget _buildMapWithHospitals(BuildContext context, List<Hospital> hospitals, HospitalCubit cubit) {
    final address = sharedPrefs.getAddress();
    final double? lat = address?.lat;
    final double? long = address?.long;

    if (lat == null || long == null) {
      return const Center(child: Text("User location not found."));
    }

    Set<Marker> markers = hospitals.map((hospital) {
      return Marker(
        markerId: MarkerId(hospital.placeId),
        position: LatLng(hospital.lat, hospital.lon),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        infoWindow: InfoWindow(title: hospital.name),
        onTap: () {
          cubit.setDestination(hospital.displayName);
          showModalBottomSheet(
            context: context,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            builder: (context) {
              return HospitalInfoBottomSheet(
                hospital: hospital,
                isBookmarked: false,
                onPressed: () {
                  cubit.startNavigation(
                    lat,
                    long,
                    hospital.lat,
                    hospital.lon,
                    'driving',
                  );
                },
              );
            },
          );
        },
      );
    }).toSet();

    markers.add(
      Marker(
        markerId: const MarkerId('user_location'),
        position: LatLng(lat, long),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        infoWindow: const InfoWindow(title: 'Your Location'),
      ),
    );

    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: CameraPosition(target: LatLng(lat, long), zoom: 16),
          onMapCreated: cubit.onMapCreated,
          markers: markers,
        ),
        Positioned(
          top: 40,
          left: 15,
          child: _buildCircularButton(
            icon: Icons.arrow_back_ios_new,
            onPressed: () {
              cubit.clearControllers();
              context.pop();
            },
          ),
        ),
        Positioned(
          top: 40,
          right: 15,
          child: _buildCircularButton(
            icon: Icons.search,
            onPressed: () {
              cubit.initializeSourceWithUserLocation();
              _showSearchBottomSheet(context, cubit);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMapWithNavigation(BuildContext context, List<LatLng> polylineCoordinates, HospitalCubit cubit) {
    final address = sharedPrefs.getAddress();
    final double? lat = address?.lat;
    final double? long = address?.long;

    Set<Marker> markers = {
      Marker(
        markerId: const MarkerId('user_location'),
        position: LatLng(lat!, long!),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        infoWindow: const InfoWindow(title: 'Your Location'),
      ),
    };

    Set<Polyline> polylines = {
      Polyline(
        polylineId: const PolylineId("navigation"),
        points: polylineCoordinates,
        color: Colors.blue,
        width: 5,
      ),
    };

    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: CameraPosition(target: LatLng(lat, long), zoom: 16),
          onMapCreated: cubit.onMapCreated,
          markers: markers,
          polylines: polylines,
        ),
        SafeArea(
          child: Stack(
            children: [
              Positioned(
                top: 10,
                left: 15,
                child: _buildCircularButton(
                  icon: Icons.arrow_back_ios_new,
                  onPressed: () {
                    cubit.clearControllers();
                    context.pop();
                  },
                ),
              ),
              Positioned(
                top: 10,
                right: 15,
                child: _buildCircularButton(
                  icon: Icons.search,
                  onPressed: () {
                    cubit.initializeSourceWithUserLocation();
                    _showSearchBottomSheet(context, cubit);
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showSearchBottomSheet(BuildContext context, HospitalCubit cubit) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomInputField(controller: cubit.sourceController, labelText: 'Source',),
              CustomInputField(controller: cubit.destinationController, labelText: 'Destination'),
              const SizedBox(height: 20),
          ButtonFlat(
            btnColor: AppColors.appColor,
            textColor: AppColors.whiteColor,
            onPress: () {
              final source = cubit.sourceController.text.split(", ");
              final destination = cubit.destinationController.text;

              if (source.length == 2 && destination.isNotEmpty) {
                final double sourceLat = double.parse(source[0]);
                final double sourceLong = double.parse(source[1]);

                final destinationParts = destination.split(", ");
                final double destinationLat = double.parse(destinationParts[0]);
                final double destinationLong = double.parse(destinationParts[1]);

                cubit.startNavigation(sourceLat, sourceLong, destinationLat, destinationLong, 'driving');
                Navigator.pop(context);
              } else {
                // Handle invalid input
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Invalid location data")),
                );
              }
            }, // Use the onPressed callback here
            text: "Start Navigation",
          ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCircularButton({required IconData icon, required void Function() onPressed}) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.whiteColor,
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white),
        onPressed: onPressed,
      ),
    );
  }
}
