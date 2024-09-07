import 'package:OculaCare/configs/presentation/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

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
      onPopInvoked: ((didPop) {
        _onTap(context, 0);
      }),
      child: Scaffold(
        body: navigationShell,
        bottomNavigationBar: NavigationBarTheme(
          data: NavigationBarThemeData(
            labelTextStyle: MaterialStateProperty.resolveWith((states) {
              if (states.contains(MaterialState.selected)) {
                return TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.appColor,
                );
              }
              return TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              );
            }),
            indicatorColor: Colors.grey.shade200,
            backgroundColor: Colors.white,
            elevation: 0,
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
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}
