import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import '../../configs/routes/route_names.dart';
import '../../logic/patient_profile/patient_profile_cubit.dart';

class NeedToSetupProfileWidget extends StatelessWidget {
  const NeedToSetupProfileWidget(
      {super.key,
        this.showCloseButton = true,
        this.showButton = true,
        this.needToPop = true});
  final bool showCloseButton;
  final bool showButton;
  final bool needToPop;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: SizedBox(
        width: MediaQuery.sizeOf(context).width * 0.75,
        height: MediaQuery.sizeOf(context).height * 0.4,
        child: LayoutBuilder(builder: (context, constraints) {
          return Column(
            children: [
              Container(
                width: constraints.maxWidth,
                alignment: Alignment.centerRight,
                height: 30,
                child: showCloseButton
                    ? GestureDetector(
                  onTap: () {
                    context.pop();
                  },
                  child: const Icon(
                    Icons.cancel,
                    color: Colors.black,
                    size: 30,
                  ),
                )
                    : null,
              ),
              SizedBox(
                width: constraints.maxWidth,
                height: constraints.maxHeight * 0.60,
                child: LottieBuilder.asset(
                  "assets/lotties/require_profile.json",
                  repeat: true,
                ),
              ),
              Container(
                width: constraints.maxWidth,
                alignment: Alignment.center,
                child: Text(
                  "Profile Setup Required",
                  style: TextStyle(
                    fontFamily: 'MontserratMedium',
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.sp,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              if (showButton)
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      if (needToPop) {
                        context.pop();
                      }
                      context.read<PatientProfileCubit>().loadPatientProfile('a');
                      context.push(RouteNames.profileRoute);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Text(
                        "Go to Profile",
                        style: TextStyle(
                          fontFamily: 'MontserratMedium',
                          fontSize: 18.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                )
            ],
          );
        }),
      ),
    );
  }
}
