import 'package:animate_do/animate_do.dart';
import 'package:cculacare/configs/routes/route_names.dart';
import 'package:cculacare/data/models/address/address_model.dart';
import 'package:cculacare/data/repositories/local/preferences/shared_prefs.dart';
import 'package:cculacare/logic/hospital_locator_cubit/hospital_locator_cubit.dart';
import 'package:cculacare/presentation/bookmarks/widgets/cstm_bookmark_tile_widget.dart';
import 'package:cculacare/presentation/bookmarks/widgets/cstm_bottom_bookmark_info_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';
import '../../configs/global/app_globals.dart';
import '../../configs/presentation/constants/colors.dart';
import '../../logic/bookmark_cubit/bookmark_cubit.dart';
import '../../logic/bookmark_cubit/bookmark_states.dart';

class BookmarkView extends StatelessWidget {
  const BookmarkView({super.key});

  @override
  Widget build(BuildContext context) {
    final bookmarkCubit = context.read<BookmarkCubit>();
    double screenWidth = MediaQuery.sizeOf(context).width;
    double screenHeight = MediaQuery.sizeOf(context).height;
    bookmarkCubit.fetchBookmarks();

    return Scaffold(
      backgroundColor: AppColors.screenBackground,
      appBar: AppBar(
        backgroundColor: AppColors.screenBackground,
        centerTitle: true,
        title: Text(
          'Saved Hospitals',
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'MontserratMedium',
            fontWeight: FontWeight.w800,
            fontSize: screenWidth * 0.05,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: AppColors.appColor,
            size: 30.0,
          ),
        ),
      ),
      body: BlocBuilder<BookmarkCubit, BookmarkState>(
        builder: (context, state) {
          if (state is BookmarkLoading) {
            return ListView.builder(
              itemCount: 6,
              itemBuilder: (context, index) => Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
                child: Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.15,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                ),
              ),
            );
          } else if (state is BookmarkLoaded) {
            return state.bookmark.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: ListView.builder(
                      itemCount: bookmarks.length,
                      itemBuilder: (context, index) {
                        final bookmark = bookmarks[index];
                        return CstmBookmarkTile(
                          bookmark: bookmark,
                          onDelete: () {
                            bookmarkCubit.deleteBookmark(
                                sharedPrefs.email, bookmark.placeId);
                          },
                          onNavigate: () {
                            showModalBottomSheet(
                              context: context,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20)),
                              ),
                              builder: (context) {
                                return BookmarkInfoBottomSheet(
                                  bookmark: bookmark,
                                  onPressed: () async {
                                    Address? address = await context
                                        .read<HospitalCubit>()
                                        .getUserAddress();
                                    if (context.mounted) {
                                      context.pop();
                                      context
                                          .read<HospitalCubit>()
                                          .startNavigation(
                                            address!.lat!,
                                            address.long!,
                                            bookmark.location.latitude,
                                            bookmark.location.longitude,
                                            'driving',
                                          );
                                      context.push(
                                          RouteNames.hospitalLocatorRoute);
                                    }
                                  },
                                  onStart: () {
                                    context.pop();
                                    bookmarkCubit.navigateToLocation(
                                        bookmark.location.latitude,
                                        bookmark.location.longitude);
                                  },
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
                  )
                : Container(
                    color: AppColors.screenBackground,
                    height: screenHeight,
                    width: screenWidth,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        FadeIn(
                          duration: const Duration(milliseconds: 600),
                          child: Lottie.asset(
                            'assets/lotties/require_profile.json',
                            height: screenHeight * 0.3,
                            width: screenHeight * 0.3,
                          ),
                        ),
                        Text(
                          'No Data Found',
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'MontserratMedium',
                            fontWeight: FontWeight.w800,
                            fontSize: screenWidth * 0.045,
                          ),
                        ),
                        SizedBox(
                          height: screenHeight * 0.01,
                        ),
                        Text(
                          'Currently no hospital has been saved',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontFamily: 'MontserratMedium',
                            fontWeight: FontWeight.w600,
                            fontSize: screenWidth * 0.03,
                          ),
                        ),
                      ],
                    ),
                  );
          } else if (state is BookmarkError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return Container();
        },
      ),
    );
  }
}
