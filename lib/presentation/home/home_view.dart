import 'package:OculaCare/configs/app/remote/ml_model.dart';
import 'package:OculaCare/configs/utils/utils.dart';
import 'package:OculaCare/data/models/api_response/response_model.dart';
import 'package:OculaCare/data/repositories/local/preferences/shared_prefs.dart';
import 'package:OculaCare/presentation/home/widgets/educ_widget.dart';
import 'package:OculaCare/presentation/home/widgets/grid_btn_widget.dart';
import 'package:OculaCare/presentation/onboarding/data_onboarding/content_model.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import '../../configs/presentation/constants/colors.dart';
import '../../configs/routes/route_names.dart';
import '../../logic/image_capture/img_capture_cubit.dart';
import '../../logic/pdf_cubit/pdf_cubit_state.dart';
import '../widgets/need_to_setup_profile_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MlModel ml = MlModel();
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
            GestureDetector(
              onTap: () async {
                ResponseModel resp = await ml.getData('The Ishihara test is a color vision test that detects color blindness by having individuals identify numbers or patterns within a series of colored plates. The test consists of 10 questions, where each correct answer indicates the ability to distinguish specific colors.The user recently took the Ishihara test and scored 7 out of 10.Based on this score, please provide an analysis of the users color vision. Consider if the score indicates normal color vision, mild, moderate, or severe color blindness. Also, provide a recommendation on whether the user should consult an eye specialist, undergo further testing, or any other relevant advice based on the score. Additionally, mention any potential impacts of color blindness in daily activities and any coping strategies or tools that could be beneficial.'
                );
                print(resp.text);
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 15.0),
                child: SvgPicture.asset(
                  'assets/svgs/notifcation.svg',
                  height: 35.h,
                ),
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
                          sharedPrefs.userName,
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
                          margin: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 10),
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
                  SizedBox(
                    height: 30.h,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: SizedBox(
                      height: 80,
                      width: MediaQuery.sizeOf(context).width,
                      child: LayoutBuilder(builder: (context, constraints) {
                        return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              GridButtonWidget(
                                onTap: () {
                                  if (!sharedPrefs.isProfileSetup) {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return const Dialog(
                                            child: NeedToSetupProfileWidget());
                                      },
                                    );
                                    return;
                                  }
                                  context
                                      .read<ImageCaptureCubit>()
                                      .initializeCamera();
                                  context.push(RouteNames.imgCaptureRoute);
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
                                  AppUtils.showToast(
                                      context,
                                      'Feature Under Development',
                                      'Hold on as we build this feature',
                                      false);
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
                                  AppUtils.showToast(
                                      context,
                                      'Feature Under Development',
                                      'Hold on as we build this feature',
                                      false);
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
                                  context
                                      .read<PDFCubit>()
                                      .fetchAndInitializePDFList();
                                  context.push(RouteNames.pdfViewRoute);
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
                  SizedBox(
                    height: 30.h,
                  ),
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
                  SizedBox(
                    height: 10.h,
                  ),
                  SizedBox(
                    width: MediaQuery.sizeOf(context).width,
                    height: MediaQuery.sizeOf(context).height * 0.36,
                    child: ListView.builder(
                      itemCount: education.length,
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
