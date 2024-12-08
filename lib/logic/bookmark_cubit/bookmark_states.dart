import 'package:cculacare/data/models/bookmark/bookmark_model.dart';
import 'package:equatable/equatable.dart';

abstract class BookmarkState extends Equatable {
  @override
  List<Object> get props => [];
}

class BookmarkLoading extends BookmarkState {}

class BookmarkError extends BookmarkState {
  final String message;

  BookmarkError(this.message);
}

class BookmarkLoaded extends BookmarkState {
  final List<Bookmark> bookmark;

  BookmarkLoaded(this.bookmark);
}
