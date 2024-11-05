import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'package:tradebit_app/Presentation/Auth/Forget_password/forgot_password.dart';
import 'package:tradebit_app/Presentation/Auth/login/login.dart';
import 'package:tradebit_app/Presentation/Auth/login_selection_page/loginselectionpage.dart';
import 'package:tradebit_app/Presentation/Auth/otp/otp_screen.dart';
import 'package:tradebit_app/Presentation/Auth/register/register.dart';
import 'package:tradebit_app/Presentation/Homepage/homepage.dart';
import 'package:tradebit_app/Presentation/Wallet/withdraw/withdraw.dart';
import 'package:tradebit_app/Presentation/Wallet/withdraw/withdraw_verify.dart';
import 'package:tradebit_app/Presentation/basic_profile/basic_profile.dart';
import 'package:tradebit_app/Presentation/dashboard/dashboard.dart';
import 'package:tradebit_app/Presentation/onboardingScreen/onboradingScreen.dart';
import 'package:tradebit_app/Presentation/refferal/referral_history.dart';
import 'package:tradebit_app/Presentation/splash/splash.dart';
import 'package:tradebit_app/approutes.dart';
import 'package:tradebit_app/constants/constants.dart';
import 'package:tradebit_app/data/datasource/local/local_storage.dart';

class AppPages {
  static const Duration duration = Duration(milliseconds: 500);
  static const Transition transition = Transition.cupertinoDialog;
  static var list = [
    GetPage(
      transitionDuration: duration,
      transition: transition,
      name: AppRoutes.splashScreen,
      page: () => const SplashScreen(),
    ),
    GetPage(
      transitionDuration: duration,
      transition: transition,
      name: AppRoutes.onBoarding,
      page: () =>  LocalStorage.getBool(GetXStorageConstants.onBoarding) == true ? const LoginSelectionPage() :  OnBoardingScreen(),
    ),
    GetPage(
      transitionDuration: duration,
      transition: transition,
      name: AppRoutes.loginSelection,
      page: () =>  const LoginSelectionPage(),
    ),
    GetPage(
      transitionDuration: duration,
      transition: transition,
      name: AppRoutes.loginScreen,
      page: () => const Login(),
    ),
    GetPage(
      transitionDuration: duration,
      transition: transition,
      name: AppRoutes.register,
      page: () => const RegisterPage(),
    ),
    GetPage(
      transitionDuration: duration,
      transition: transition,
      name: AppRoutes.forgotPage,
      page: () => const ForgotPassword(),
    ),
    GetPage(
      transitionDuration: duration,
      transition: transition,
      name: AppRoutes.dashBoard,
      page: () =>  DashBoard(),
    ),
    GetPage(
      transitionDuration: duration,
      transition: transition,
      name: AppRoutes.home,
      page: () => const HomePage(),
    ),
    GetPage(
      transitionDuration: duration,
      transition: transition,
      name: AppRoutes.otp,
      page: () => const Otp(),
    ),
    GetPage(
      transitionDuration: duration,
      transition: transition,
      name: AppRoutes.withdraw,
      page: () =>  const Withdraw(),
    ),
    GetPage(
      transitionDuration: duration,
      transition: transition,
      name: AppRoutes.verifyWithdraw,
      page: () =>  const WithDrawVerify(),
    ),
    GetPage(
      transitionDuration: duration,
      transition: transition,
      name: AppRoutes.basicProfile,
      page: () =>  const BasicProfile(),
    ),
    GetPage(
      transitionDuration: duration,
      transition: transition,
      name: AppRoutes.referralHistory,
      page: () =>  const ReferralHistory(),
    ),
  ];
}
