import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:focus_tube_flutter/api/api_functions.dart';
import 'package:focus_tube_flutter/api/app_model_factory.dart';
import 'package:focus_tube_flutter/const/app_color.dart';
import 'package:focus_tube_flutter/const/app_const.dart';
import 'package:focus_tube_flutter/const/app_text_style.dart';
import 'package:focus_tube_flutter/go_route_navigation.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

import 'controller/app_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var authCtrl = controller<UserController>();
  await Future.wait([
    authCtrl.getUUID(),
    authCtrl.getUser(),
    authCtrl.getToken(),
    authCtrl.getXAPIKey(),
  ]);
  if (authCtrl.xAPIKey == null) {
    await ApiFunctions.instance.generateToken();
  }
  AppModelFactory.instance.init();
  if (authCtrl.user != null && authCtrl.token != null) {
    ApiFunctions.instance.me();
    await ApiFunctions.instance.getUserInterests(null);
  }
  runApp(const MyApp());
  if (kIsWeb) {
    usePathUrlStrategy();
    GoRouter.optionURLReflectsImperativeAPIs = true;
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    FlutterNativeSplash.remove();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp.router(
      title: AppConst.appName,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColor.primary,
          primary: AppColor.primary,
          secondary: AppColor.lightYellow,
        ),
        dialogTheme: DialogThemeData(backgroundColor: AppColor.white), // Back
        fontFamily: AppTextStyle.fontFamily,
      ),
      debugShowCheckedModeBanner: false,
      routeInformationParser: router.routeInformationParser,
      routerDelegate: router.routerDelegate,
      routeInformationProvider: router.routeInformationProvider,
    );
  }
}
