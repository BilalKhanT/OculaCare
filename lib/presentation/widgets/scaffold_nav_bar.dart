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
            labelTextStyle: MaterialStateProperty.all(
              TextStyle(
                fontFamily: 'Poppins',
                color: Colors.black,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            indicatorColor: Colors.grey.shade200,
            backgroundColor: Colors.white,
            elevation: 0,
          ),
          child: NavigationBar(
            onDestinationSelected: (index) => _onTap(context, index),
            selectedIndex: navigationShell.currentIndex,
            destinations: [
              NavigationDestination(
                icon: SvgPicture.asset('assets/svgs/house.svg'),
                label: 'Home',
              ),
              NavigationDestination(
                icon: SvgPicture.asset('assets/svgs/eye_scan.svg'),
                label: 'Detect',
              ),
              NavigationDestination(
                icon: SvgPicture.asset('assets/svgs/tests.svg'),
                label: 'Test',
              ),
              NavigationDestination(
                icon: SvgPicture.asset('assets/svgs/results.svg'),
                label: 'Therapy',
              ),
              NavigationDestination(
                icon: SvgPicture.asset("assets/svgs/dots.svg"),
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
