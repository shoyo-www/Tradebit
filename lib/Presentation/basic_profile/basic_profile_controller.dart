import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tradebit_app/Presentation/dashboard/dashboard.dart';
import 'package:tradebit_app/approutes.dart';
import 'package:tradebit_app/constants/apptextstyle.dart';
import 'package:tradebit_app/constants/constants.dart';
import 'package:tradebit_app/constants/fontsize.dart';
import 'package:tradebit_app/core/error/failures.dart';
import 'package:tradebit_app/data/datasource/Repository_impl/auth_repository_imp.dart';
import 'package:tradebit_app/data/datasource/local/local_storage.dart';
import 'package:tradebit_app/data/datasource/remote/models/request/basic_Email.dart';
import 'package:tradebit_app/data/datasource/remote/models/request/mobile_verification.dart';
import 'package:tradebit_app/data/datasource/remote/models/request/update_profile.dart';
import 'package:tradebit_app/data/datasource/remote/models/request/validate_mobile.dart';
import 'package:tradebit_app/widgets/trade_bit_toast.dart';

class BasicProfileController extends GetxController {
  Country? countryName;
  int activeStep = 1;
  bool mobile = false;
  bool location = true;
  bool profile = false;
  bool buttonLoading = false;
  bool isTimerEnabled = false;
  bool otp = false;
  int endTime = 0;
  TextEditingController mobileController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  TextEditingController emailOtpController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  AuthRepositoryImpl repositoryImpl = AuthRepositoryImpl();

  nextPage(int index) {
    activeStep = index;
    update([ControllerBuilders.basicController]);
  }

  onChanged() {
    isTimerEnabled = false;
    otp = false;
    update([ControllerBuilders.basicController]);
  }

  onNextTap() {
    location = false;
    mobile = true;
    activeStep = 2;
    update([ControllerBuilders.basicController]);
  }

  onNextTap2() {
    location = false;
    mobile =false;
    profile = true;
    activeStep = 3;
    update([ControllerBuilders.basicController]);
  }

  void startTimer() {
    endTime = DateTime.now().millisecondsSinceEpoch + 120000;
    isTimerEnabled = true;
    update([ControllerBuilders.basicController]);
  }

  onGenerateOtp(BuildContext context) async {
      buttonLoading = true;
      update([ControllerBuilders.basicController]);
      final request = VerifyMobileRequest(
          countryCode: countryName?.countryCode ?? '',
          type: 'profileVerification',
          mobile: mobileController.text,
          countryCallingCode: countryName?.phoneCode ?? ''
      );
      var data = await repositoryImpl.basicDetailsMobile(request);
      data.fold((l) {
        if (l is ServerFailure) {
          buttonLoading = false;
          update([ControllerBuilders.basicController]);
          ToastUtils.showCustomToast(context, l.message ?? '', false);
        }
      }, (r) {
        String code = r.statusCode ?? '';
        String message = r.message ?? '';
        if (code == '1') {
          otp = true;
          isTimerEnabled = true;
          startTimer();
          ToastUtils.showCustomToast(context, message, true);
          buttonLoading = false;
          update([ControllerBuilders.basicController]);
        }
        else {
          ToastUtils.showCustomToast(context, message, false);
          buttonLoading = false;
          update([ControllerBuilders.basicController]);
        }
      });
      update([ControllerBuilders.basicController]);
    }

  onGenerateEmailOtp(BuildContext context) async {
    buttonLoading = true;
    update([ControllerBuilders.basicController]);
    final request =  BasicProfileEmailCode(email: emailOtpController.text, type: 'profileVerification') ;
    var data = await repositoryImpl.basicEmail(request);
    data.fold((l) {
      if (l is ServerFailure) {
        buttonLoading = false;
        update([ControllerBuilders.basicController]);
        ToastUtils.showCustomToast(context, l.message ?? '', false);
      }
    }, (r) {
      String code = r.statusCode ?? '';
      String message = r.message ?? '';
      if (code == '1') {
        otp = true;
        isTimerEnabled = true;
        startTimer();
        ToastUtils.showCustomToast(context, message, true);
        buttonLoading = false;
        update([ControllerBuilders.basicController]);
      }
      else {
        ToastUtils.showCustomToast(context, message, false);
        buttonLoading = false;
        update([ControllerBuilders.basicController]);
      }
    });
    update([ControllerBuilders.basicController]);
  }

