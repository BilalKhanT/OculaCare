import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import '../../configs/routes/route_names.dart';


class MoreView extends StatelessWidget {
  const MoreView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.symmetric(
                  horizontal: 20.h,
                ),
                padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 10.h),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  children: [
                    MoreTab(
                      text: "Account",
                      icon: "assets/svgs/account.svg",
                      onTap: () {
                        context.push(RouteNames.profileRoute);
                      },
                    ),
                    divider(),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Version 0.0+0.1",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade400,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          Text(
                            "${DateTime.now().year} OculaCare All Rights Reserved.",
                            style: const TextStyle(
                              fontSize: 12,
                              fontFamily: 'Poppins',
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MoreTab extends StatelessWidget {
  const MoreTab({
    super.key,
    required this.icon,
    required this.text,
    required this.onTap,
  });
  final dynamic icon;
  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          SvgPicture.asset(icon),
          SizedBox(
            width: 50.w,
          ),
          FittedBox(
            child: Text(
              text,
              style: const TextStyle(
                fontFamily: "Poppins",
                fontSize: 14,
                color: Colors.black,
                fontWeight: FontWeight.w600,
                overflow: TextOverflow.fade,
              ),
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }
}

Widget divider() {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 60.w),
    child: Divider(
      height: 0.2,
      color: Colors.grey.withOpacity(0.2),
    ),
  );
}
