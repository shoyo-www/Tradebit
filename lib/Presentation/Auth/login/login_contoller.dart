import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tradebit_app/Presentation/Auth/otp/otp_screen.dart';
import 'package:tradebit_app/constants/constants.dart';
import 'package:tradebit_app/constants/fontsize.dart';
import 'package:tradebit_app/core/error/failures.dart';
import 'package:tradebit_app/data/datasource/Repository_impl/auth_repository_imp.dart';
import 'package:tradebit_app/data/datasource/remote/models/request/login_request.dart';
import 'package:tradebit_app/widgets/trade_bit_toast.dart';

class LoginController extends GetxController {
  final emailNodeFocus = FocusNode();
  final passwordNodeFocus = FocusNode();
  TextEditingController emailTextController = TextEditingController();
  TextEditingController passwordTextController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  bool closeEye = true;
  bool isPhone = false;
  bool isEmail = true;
  bool isLoading = false;
  bool buttonLoading = false;
  Country? countryCode;
  AuthRepositoryImpl repositoryImpl = AuthRepositoryImpl();

  changeEye() {
    closeEye = !closeEye;
    update([ControllerBuilders.loginPageController]);
  }
  emailButton (BuildContext context) {
    isEmail = true;
    isPhone = false;
    phoneController.clear();
    update([ControllerBuilders.loginPageController]);
  }
  phoneButton(BuildContext context) {
    isEmail = false;
    isPhone = true;
    emailTextController.clear();
    update([ControllerBuilders.loginPageController]);
  }

  login(BuildContext context,String type) async {
    buttonLoading = true;
    update([ControllerBuilders.loginPageController]);
    var request = LoginRequest(
      captchaResponse: 'xxx',
      email: emailTextController.text,
      password: passwordTextController.text,
      loginType: type,
      countryCallingCode: countryCode?.phoneCode ?? '91',
      countryCode: countryCode?.countryCode ?? 'IN',
      mobile: phoneController.text,
    );
    var data = await repositoryImpl.login(request);
    data.fold((l) {
      if (l is ServerFailure) {
        ToastUtils.showCustomToast(context, l.message ?? '', false);
        buttonLoading = false;
        update([ControllerBuilders.loginPageController]);
      }
    }, (r) {
      String code = r.statusCode ?? '';
      String message = r.message ?? '';
      if (code == '1') {
        ToastUtils.showCustomToast(context, message, true);
        buttonLoading = false;
          Navigator.pushReplacement(context, MaterialPageRoute(
                  builder: (context) => Otp(
                    type: r.data?.sendType ?? '',
                    email: r.data?.email ?? '',
                    isGoogle: r.data?.google2Fa ?? false,
                    screenType: 'login',
                    mobile: phoneController.text,
                    isMobile: type == 'mobile' ? true : false,
                  )));
          update([ControllerBuilders.loginPageController]);
      }
      else {
        buttonLoading = false;
        update([ControllerBuilders.loginPageController]);
        ToastUtils.showCustomToast(context, message, false);
      }
    }
    );
    update([ControllerBuilders.loginPageController]);
  }

  onShowCountryCode(BuildContext context) {
    showCountryPicker(
      useSafeArea: true,
      showSearch: true,
      context: context,
      showPhoneCode: true,
      onSelect: (country) {
        countryCode = country;
        update([ControllerBuilders.loginPageController]);
      },
      countryListTheme: CountryListThemeData(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        margin: EdgeInsets.only(top: Dimensions.h_120),
        padding: EdgeInsets.only(top: Dimensions.h_10),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(40.0),
          topRight: Radius.circular(40.0),
        ),
        inputDecoration: InputDecoration(
          labelText: 'Search',
          hintText: 'Start typing to search',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: const Color(0xFF8C98A8).withOpacity(0.2),
            ),
          ),
        ),
      ),
    );
  }
}
