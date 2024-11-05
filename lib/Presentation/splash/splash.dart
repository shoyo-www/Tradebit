import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:tradebit_app/Presentation/Homepage/home_controller.dart';
import 'package:tradebit_app/Presentation/dashboard/dashboard.dart';
import 'package:tradebit_app/Presentation/onboardingScreen/onboradingScreen.dart';
import 'package:tradebit_app/approutes.dart';
import 'package:tradebit_app/constants/appcolor.dart';
import 'package:tradebit_app/constants/constants.dart';
import 'package:tradebit_app/constants/images.dart';
import 'package:tradebit_app/data/datasource/local/local_storage.dart';
import 'package:tradebit_app/data/datasource/remote/services/apis.dart';
import 'package:tradebit_app/widgets/trade_bit_container.dart';
import 'package:tradebit_app/widgets/tradebit_scaffold.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    checkLogin();
    BannerImage().getBanners();
    BannerImage().getCrypto();
    _loadWidget();
    LocalStorage.clearValueByKey(GetXStorageConstants.firstTime);
    LocalStorage.clearValueByKey(GetXStorageConstants.listed);
    LocalStorage.writeBool(GetXStorageConstants.firstTime , true);
    LocalStorage.writeBool(GetXStorageConstants.listed , false);
    super.initState();
  }

  _loadWidget() async {
    var duration = const Duration(seconds: 4);
    return Timer(duration, _checkSignInStatus);
  }

  _checkSignInStatus() {
    if(LocalStorage.getBool(GetXStorageConstants.isLogin) == true || LocalStorage.getBool(GetXStorageConstants.onBoarding) == true) {
      if(LocalStorage.getBool(GetXStorageConstants.basic) == true) {
        Get.toNamed(AppRoutes.basicProfile);
      } else {
        Get.toNamed(AppRoutes.dashBoard);
      }
    } else {
      pushReplacementWithSlideTransition(context,  OnBoardingScreen());
    }
  }
  checkLogin() async {
    final client = Dio();
    try{
      final res = await client.get(Apis.walletList,options: Options(headers:{"Authorization":"Bearer ${LocalStorage.getAuthToken()}"},));
      print(res.data);
      if(res.statusCode == 200) {
        LocalStorage.writeBool(GetXStorageConstants.userLogin, false);
      }
    }  catch (e) {
      if (e is DioError && e.response?.statusCode == 401) {
        if (e.response?.data["message"] == 'Unauthenticated') {
          print(e.response?.data["message"]);
          LocalStorage.writeBool(GetXStorageConstants.userLogin, true);
        }}}}

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarColor: AppColor.transparent,
          systemNavigationBarColor: Theme.of(context).scaffoldBackgroundColor,
        ));
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return false;
      },
      child: const TradeBitScaffold(
        body: TradeBitContainer(
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(Images.splash),
            )
          ),
        ),
      ),
    );
  }
}

