import 'package:cculacare/logic/address_book/address_book_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../configs/presentation/constants/colors.dart';
import '../../../logic/location_cubit/location_cubit.dart';
import '../../../logic/patient_profile/patient_profile_cubit.dart';

class LocationSetView extends StatelessWidget {
  final LatLng position;
  final String userAddress;
  final double lat;
  final double long;
  final bool isBook;
  const LocationSetView(
      {super.key,
      required this.position,
      required this.userAddress,
      required this.lat,
      required this.long,
      required this.isBook});

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
          child: Icon(Icons.location_pin, size: 40, color: AppColors.appColor),
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
                  Center(
                    child: GestureDetector(
                      onTap: () async {
                        if (isBook) {
                          context
                              .read<AddressBookCubit>()
                              .addressController
                              .text = userAddress;
                          await context
                              .read<AddressBookCubit>()
                              .setCoordinates(lat, long);
                          if (context.mounted) {
                            context
                                .read<AddressBookCubit>().addAddress();
                            context.pop();
                          }
                        }
                        else {
                          context
                              .read<PatientProfileCubit>()
                              .addressController
                              .text = userAddress;
                          context
                              .read<PatientProfileCubit>()
                              .updateAddressController
                              .text = userAddress;
                          await context
                              .read<PatientProfileCubit>()
                              .setCoordinates(lat, long);
                          if (context.mounted) {
                            context.pop();
                          }
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            color: AppColors.appColor),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 15.0, horizontal: 50.0),
                          child: Text(
                            'Add Address',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
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
