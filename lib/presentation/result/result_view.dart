import 'package:OculaCare/configs/app/app_globals.dart';
import 'package:OculaCare/configs/presentation/constants/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../configs/routes/route_names.dart';
import '../../data/models/disease_result/disease_result_model.dart';

class ResultView extends StatefulWidget {
  const ResultView({Key? key}) : super(key: key);

  @override
  State<ResultView> createState() => _ResultViewState();
}

class _ResultViewState extends State<ResultView> {
  late List<DiseaseResultModel> diseaseResults;

  @override
  void initState() {
    diseaseResults = globalResults.toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int flag = diseaseResults.length;
    return Scaffold(
      backgroundColor: AppColors.screenBackground,
      appBar: AppBar(
        backgroundColor: AppColors.screenBackground,
        leading: IconButton(
          onPressed: () {
            context.go(RouteNames.homeRoute);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: AppColors.appColor,
          ),
        ),
        title: Text(
          'Detection Results',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 24.sp,
            color: AppColors.appColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            flag == 0
                ? Center(
              child: Text('No Results Found!',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 22.sp,
                color: AppColors.appColor,
                fontWeight: FontWeight.w700,
              ),),
            )
                : Expanded(
                  child: ListView.builder(
                      itemCount: flag,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15.0),
                              boxShadow: [
                                BoxShadow(
                                  offset: const Offset(1, 3),
                                  blurRadius: 20,
                                  color: const Color(0xFFD3D3D3)
                                      .withOpacity(.99),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Result ${index + 1}',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 20.sp,
                                      color: AppColors.appColor,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 10.0,),
                                  Row(
                                    children: [
                                      Text('Left Eye: ',
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 18.sp,
                                          color: Colors.black,
                                        ),),
                                      Expanded(
                                        child: Text(diseaseResults[index].leftEye.message,
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 18.sp,
                                          color: diseaseResults[index].leftEye.message == 'normal' ? Colors.green : Colors.red,
                                        ),),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 5.0,),
                                  Row(
                                    children: [
                                      Text('Right Eye: ',
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 18.sp,
                                          color: Colors.black,
                                        ),),
                                      Expanded(
                                        child: Text(diseaseResults[index].leftEye.message,
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 18.sp,
                                            color: diseaseResults[index].rightEye.message == 'normal' ? Colors.green : Colors.red,
                                          ),),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                ),
          ],
        ),
      ),
    );
  }
}
