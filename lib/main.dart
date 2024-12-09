import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kamyon/controllers/location_controller.dart';

import 'package:kamyon/views/auth_views/login_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'constants/app_constants.dart';
import 'constants/providers.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      //options: DefaultFirebaseOptions.currentPlatform
  );
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {

  @override
  void initState() {
    setLanguage();

    final locationNotifier = ref.read(locationController.notifier);
    locationNotifier.getContinuousLocation();

    super.initState();

  }

  setLanguage() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String value = prefs.getString("language")!;
      ref.read(languageStateProvider.notifier).state = value;
    }
    catch(E) {
      ref.read(languageStateProvider.notifier).state = "tr";

    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return ScreenUtilInit(
      designSize:  MediaQuery.of(context).size, //const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_ , child) {
        return MaterialApp(
          title: appName,
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1)),
              child: child ?? Container(),
            );
          },
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            fontFamily: "Poppins",
            colorScheme: ColorScheme.fromSeed(seedColor: kBlueColor,),
            useMaterial3: true,
          ),
          home: child,
        );
      },
      child: const LoginView(),
    );

  }
}

