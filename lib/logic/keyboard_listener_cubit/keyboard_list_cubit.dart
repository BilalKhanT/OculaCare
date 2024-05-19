import 'package:bloc/bloc.dart';

import 'keyboard_list_state.dart';

class KeyboardListenerCubit extends Cubit<KeyboardListenerState> {
  KeyboardListenerCubit() : super(KeyboardClosed());
}
