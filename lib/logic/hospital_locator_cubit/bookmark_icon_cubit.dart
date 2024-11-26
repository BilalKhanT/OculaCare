import 'package:bloc/bloc.dart';
import 'package:cculacare/data/models/hospital_locator_model/hospital_model.dart';
import 'package:cculacare/data/repositories/bookmark/bookmark_repo.dart';
import '../../../data/models/bookmark/bookmark_model.dart';
import '../../configs/global/app_globals.dart';
import '../../data/repositories/local/preferences/shared_prefs.dart';
import 'bookmark_icon_state.dart';

class BookmarkIconCubit extends Cubit<BookmarkIconState> {
  BookmarkIconCubit() : super(BookmarkIconInitial());

  final BookmarkRepository bookmarkRepository = BookmarkRepository();

  void initializeIconState(Hospital hospital) {
    try {
      bool isBookmarked = bookmarks.any((bookmark) => bookmark.placeId == hospital.placeId);
      emit(BookmarkIconFilled(isBookmarked));
    } catch (e) {
      emit(const BookmarkIconError("Failed to initialize bookmark icon state."));
    }
  }

  Future<void> toggleBookmark(Hospital hospital) async {
    try {
      if (state is BookmarkIconFilled) {
        final isCurrentlyBookmarked = (state as BookmarkIconFilled).isBookmarked;

        if (isCurrentlyBookmarked) {
          await bookmarkRepository.deleteBookmark(sharedPrefs.email, hospital.placeId);
          bookmarks.removeWhere((bookmark) => bookmark.placeId == hospital.placeId);
          emit(const BookmarkIconFilled(false));
        } else {
          final bookmark = Bookmark(
            email: sharedPrefs.email,
            name: hospital.name,
            placeId: hospital.placeId,
            location: hospital.location,
            address: hospital.address,
            rating: hospital.rating,
            userRatingsTotal: hospital.userRatingsTotal,
            iconUrl: hospital.iconUrl,
          );

          if (!bookmarks.any((b) => b.placeId == bookmark.placeId)) {
            await bookmarkRepository.addBookmark(bookmark);
            bookmarks.add(bookmark);
          }

          emit(const BookmarkIconFilled(true));
        }
      }
    } catch (e) {
      emit(BookmarkIconError("Failed to toggle bookmark state: $e"));
    }
  }
}
