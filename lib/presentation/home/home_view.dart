import 'package:OculaCare/presentation/home/widgets/educ_widget.dart';
import 'package:OculaCare/presentation/home/widgets/grid_btn_widget.dart';
import 'package:OculaCare/presentation/onboarding/data_onboarding/content_model.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../configs/presentation/constants/colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // double screenHeight = MediaQuery.sizeOf(context).height;
    // double screenWidth = MediaQuery.sizeOf(context).width;
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: AppColors.screenBackground,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leadingWidth: 60.0,
          leading: Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: ClipRect(
              child: SizedBox(
                width: 60,
                height: 60,
                child: Center(
                  child: Image.asset(
                    'assets/images/logo_ocula_login.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 15.0),
              child: SvgPicture.asset(
                'assets/svgs/notifcation.svg',
                height: 35.h,
              ),
            ),
          ],
        ),
        body: SizedBox(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 5.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Welcome!',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 27.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            letterSpacing: 1,
                          ),
                        ),
                        Text(
                          'Bilal Khan',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 22.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade600,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10.w),
                    child: CarouselSlider(
                      items: [
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          child: SizedBox(
                            height: 150.h,
                              child: Image.asset(
                            'assets/images/eye_banner1.jpeg',
                            fit: BoxFit.cover,
                          )),
                        ),
                        Container(
                          margin: const EdgeInsets.all(5),
                          child: SizedBox(
                            height: 150.h,
                            child: Image.asset(
                              'assets/images/eye_banner2.jpeg',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.all(5),
                          child: SizedBox(
                            height: 150.h,
                            child: Image.asset(
                              'assets/images/eye_banner3.jpeg',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.all(5),
                          child: SizedBox(
                            height: 150.h,
                            child: Image.asset(
                              'assets/images/eye_banner4.jpeg',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.all(5),
                          child: SizedBox(
                            height: 150.h,
                            child: Image.asset(
                              'assets/images/eye_banner5.jpeg',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                      options: CarouselOptions(
                        initialPage: 2,
                          height: 149,
                          aspectRatio: 16 / 9,
                          autoPlay: true,
                          viewportFraction: .9,
                          autoPlayInterval: const Duration(seconds: 5),
                          enableInfiniteScroll: false),
                    ),
                  ),
                  SizedBox(height: 30.h,),
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: SizedBox(
                      height: 80,
                      width: MediaQuery.sizeOf(context).width,
                      child: LayoutBuilder(builder: (context, constraints) {
                        return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceEvenly,
                            children: [
                              GridButtonWidget(
                                onTap: () {
              
                                },
                                iconData: "assets/svgs/eye_scan.svg",
                                constraints: constraints,
                                title: "Faster Way",
                                subtitle: "To Detect",
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              GridButtonWidget(
                                onTap: () {
              
                                },
                                iconData: "assets/svgs/tests.svg",
                                constraints: constraints,
                                title: "Take Tests",
                                subtitle: 'Vision-Color',
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              GridButtonWidget(
                                onTap: () {
              
                                },
                                iconData: "assets/svgs/hospital.svg",
                                constraints: constraints,
                                title: "Locate Hospital?",
                                subtitle: "Explore",
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              GridButtonWidget(
                                onTap: () {
              
                                },
                                constraints: constraints,
                                iconData: 'assets/svgs/leaflet.svg',
                                title: "Explore our",
                                subtitle: "Leaflets",
                              ),
                            ],
                          ),
                        );
                      }),
                    ),
                  ),
                  SizedBox(height: 30.h,),
                  Padding(
                    padding: const EdgeInsets.only(left: 5.0),
                    child: Text(
                      'Educational Awareness',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h,),
                  SizedBox(
                    width: MediaQuery.sizeOf(context).width,
                    height: MediaQuery.sizeOf(context).height * 0.36,
                    child: ListView.builder(
                      itemCount:
                      education.length,
                      itemBuilder: (ctx, index) {
                        EducationModel model = education[index];
                        return Padding(
                          padding: EdgeInsets.only(
                            right: 10.0,
                            left: index == 0 ? 10 : 0,
                          ),
                          child: EducationWidgetHomeView(
                            model: model,
                          ),
                        );
                      },
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
