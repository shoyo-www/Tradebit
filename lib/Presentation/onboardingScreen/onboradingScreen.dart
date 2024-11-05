import 'package:flutter/material.dart';
import 'package:tradebit_app/Presentation/Auth/login_selection_page/loginselectionpage.dart';
import 'package:tradebit_app/Presentation/dashboard/dashboard.dart';
import 'package:tradebit_app/approutes.dart';
import 'package:tradebit_app/constants/constants.dart';
import 'package:tradebit_app/constants/images.dart';
import 'package:tradebit_app/data/datasource/local/local_storage.dart';
import 'package:tradebit_app/widgets/onboarding/onboardingScreen.dart';
import 'package:tradebit_app/widgets/onboarding/onborading.dart';
import 'package:tradebit_app/widgets/trade_bit_container.dart';
import 'package:tradebit_app/widgets/tradebit_scaffold.dart';

class OnBoardingScreen extends StatelessWidget {
 OnBoardingScreen({Key? key}) : super(key: key);

  final List<OnboardingData> onBoarding = [
    OnboardingData(imagePath: Images.onboarding2),
    OnboardingData(imagePath: Images.onboarding1),
    OnboardingData(imagePath: Images.onboarding3),
  ];

  @override
  Widget build(BuildContext context) {
    return  WillPopScope(
      onWillPop: () async => false,
      child: TradeBitContainer(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(Images.onboarding1),
          )
        ),
        child: TradeBitScaffold(
          body: IntroScreen(onBoarding,AppRoutes.loginSelection),
        ),
      ),
    );
  }
}
