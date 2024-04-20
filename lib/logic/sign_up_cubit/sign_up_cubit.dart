import 'package:bloc/bloc.dart';
import 'package:ocula_care/logic/sign_up_cubit/sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit() : super(SignUpStateInitial());
}