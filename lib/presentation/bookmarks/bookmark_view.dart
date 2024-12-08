import 'package:cculacare/data/repositories/local/preferences/shared_prefs.dart';
import 'package:cculacare/presentation/bookmarks/widgets/cstm_bookmark_tile_widget.dart';
import 'package:cculacare/presentation/bookmarks/widgets/cstm_bottom_bookmark_info_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    bookmarkCubit.fetchBookmarks();

    return Scaffold(
      backgroundColor: AppColors.screenBackground,
      appBar: AppBar(
        backgroundColor: AppColors.screenBackground,
        title: const Text('Bookmarks'),
      ),
      body: BlocBuilder<BookmarkCubit, BookmarkState>(
        builder: (context, state) {
          if (state is BookmarkLoading) {
            return ListView.builder(
              itemCount: 6,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
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
            return Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: ListView.builder(
                itemCount: bookmarks.length,
                itemBuilder: (context, index) {
                  final bookmark = bookmarks[index];
                  return CstmBookmarkTile(
                    bookmark: bookmark,
                    onDelete: () {
                      bookmarkCubit.deleteBookmark(sharedPrefs.email, bookmark.placeId);
                    },
                    onNavigate: () {
                      showModalBottomSheet(
                        context: context,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                        ),
                        builder: (context) {
                          return BookmarkInfoBottomSheet(
                            bookmark: bookmark,
                            onPressed: () {
                              Navigator.pop(context);
                              bookmarkCubit.navigateToLocation(bookmark.location.latitude, bookmark.location.longitude);
                            },
                          );
                        },
                      );
                    },
                  );
                },
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
