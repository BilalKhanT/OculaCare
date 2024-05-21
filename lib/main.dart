
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nb_utils/nb_utils.dart';
import 'configs/app/environment/env_configs.dart';
import 'configs/routes/router.dart';
import 'data/repositories/local/preferences/shared_prefs.dart';
import 'multi_bloc_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeApp();
  runApp(
    const ProvideMultiBloc(child: MyApp()),
  );
}

Future<void> initializeApp() async {
  sharedPrefs.init();
  EnvConfigs.getInstance();
  initialize();
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.sizeOf(context).height;
    double screenWidth = MediaQuery.sizeOf(context).width;
    return ScreenUtilInit(
      builder: (context, child) {
        return Listener(
          onPointerDown: (event) {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: MaterialApp.router(
            routerConfig: router,
            debugShowCheckedModeBanner: false,
          ),
        );
      },
      designSize: Size(screenWidth, screenHeight),
    );
  }
}
