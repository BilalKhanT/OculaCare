import 'package:bloc/bloc.dart';
import 'package:cculacare/data/repositories/bookmark/bookmark_repo.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../configs/global/app_globals.dart';
import 'bookmark_states.dart';

class BookmarkCubit extends Cubit<BookmarkState> {
  BookmarkCubit() : super(BookmarkLoading());

  final BookmarkRepository bookmarkRepo = BookmarkRepository();

  void fetchBookmarks() async {
    emit(BookmarkLoading());
    try {
      if (bookmarks.isEmpty) {
        bookmarks.clear();
        await bookmarkRepo.fetchBookmarks();
      }
      emit(BookmarkLoaded(bookmarks));
    } catch (e) {
      emit(BookmarkError(e.toString()));
    }
  }

  void deleteBookmark(String email, String placeId) async {
    emit(BookmarkLoading());

    try {
      final bool isDeleted = await bookmarkRepo.deleteBookmark(email, placeId);
      if (isDeleted) {
        bookmarks.removeWhere((bookmark) =>
            bookmark.placeId == placeId && bookmark.email == email);
        emit(BookmarkLoaded(bookmarks));
      } else {
        emit(BookmarkError("Failed to delete bookmark from the database."));
      }
    } catch (e) {
      emit(BookmarkError("An error occurred while deleting the bookmark: $e"));
    }
  }

  Future<void> navigateToLocation(double latitude, double longitude) async {
    final googleMapsUrl =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';

    if (await canLaunchUrl(Uri.parse(googleMapsUrl))) {
      await launchUrl(Uri.parse(googleMapsUrl),
          mode: LaunchMode.externalApplication);
    } else {
      emit(BookmarkError('Could not launch Google Maps'));
    }
  }
}
