import 'package:cculacare/logic/location_cubit/current_loc_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:firebase_core/firebase_core.dart';
import 'configs/app/notification/notification_service.dart';
import 'configs/global/app_globals.dart';
import 'configs/routes/router.dart';
import 'data/repositories/local/preferences/shared_prefs.dart';
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
    screenHeight = MediaQuery.sizeOf(context).height;
    screenWidth = MediaQuery.sizeOf(context).width;
    sharedPrefs.therapyFetched = false;
    sharedPrefs.historyFetched = false;
    sharedPrefs.resultsFetched = false;
    sharedPrefs.bottomFirst = true;
    sharedPrefs.clearCurrentAddress();
    context.read<CurrentLocationCubit>().loadBottomSheet();
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
