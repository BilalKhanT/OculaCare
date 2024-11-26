import 'package:equatable/equatable.dart';

abstract class BookmarkIconState extends Equatable {
  const BookmarkIconState();

  @override
  List<Object?> get props => [];
}

class BookmarkIconInitial extends BookmarkIconState {}

class BookmarkIconFilled extends BookmarkIconState {
  final bool isBookmarked;

  const BookmarkIconFilled(this.isBookmarked);

  @override
  List<Object?> get props => [isBookmarked];
}

class BookmarkIconError extends BookmarkIconState {
  final String message;

  const BookmarkIconError(this.message);

  @override
  List<Object?> get props => [message];
}
