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
            labelTextStyle: WidgetStateProperty.all(
              TextStyle(
                fontFamily: 'MontserratMedium',
                color: Colors.black,
                fontSize: MediaQuery.sizeOf(context).width * 0.03,
                fontWeight: FontWeight.bold,
              ),
            ),
            indicatorColor: AppColors.appColor.withOpacity(0.44),
            backgroundColor: Colors.white,
            elevation: 10,
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
                label: 'Detection',
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
                icon: SvgPicture.asset('assets/svgs/dots.svg'),
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
