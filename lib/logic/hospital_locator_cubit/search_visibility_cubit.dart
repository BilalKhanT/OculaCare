import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';

import '../../data/models/hospital_locator_model/hospital_model.dart';
import 'search_visibility_state.dart';

class SearchVisibilityCubit extends Cubit<SearchVisibilityState> {
  SearchVisibilityCubit() : super(SearchHiddenState());

  final TextEditingController searchQueryController = TextEditingController();
  List<Hospital> filteredHospitals = [];

  void show() => emit(SearchVisibleState());

  void hide() => emit(SearchHiddenState());

  void filterHospitals(String query, List<Hospital> hospitals) {
    emit(SearchingState());
    try {
      if (query.isEmpty) {
        filteredHospitals = hospitals;
      } else {
        filteredHospitals = hospitals
            .where((hospitals) =>
                hospitals.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
      emit(SearchingSuccessState(filteredHospitals));
    } catch (e) {
      emit(SearchingFailureState(e.toString()));
    }
  }
}
