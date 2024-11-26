import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../configs/global/app_globals.dart';
import '../../models/bookmark/bookmark_model.dart';
import '../local/preferences/shared_prefs.dart';

class BookmarkRepository {
  final String apiUrl = '$ipServer/api/bookmark';
  final String email = sharedPrefs.email;

  Future<bool> fetchBookmarks() async {
    try {
      final response = await http.get(Uri.parse('$apiUrl/$email'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        bookmarks.clear();
        bookmarks = data.map((bookmarkJson) => Bookmark.fromJson(bookmarkJson)).toList();
        return true;
      } else {
        return false;
      }
    } catch (error) {
      return false;
    }
  }

  Future<bool> addBookmark(Bookmark bookmark) async {
    try {
      final response = await http.post(
        Uri.parse("$apiUrl/add"),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(bookmark.toJson()),
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (error) {
      return false;
    }
  }

  Future<bool> deleteBookmark(String email, String placeId) async {
    try {
      final response = await http.delete(Uri.parse('$apiUrl/delete/$email/$placeId'));

      if (response.statusCode == 200) {
        bookmarks.removeWhere((bookmark) => bookmark.placeId == placeId && bookmark.email == email);
        return true;
      } else {
        return false;
      }
    } catch (error) {
      return false;
    }
  }
}
