import 'package:bloc/bloc.dart';
import '../../configs/global/app_globals.dart';
import '../../data/repositories/hospital_locator_repo/hospital_locator_repo.dart';
import 'bookmark_states.dart';

class BookmarkCubit extends Cubit<BookmarkState> {
  BookmarkCubit() : super(BookmarkLoading());

  final HospitalRepository hospitalRepository = HospitalRepository();


  void fetchBookmarks() async {
    emit(BookmarkLoading());
    try {
      if(bookmarks.isEmpty){
        await hospitalRepository.fetchBookmarks();
      }
      emit(BookmarkLoaded(bookmarks));
    } catch (e) {
      emit(BookmarkError(e.toString()));
    }
  }

  void deleteBookmark(String placeId) async {
    emit(BookmarkLoading());

    try {
      bool isDeleted = await hospitalRepository.deleteBookmark(placeId);

      if (isDeleted) {
        bookmarks.removeWhere((bookmark) => bookmark.placeId == placeId);
        emit(BookmarkLoaded(List.from(bookmarks)));
      } else {
        emit(BookmarkError("Failed to delete the bookmark."));
      }
    } catch (e) {
      emit(BookmarkError(e.toString()));
    }
  }


}
