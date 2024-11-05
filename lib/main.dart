import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tradebit_app/Presentation/getx/appPages.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:tradebit_app/approutes.dart';
import 'package:tradebit_app/constants/Theme.dart';
import 'package:tradebit_app/constants/appcolor.dart';
import 'package:tradebit_app/constants/constants.dart';
import 'package:tradebit_app/data/datasource/local/local_storage.dart';
import 'package:tradebit_app/data/datasource/remote/services/dio/dio.dart';
import 'package:tradebit_app/di/di.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  HttpOverrides.global = MyHttpOverrides();
  await GetStorage.init();
  await ScreenUtil.ensureScreenSize();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,overlays: [
    SystemUiOverlay.top,
    SystemUiOverlay.bottom
  ]);
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: (BuildContext context, Widget? child) {
        return GetMaterialApp(
          initialBinding: InitialBinding(),
          builder: EasyLoading.init(),
          debugShowCheckedModeBanner: false,
          theme: AppTheme().lightTheme,
          darkTheme: AppTheme().darkTheme,
          themeMode: LocalStorage().getTheme(),
          title: "Trade Bit",
          initialRoute:  AppRoutes.splashScreen,
          getPages: AppPages.list,
        );
      },
    );
  }
}

