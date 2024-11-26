import 'package:cculacare/presentation/hospital_locator/widgets/search_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../configs/global/app_globals.dart';
import '../../../configs/presentation/constants/colors.dart';
import '../../../data/models/hospital_locator_model/hospital_model.dart';
import '../../../data/repositories/local/preferences/shared_prefs.dart';
import '../../../logic/hospital_locator_cubit/bookmark_icon_cubit.dart';
import '../../../logic/hospital_locator_cubit/hospital_locator_cubit.dart';
import 'hospital_info_bottom_model.dart';

class MapWithHospitalsWidget extends StatelessWidget {
  final List<Hospital> hospitals;
  final HospitalCubit cubit;

  const MapWithHospitalsWidget({
    Key? key,
    required this.hospitals,
    required this.cubit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final address = sharedPrefs.getAddress();
    final double? lat = address?.lat;
    final double? long = address?.long;

    if (lat == null || long == null) {
      return const Center(child: Text("User location not found."));
    }

    Set<Marker> markers = _buildMarkers(context, hospitals, cubit, lat, long);

    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition:
              CameraPosition(target: LatLng(lat, long), zoom: 16),
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
              Navigator.pop(context);
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

  Set<Marker> _buildMarkers(BuildContext context, List<Hospital> hospitals,
      HospitalCubit cubit, double lat, double long) {
    Set<Marker> markers = hospitals.map((hospital) {
      return Marker(
        markerId: MarkerId(hospital.placeId),
        position: hospital.location,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        infoWindow: InfoWindow(title: hospital.name),
        onTap: () {
          showModalBottomSheet(
            context: context,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            builder: (context) {
              return BlocProvider(
                create: (context) {
                  final bookmarkIconCubit = BookmarkIconCubit();
                  bookmarkIconCubit.initializeIconState(hospital);
                  return bookmarkIconCubit;
                },
                child: HospitalInfoBottomSheet(
                  hospital: hospital,
                  isBookmarked: bookmarks.any((bookmark) => bookmark.placeId == hospital.placeId),
                  onPressed: () {
                    Navigator.pop(context);
                    cubit.startNavigation(
                      lat,
                      long,
                      hospital.location.latitude,
                      hospital.location.longitude,
                      'driving',
                    );
                  },
                ),
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

    return markers;
  }

  Widget _buildCircularButton(
      {required IconData icon, required void Function() onPressed}) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.whiteColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(icon, color: AppColors.appColor),
        onPressed: onPressed,
      ),
    );
  }

  void _showSearchBottomSheet(BuildContext context, HospitalCubit cubit) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SearchBottomSheet(cubit: cubit);
      },
    );
  }

}
