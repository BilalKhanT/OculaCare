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
          bottomNavigationBar: Padding(
            padding:
                const EdgeInsets.only(left: 30.0, bottom: 20.0, right: 30.0),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.appColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                ],
                borderRadius: BorderRadius.all(Radius.circular(17.0)),
              ),
              padding: const EdgeInsets.symmetric(vertical: 0),
              child: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                currentIndex: navigationShell.currentIndex,
                onTap: (index) => _onTap(context, index),
                backgroundColor: Colors.transparent,
                elevation: 0,
                selectedItemColor: Colors.black,
                unselectedItemColor: Colors.white,
                showSelectedLabels: false,
                showUnselectedLabels: false,
                items: [
                  _buildNavItem('assets/svgs/house.svg', 'Home', 0),
                  _buildNavItem('assets/svgs/eye_scan.svg', 'Detect', 1),
                  _buildNavItem('assets/svgs/tests.svg', 'Test', 2),
                  _buildNavItem('assets/svgs/results.svg', 'Therapy', 3),
                  _buildNavItem('assets/svgs/dots.svg', 'More', 4),
                ],
              ),
            ),
          ),
        ));
  }

  BottomNavigationBarItem _buildNavItem(
      String iconPath, String label, int index) {
    return BottomNavigationBarItem(
      icon: SvgPicture.asset(
        iconPath,
        height: 24,
        color: navigationShell.currentIndex == index
            ? Colors.black
            : AppColors.whiteColor,
      ),
      label: label,
    );
  }

  void _onTap(BuildContext context, int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}
