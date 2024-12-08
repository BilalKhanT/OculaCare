import 'package:equatable/equatable.dart';

import '../../data/models/hospital_locator_model/hospital_model.dart';

abstract class SearchVisibilityState extends Equatable {
  const SearchVisibilityState();

  @override
  List<Object?> get props => [];
}

class SearchHiddenState extends SearchVisibilityState {}

class SearchVisibleState extends SearchVisibilityState {}

class SearchingState extends SearchVisibilityState {}

class SearchingSuccessState extends SearchVisibilityState {
  final List<Hospital> filteredHospitals;

  const SearchingSuccessState(this.filteredHospitals);

  @override
  List<Object?> get props => [filteredHospitals];
}

class SearchingFailureState extends SearchVisibilityState {
  final String errorMessage;

  const SearchingFailureState(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
