import 'package:bloc/bloc.dart';

class ChatLoadingCubit extends Cubit<bool> {
  ChatLoadingCubit() : super(false);

  bool loading = false;

  toggleLoading(bool flag) {
    loading = flag;
    emit(loading);
  }
}