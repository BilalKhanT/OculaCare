import 'package:cculacare/presentation/hospital_locator/widgets/cstm_searchbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../configs/global/app_globals.dart';
import '../../../data/models/hospital_locator_model/hospital_model.dart';
import '../../../logic/hospital_locator_cubit/Search_visibility_cubit.dart';
import '../../../logic/hospital_locator_cubit/bookmark_icon_cubit.dart';
import '../../../logic/hospital_locator_cubit/hospital_locator_cubit.dart';
import '../../../logic/hospital_locator_cubit/search_visibility_state.dart';
import 'hospital_info_bottom_model.dart';

class MapWithHospitalsWidget extends StatelessWidget {
  final List<Hospital> hospitals;
  final HospitalCubit cubit;
  final double lat;
  final double long;

  const MapWithHospitalsWidget({
    Key? key,
    required this.hospitals,
    required this.cubit,
    required this.lat,
    required this.long,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition:
              CameraPosition(target: LatLng(lat, long), zoom: 16),
          onMapCreated: cubit.onMapCreated,
          markers: _buildMarkers(context, hospitals, cubit, lat, long),
        ),
        Positioned(
          top: 40,
          left: 0,
          right: 0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              BlocBuilder<SearchVisibilityCubit, SearchVisibilityState>(
                builder: (context, state) {
                  return CustomSearchBar(
                    controller: context
                        .read<SearchVisibilityCubit>()
                        .searchQueryController,
                    hintText: "Search Hospitals",
                    onChanged: (query) {
                      if (query.isEmpty) {
                        context.read<SearchVisibilityCubit>().hide();
                      } else {
                        context.read<SearchVisibilityCubit>().show();
                        context
                            .read<SearchVisibilityCubit>()
                            .filterHospitals(query, hospitals);
                      }
                    },
                  );
                },
              ),
              BlocBuilder<SearchVisibilityCubit, SearchVisibilityState>(
                builder: (context, state) {
                  if (state is SearchVisibleState ||
                      state is SearchingState ||
                      state is SearchingSuccessState) {
                    final filteredHospitals = state is SearchingSuccessState
                        ? state.filteredHospitals
                        : [];
                    return Visibility(
                      visible: true,
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20.0),
                        padding: const EdgeInsets.all(10.0),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                        ),
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: filteredHospitals.length,
                          itemBuilder: (context, index) {
                            final hospital = filteredHospitals[index];
                            return ListTile(
                              title: Text(
                                hospital.name,
                                style: const TextStyle(
                                  fontFamily: 'MontserratMedium',
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              onTap: () {
                                context
                                    .read<SearchVisibilityCubit>()
                                    .searchQueryController
                                    .clear();
                                context.read<SearchVisibilityCubit>().hide();
                                showModalBottomSheet(
                                  context: context,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(20),
                                    ),
                                  ),
                                  builder: (context) {
                                    return BlocProvider(
                                      create: (context) => BookmarkIconCubit()
                                        ..initializeIconState(hospital),
                                      child: HospitalInfoBottomSheet(
                                        hospital: hospital,
                                        isBookmarked: bookmarks.any(
                                            (bookmark) =>
                                                bookmark.placeId ==
                                                hospital.placeId),
                                        onPressed: () {
                                          context.pop();
                                          cubit.startNavigation(
                                            lat,
                                            long,
                                            hospital.location.latitude,
                                            hospital.location.longitude,
                                            'driving',
                                          );
                                        },
                                        onStart: () {
                                          context.pop();
                                          context
                                              .read<HospitalCubit>()
                                              .navigateToLocation(
                                                  hospital.location.latitude,
                                                  hospital.location.longitude);
                                        },
                                      ),
                                    );
                                  },
                                );
                              },
                            );
                          },
                        ),
                      ),
                    );
                  }
                  return const SizedBox();
                },
              ),
            ],
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
                create: (context) =>
                    BookmarkIconCubit()..initializeIconState(hospital),
                child: HospitalInfoBottomSheet(
                  hospital: hospital,
                  isBookmarked: bookmarks
                      .any((bookmark) => bookmark.placeId == hospital.placeId),
                  onPressed: () {
                    context.pop();
                    cubit.startNavigation(
                      lat,
                      long,
                      hospital.location.latitude,
                      hospital.location.longitude,
                      'driving',
                    );
                  },
                  onStart: () {
                    context.pop();
                    context.read<HospitalCubit>().navigateToLocation(
                        hospital.location.latitude,
                        hospital.location.longitude);
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
}
