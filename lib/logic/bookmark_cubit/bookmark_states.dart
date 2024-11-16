import 'package:equatable/equatable.dart';
import '../../data/models/hospital_locator_model/helper_model/hospital_helper_model.dart';

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
  final List<HospitalHelper> bookmark;

  BookmarkLoaded(this.bookmark);
}



