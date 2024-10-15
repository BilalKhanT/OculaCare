import 'package:cculacare/logic/detection_animation/detection_animation_cubit.dart';
import 'package:cculacare/logic/home_cubit/home_cubit.dart';
import 'package:cculacare/logic/more_animate/more_cubit.dart';
import 'package:cculacare/logic/tests/test_dash_tab_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import '../../configs/presentation/constants/colors.dart';
import '../../logic/tests/test_cubit.dart';
import '../../logic/therapy_cubit/therapy_dashboard_cubit.dart';

class ScaffoldWithNavBar extends StatelessWidget {
  /// Constructs an [ScaffoldWithNavBar].
  const ScaffoldWithNavBar({
    required this.navigationShell,
    Key? key,
  }) : super(key: key ?? const ValueKey<String>('ScaffoldWithNavBar'));

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      // ignore: deprecated_member_use
      onPopInvoked: ((didPop) {
        _onTap(context, 0);
      }),
      child: Scaffold(
        body: navigationShell,
        bottomNavigationBar: NavigationBarTheme(
          data: NavigationBarThemeData(
            labelTextStyle: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return TextStyle(
                  fontFamily: 'MontserratMedium',
                  color: AppColors.appColor,
                  fontSize: MediaQuery.sizeOf(context).width * 0.028,
                  fontWeight: FontWeight.w700,
                );
              }
              return TextStyle(
                fontFamily: 'MontserratMedium',
                color: Colors.black,
                fontSize: MediaQuery.sizeOf(context).width * 0.028,
                fontWeight: FontWeight.w700,
              );
            }),
            indicatorColor: Colors.grey.shade200,
            backgroundColor: Color(0xFFF5F7F8),
            elevation: 5,
          ),
          child: NavigationBar(
            onDestinationSelected: (index) => _onTap(context, index),
            selectedIndex: navigationShell.currentIndex,
            destinations: [
              NavigationDestination(
                icon: SvgPicture.asset(
                  'assets/svgs/house.svg',
                  // ignore: deprecated_member_use
                  color: navigationShell.currentIndex == 0
                      ? AppColors.appColor
                      : Colors.black,
                ),
                label: 'Home',
              ),
              NavigationDestination(
                icon: SvgPicture.asset(
                  'assets/svgs/eye_scan.svg',
                  // ignore: deprecated_member_use
                  color: navigationShell.currentIndex == 1
                      ? AppColors.appColor
                      : Colors.black,
                ),
                label: 'Detect',
              ),
              NavigationDestination(
                icon: SvgPicture.asset(
                  'assets/svgs/tests.svg',
                  // ignore: deprecated_member_use
                  color: navigationShell.currentIndex == 2
                      ? AppColors.appColor
                      : Colors.black,
                ),
                label: 'Test',
              ),
              NavigationDestination(
                icon: SvgPicture.asset(
                  'assets/svgs/results.svg',
                  // ignore: deprecated_member_use
                  color: navigationShell.currentIndex == 3
                      ? AppColors.appColor
                      : Colors.black,
                ),
                label: 'Therapy',
              ),
              NavigationDestination(
                icon: SvgPicture.asset(
                  "assets/svgs/dots.svg",
                  // ignore: deprecated_member_use
                  color: navigationShell.currentIndex == 4
                      ? AppColors.appColor
                      : Colors.black,
                ),
                label: 'More',
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onTap(BuildContext context, int index) {
    if (index == 0) {
      context.read<HomeCubit>().emitHomeAnimation();
      context.read<MoreCubit>().emitInitial();
      context.read<TestCubit>().emitInitial();
      context.read<TestDashTabCubit>().emitInitial();
      context.read<TherapyDashboardCubit>().loadHistory();
      context.read<DetectionAnimationCubit>().emitInitial();
    }
    else if (index == 1) {
      context.read<DetectionAnimationCubit>().emitHomeAnimation();
      context.read<TestCubit>().emitInitial();
      context.read<HomeCubit>().emitInitial();
      context.read<MoreCubit>().emitInitial();
      context.read<TestDashTabCubit>().emitInitial();
      context.read<TherapyDashboardCubit>().loadHistory();
    }
    else if (index == 3) {
      context.read<TherapyDashboardCubit>().loadInitial();
      context.read<TestCubit>().emitInitial();
      context.read<HomeCubit>().emitInitial();
      context.read<MoreCubit>().emitInitial();
      context.read<TestDashTabCubit>().emitInitial();
      context.read<DetectionAnimationCubit>().emitInitial();
    }
    else if (index == 4) {
      context.read<MoreCubit>().emitHomeAnimation();
      context.read<HomeCubit>().emitInitial();
      context.read<TestCubit>().emitInitial();
      context.read<TestDashTabCubit>().emitInitial();
      context.read<TherapyDashboardCubit>().loadHistory();
      context.read<DetectionAnimationCubit>().emitInitial();
    }
    else if (index == 2) {
      context.read<TestCubit>().loadTests();
      context.read<TestDashTabCubit>().toggleTab(0);
      context.read<HomeCubit>().emitInitial();
      context.read<MoreCubit>().emitInitial();
      context.read<TherapyDashboardCubit>().loadHistory();
      context.read<DetectionAnimationCubit>().emitInitial();
    }
    else {
      context.read<TestCubit>().emitInitial();
      context.read<HomeCubit>().emitInitial();
      context.read<MoreCubit>().emitInitial();
      context.read<TestDashTabCubit>().emitInitial();
      context.read<TherapyDashboardCubit>().loadHistory();
      context.read<DetectionAnimationCubit>().emitInitial();
    }
    navigationShell.goBranch(
      index,
      initialLocation: true,
    );
  }
}
