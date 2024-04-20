import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ocula_care/logic/sign_up_cubit/sign_up_cubit.dart';
import 'package:ocula_care/logic/sign_up_cubit/sign_up_state.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.sizeOf(context).height;
    double screenWidth = MediaQuery.sizeOf(context).width;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: (){},
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
      ),
      body: SizedBox(
        height: screenHeight,
        width: screenWidth,
        child: SafeArea(
          child: SingleChildScrollView(
            child: BlocBuilder<SignUpCubit, SignUpState>(
              builder: (context, state) {
                if (state is SignUpStateLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                else if (state is SignUpStateFailure) {
                  return Center(
                    child: Text(state.errorMsg),
                  );
                }
                else if (state is SignUpStateLoaded) {
                  return const SizedBox();
                }
                else {
                  return const SizedBox.shrink();
                }
              }
            ),
          ),
        ),
      ),
    );
  }
}
