import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:firebase_core/firebase_core.dart';
import 'configs/app/notification/notification_service.dart';
import 'configs/routes/router.dart';
import 'data/repositories/local/preferences/shared_prefs.dart';
import 'logic/home_cubit/home_cubit.dart';
import 'multi_bloc_provider.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await NotificationService.init();
  tz.initializeTimeZones();
  await initializeApp();
  await dotenv.load(fileName: ".env");
  runApp(
    const ProvideMultiBloc(child: MyApp()),
  );
}

Future<void> initializeApp() async {
  await sharedPrefs.init();
  await initialize();
  Firebase.initializeApp();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.sizeOf(context).height;
    double screenWidth = MediaQuery.sizeOf(context).width;
    sharedPrefs.therapyFetched = false;
    sharedPrefs.historyFetched = false;
    context.read<HomeCubit>().emitHomeAnimation();
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
