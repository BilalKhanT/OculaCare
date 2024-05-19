import 'package:bloc/bloc.dart';

class GenderCubit extends Cubit<String> {
  GenderCubit() : super('male');

  void selectGender(String gender) {
    emit(gender);
  }
}