  validateOtp(BuildContext context) async {
    buttonLoading = true;
    update([ControllerBuilders.basicController]);
    final request = ValidateMobileProfile(
        mobile: mobileController.text,
        email: emailController.text,
        otp: LocalStorage.getBool(GetXStorageConstants.emailVcode) == false ? emailOtpController.text : otpController.text,
        sendType: LocalStorage.getBool(GetXStorageConstants.emailVcode) == false ? 'email' : 'mobile',

    );
    var data = await repositoryImpl.validateProfile(request);
    data.fold((l) {
      if (l is ServerFailure) {
        buttonLoading = false;
        update([ControllerBuilders.basicController]);
        ToastUtils.showCustomToast(context, l.message ?? '', false);
      }
    }, (r) {
      String code = r.statusCode ?? '';
      String message = r.message ?? '';
      if (code == '1') {
        ToastUtils.showCustomToast(context, message, true);
        profile =true;
        activeStep = 3;
        buttonLoading = false;
        update([ControllerBuilders.basicController]);
      }
      else {
        ToastUtils.showCustomToast(context, message, false);
        buttonLoading = false;
        update([ControllerBuilders.basicController]);
      }
    });
    update([ControllerBuilders.basicController]);
  }

  updateProfile(BuildContext context) async {
    buttonLoading = true;
    update([ControllerBuilders.basicController]);
    final request = UpdateProfileRequest(
        location: countryName?.displayName ?? '',
        step: 3,
        firstName: nameController.text,
        lastName: lastnameController.text,
        email: emailController.text,
        emailVcode: emailOtpController.text,
        mobile: mobileController.text,
        mobileVcode: otpController.text,
        countryCode: countryName?.countryCode ?? '',
        countryCallingCode: countryName?.phoneCode ?? '');
    var data = await repositoryImpl.updateProfile(request);
    data.fold((l) {
      if (l is ServerFailure) {
        buttonLoading = false;
        update([ControllerBuilders.basicController]);
        ToastUtils.showCustomToast(context, l.message ?? '', false);
      }
    }, (r) {
      String code = r.statusCode ?? '';
      String message = r.message ?? '';
      if (code == '1') {
        ToastUtils.showCustomToast(context, message, true);
        LocalStorage.writeBool(GetXStorageConstants.basic, false);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> DashBoard(index: 0)));
        buttonLoading = false;
        update([ControllerBuilders.basicController]);
      }
      else {
        ToastUtils.showCustomToast(context, message, false);
        buttonLoading = false;
        update([ControllerBuilders.basicController]);
      }
    });
    update([ControllerBuilders.basicController]);
  }

  onTap(BuildContext context) {
    showCountryPicker(
      useSafeArea: true,
      context: context,
      showPhoneCode: true,
      showSearch: true,
      onSelect: (Country country) {
        countryName = country;
        update([ControllerBuilders.basicController]);
      },
      countryListTheme: CountryListThemeData(
          bottomSheetHeight: MediaQuery.of(context).size.height / 1.2,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(40.0),
            topRight: Radius.circular(40.0),
          ),
          inputDecoration: InputDecoration(
            iconColor: Theme.of(context).highlightColor,
            labelText: 'Search',
            hintText: 'Start typing to search',
            prefixIcon:  Icon(Icons.search,color: Theme.of(context).highlightColor),
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: const Color(0xFF8C98A8).withOpacity(0.2),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: const Color(0xFF8C98A8).withOpacity(0.2),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: const Color(0xFF8C98A8).withOpacity(0.2),
              ),
            ),
          ),
          searchTextStyle: AppTextStyle.normalTextStyle(FontSize.sp_16, Theme.of(context).highlightColor)
      ),
    );
  }

}