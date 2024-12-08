import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../configs/presentation/constants/colors.dart';
import '../../../logic/hospital_locator_cubit/hospital_locator_cubit.dart';

class MapWithNavigationWidget extends StatelessWidget {
  final List<LatLng> polylineCoordinates;
  final HospitalCubit cubit;
  final double lat;
  final double long;
  final bool? flag;

  const MapWithNavigationWidget({
    Key? key,
    required this.polylineCoordinates,
    required this.cubit,
    required this.lat,
    required this.long,
    this.flag,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Set<Marker> markers = _buildMarkers(lat, long);
    Set<Polyline> polylines = _buildPolylines();

    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition:
              CameraPosition(target: LatLng(lat, long), zoom: 16),
          onMapCreated: cubit.onMapCreated,
          markers: markers,
          polylines: polylines,
        ),
        Positioned(
          top: 40,
          left: 15,
          child: _buildCircularButton(
            icon: Icons.arrow_back_ios_new,
            onPressed: () {
              if (flag!) {
                context.pop();
              } else {
                cubit.endNavigation();
              }
            },
          ),
        ),
      ],
    );
  }

  Set<Marker> _buildMarkers(double lat, double long) {
    return {
      Marker(
        markerId: const MarkerId('user_location'),
        position: LatLng(lat, long),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        infoWindow: const InfoWindow(title: 'Your Location'),
      ),
    };
  }

  Set<Polyline> _buildPolylines() {
    return {
      Polyline(
        polylineId: const PolylineId("navigation"),
        points: polylineCoordinates,
        color: Colors.blue,
        width: 5,
      ),
    };
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
}
