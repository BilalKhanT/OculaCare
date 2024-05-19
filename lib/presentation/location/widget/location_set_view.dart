import 'package:OculaCare/configs/presentation/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../logic/location_cubit/location_cubit.dart';

class LocationSetView extends StatelessWidget {
  final LatLng position;
  final String userAddress;
  const LocationSetView(
      {super.key,
        required this.position,
        required this.userAddress});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    return Stack(
      children: <Widget>[
        GoogleMap(
          onMapCreated: (GoogleMapController controller) {
            context.read<LocationCubit>().setMapController(controller);
          },
          initialCameraPosition: CameraPosition(
            target: position,
            zoom: 15.0,
          ),
          myLocationButtonEnabled: true,
          myLocationEnabled: true,
          onCameraMove: (position) {
            context.read<LocationCubit>().currentMarkerPosition = position;
          },
          onCameraIdle: () {
            context.read<LocationCubit>().updateMapState();
          },
        ),
        const Center(
          child: Icon(Icons.location_pin,
              size: 40, color: Color(0xFFed5a23)), // Floating marker
        ),
        Positioned(
          bottom: 20,
          left: 20,
          right: 20,
          child: Container(
            width: width,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Selected Address',
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700,
                      fontSize: MediaQuery.of(context).size.width * 0.05,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Text(
                    userAddress,
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                      fontSize: MediaQuery.of(context).size.width * 0.04,
                    ),
                  ),
                  const SizedBox(
                    height: 30.0,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        color: AppColors.appColor),
                    child: const Padding(
                      padding:
                      EdgeInsets.symmetric(vertical: 15.0, horizontal: 50.0),
                      child: Text(
                        'Save Address',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}