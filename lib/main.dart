import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ocula_care/presentation/login/login_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: (context, child) => const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        home: LoginView(),
      ),
      designSize: const Size(375, 667),
    );
  }
}
