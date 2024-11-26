import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../configs/presentation/constants/colors.dart';
import '../../../data/repositories/local/preferences/shared_prefs.dart';
import '../../../logic/hospital_locator_cubit/hospital_locator_cubit.dart';

class MapWithNavigationWidget extends StatelessWidget {
  final List<LatLng> polylineCoordinates;
  final HospitalCubit cubit;

  const MapWithNavigationWidget({
    Key? key,
    required this.polylineCoordinates,
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

    Set<Marker> markers = _buildMarkers(lat, long);
    Set<Polyline> polylines = _buildPolylines();

    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: CameraPosition(target: LatLng(lat, long), zoom: 16),
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
              cubit.endNavigation();
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

  Widget _buildCircularButton({required IconData icon, required void Function() onPressed}) {
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
              ElevatedButton(
                onPressed: () {
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
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Invalid location data")),
                    );
                  }
                },
                child: const Text("Start Navigation"),
              ),
            ],
          ),
        );
      },
    );
  }
}
