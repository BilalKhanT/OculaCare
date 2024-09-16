import 'package:OculaCare/configs/presentation/constants/colors.dart';
import 'package:flutter/material.dart';
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
            backgroundColor: Colors.white,
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
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}

