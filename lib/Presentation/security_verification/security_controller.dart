import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:tradebit_app/Presentation/Homepage/home_controller.dart';
import 'package:tradebit_app/Presentation/dashboard/dashboard.dart';
import 'package:tradebit_app/Presentation/security_verification/google_verification_screen.dart';
import 'package:tradebit_app/Presentation/security_verification/security_verification.dart';
import 'package:tradebit_app/constants/apptextstyle.dart';
import 'package:tradebit_app/constants/constants.dart';
import 'package:tradebit_app/constants/fontsize.dart';
import 'package:tradebit_app/core/error/failures.dart';
import 'package:tradebit_app/data/datasource/Repository_impl/security_repository_impl.dart';
import 'package:tradebit_app/data/datasource/local/local_storage.dart';
import 'package:tradebit_app/data/datasource/remote/models/request/bind_email_request.dart';
import 'package:tradebit_app/data/datasource/remote/models/request/change_number_request.dart';
import 'package:tradebit_app/data/datasource/remote/models/request/confirm_change_number.dart';
import 'package:tradebit_app/data/datasource/remote/models/request/email_otp.dart';
import 'package:tradebit_app/data/datasource/remote/models/request/google_FA_request.dart';
import 'package:tradebit_app/data/datasource/remote/models/request/unbind_email_request.dart';
import 'package:tradebit_app/widgets/trade_bit_toast.dart';
import 'package:tradebit_app/widgets/tradebit_text.dart';

class SecurityController extends GetxController {
  bool isLoading = false;
   int ?emailOtp;
   int? smsOtp;
   int? google2Fa;
   String? email;
   String? mobile;
   String? image;
   String? googleEnable;
   Uint8List? googleImage;
   String? secretKey;
   bool mobilLoading = false;
   bool emailLoading = false;
   bool newMobileLoading = false;
   int endTime = 0;
   int endTimeMobile = 0;
   int mobileTime = 0;
   bool isTimerEnabled = true;
   bool mobileTimer = true;
   bool newMobileTimer = true;
   TextEditingController emailOtpController = TextEditingController();
   TextEditingController mobileOtpController = TextEditingController();
   TextEditingController mobileController = TextEditingController();
   TextEditingController mobileNewOtpController = TextEditingController();
   TextEditingController googleOtpController = TextEditingController();
   final SecurityRepositoryImpl _repositoryImpl = SecurityRepositoryImpl();
   HomeController homeController = Get.put(HomeController());
   Country? countryCode;

  onCopyClipBoard(BuildContext context) {
    Clipboard.setData(ClipboardData(text: secretKey ?? '')).then((_) {
      ToastUtils.showCustomToast(context, 'Copied successfully', true);
    });
    update([ControllerBuilders.securityController]);
  }

  getBack(BuildContext context) {
    isTimerEnabled = false;
    emailOtpController.clear();
    mobileOtpController.clear();
    googleOtpController.clear();
    mobileController.clear();
    mobileNewOtpController.clear();
    mobileTimer = false;
    newMobileTimer = false;
    update([ControllerBuilders.securityController]);
    pushReplacementWithSlideTransition(context, const SecurityVerification(),isBack: true);
  }

  void startTimer() {
    endTime = DateTime.now().millisecondsSinceEpoch + 120000;
    isTimerEnabled = true;
    update([ControllerBuilders.securityController]);
  }

  void startTimerMobile() {
    endTimeMobile = DateTime.now().millisecondsSinceEpoch + 120000;
    mobileTimer = true;
    update([ControllerBuilders.securityController]);
  }

  void startTimerNewMobile() {
    mobileTime = DateTime.now().millisecondsSinceEpoch + 120000;
    newMobileTimer = true;
    update([ControllerBuilders.securityController]);
  }

  getSecurityDetails(BuildContext context) async {
    var data = await _repositoryImpl.security();
    data.fold((l) {
      if(l is ServerFailure) {
        update([ControllerBuilders.securityController]);
        ToastUtils.showCustomToast(context, l.message ?? '', false);
      }
    }, (r) {
      String code = r.statusCode ?? '';
      if(code == '1' ) {
        emailOtp = r.data?.emailOtp;
        smsOtp = r.data?.smsOtp;
        google2Fa = r.data?.google2Fa;
        update([ControllerBuilders.securityController]);
      }
      else {
        ToastUtils.showCustomToast(context, r.message ?? '', false);
      }
    });
    update([ControllerBuilders.securityController]);
  }


  onGoogle(BuildContext context) async {
    isLoading = true;
    update([ControllerBuilders.securityController]);
     var data = await _repositoryImpl.googleFa();
     data.fold((l) {
       if(l is ServerFailure) {
         isLoading = false;
         update([ControllerBuilders.securityController]);
         ToastUtils.showCustomToast(context, l.message ?? '', false);
       }
     }, (r) async {
       String code = r.statusCode ?? '';
       if(code == '1' ) {
         image = r.data?.imageUrl ?? '';
         UriData? data = Uri.parse(image ?? '').data;
         googleImage = data!.contentAsBytes();
         update([ControllerBuilders.securityController]);
         secretKey = r.data?.secret ?? '';
         await homeController.getProfileData(context);
         isLoading = false;
         pushWithSlideTransition(context, const GoogleVerificationScreen());
         update([ControllerBuilders.securityController]);
       }
       else {
         isLoading = false;
         ToastUtils.showCustomToast(context, r.message ?? '', false);
       }
     });
     update([ControllerBuilders.securityController]);
   }

  onShowCountryCode(BuildContext context) {
    showCountryPicker(
      useSafeArea: true,
      showSearch: true,
      context: context,
      showPhoneCode: true,
      onSelect: (country) {
        countryCode = country;
        update([ControllerBuilders.securityController]);
      },
      countryListTheme: CountryListThemeData(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        margin: EdgeInsets.only(top: Dimensions.h_120),
        padding: EdgeInsets.only(top: Dimensions.h_10),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(5.0),
          topRight: Radius.circular(5.0),
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

   getNewMobileOtp(BuildContext context) async {
     newMobileLoading = true;
     update([ControllerBuilders.securityController]);
     var req = ChangeNumberRequest(
         type: 'bindmobile',
         mobile: mobileController.text,
         countryCode: countryCode?.countryCode ?? 'IN',
         countryCallingCode: countryCode?.phoneCode ?? '+91');
     var data = await _repositoryImpl.changeMobile(req);
     data.fold((l) {
       if(l is ServerFailure) {
         newMobileLoading = false;
         update([ControllerBuilders.securityController]);
         ToastUtils.showCustomToast(context, l.message ?? '', false);
       }
     }, (r) async {
       String code = r.statusCode ?? '';
       if(code == '1' ) {
         startTimerNewMobile();
         newMobileLoading =false;
         update([ControllerBuilders.securityController]);
       }
       else {
         newMobileLoading = false;
         update([ControllerBuilders.securityController]);
         ToastUtils.showCustomToast(context, r.message ?? '', false);
       }
     });
     update([ControllerBuilders.securityController]);
   }

  changeNumber(BuildContext context) async {
    isLoading = true;
    update([ControllerBuilders.securityController]);
    var req = ConfirmNumberRequest(
        emailVcode: emailOtpController.text,
        mobileVcode: mobileOtpController.text,
        googleVcode: googleOtpController.text,
        newCountryCallingCode: countryCode?.phoneCode ?? '+91',
        newCountryCode: countryCode?.countryCode ?? 'IN',
        newMobile: mobileController.text,
        newMobileVcode: mobileNewOtpController.text);
    var data = await _repositoryImpl.confirmChangeMobile(req);
    data.fold((l) {
      if(l is ServerFailure) {
        isLoading = false;
        update([ControllerBuilders.securityController]);
        ToastUtils.showCustomToast(context, l.message ?? '', false);
      }
    }, (r) async {
      String code = r.statusCode ?? '';
      if(code == '1' ) {
        pushReplacementWithSlideTransition(context, const SecurityVerification());
        isLoading = false;
        emailOtpController.clear();
        mobileNewOtpController.clear();
        googleOtpController.clear();
        mobileController.clear();
        mobileController.clear();
        update([ControllerBuilders.securityController]);
      }
      else {
        isLoading = false;
        update([ControllerBuilders.securityController]);
        ToastUtils.showCustomToast(context, r.message ?? '', false);
      }
    });
    update([ControllerBuilders.securityController]);
  }

  bindEmailAndMobile(BuildContext context) async {
    var data = await _repositoryImpl.bindEmailMobile();
    data.fold((l) {
      if(l is ServerFailure) {
        isLoading = false;
        update([ControllerBuilders.securityController]);
        ToastUtils.showCustomToast(context, l.message ?? '', false);
      }
    }, (r) {
      String code = r.statusCode ?? '';
      if(code == '1' ) {
        isLoading = false;
        for(var i in r.data ?? []) {
          if(i.type == 'email') {
            email = i.verifyMask;
            print("==================================$email");
          }
          if(i.type == 'mobile') {
            mobile = i.verifyMask;
            print("==================================$mobile");
          }
          if(i.type == 'googleF2a') {
            googleEnable = i.verifyMask;
          }
        }
        update([ControllerBuilders.securityController]);
      }
      else {
        ToastUtils.showCustomToast(context, r.message ?? '', false);
      }
    });
    update([ControllerBuilders.securityController]);
  }

  googleOtp(BuildContext context) async {
    var req = GoogleRequest(secret: secretKey,totp: googleOtpController.text);
    var data = await _repositoryImpl.googleFaOtp(req);
    data.fold((l) {
      if(l is ServerFailure) {
        isLoading = false;
        update([ControllerBuilders.securityController]);
        ToastUtils.showCustomToast(context, l.message ?? '', false);
      }
    }, (r) {
      String code = r.statusCode ?? '';
      if(code == '1' ) {
        isLoading = false;
        ToastUtils.showCustomToast(context, r.message ?? '', true);
        homeController.getProfileData(context);
        pushReplacementWithSlideTransition(context, const SecurityVerification());
        googleOtpController.clear();
        update([ControllerBuilders.securityController]);
      }
      else {
        ToastUtils.showCustomToast(context, r.message ?? '', false);
      }
    });
    update([ControllerBuilders.securityController]);
  }

  requestBindEmailOtp(BuildContext context) async {
    emailLoading = true;
    update([ControllerBuilders.securityController]);
    var req = BindEmailOtpRequest(
      type: 'bindemail',
      email: LocalStorage.getString(GetXStorageConstants.userEmail)
    );
    var data = await _repositoryImpl.bindEmailOtp(req);
    data.fold((l) {
      if(l is ServerFailure) {
        emailLoading = false;
        update([ControllerBuilders.securityController]);
        ToastUtils.showCustomToast(context, l.message ?? '', false);
      }
    }, (r) {
      String code = r.statusCode ?? '';
      if(code == '1' ) {
        startTimer();
        isTimerEnabled = true;
        emailLoading = false;
        ToastUtils.showCustomToast(context, r.message ?? '', true);
        update([ControllerBuilders.securityController]);
      }
      else {
        emailLoading = false;
        ToastUtils.showCustomToast(context, r.message ?? '', false);
      }
    });
    update([ControllerBuilders.securityController]);
  }

  requestBindMobileOtp(BuildContext context) async {
    mobilLoading = true;
    update([ControllerBuilders.securityController]);
    var req = BindMobileOtpRequest(
      type: 'bindmobile',
      countryCallingCode: '91',
      countryCode: 'IN',
      mobile: LocalStorage.getString(GetXStorageConstants.userMobile)
    );
    var data = await _repositoryImpl.bindMobileOtp(req);
    data.fold((l) {
      if(l is ServerFailure) {
        mobilLoading = false;
        update([ControllerBuilders.securityController]);
        ToastUtils.showCustomToast(context, l.message ?? '', false);
      }
    }, (r) {
      String code = r.statusCode ?? '';
      if(code == '1' ) {
        startTimerMobile();
        mobileTimer = true;
        mobilLoading = false;
        homeController.getProfileData(context);
        ToastUtils.showCustomToast(context, r.message ?? '', true);
        update([ControllerBuilders.securityController]);
      }
      else {
        mobilLoading = false;
        update([ControllerBuilders.securityController]);
        ToastUtils.showCustomToast(context, r.message ?? '', false);
      }
    });
    update([ControllerBuilders.securityController]);
  }

  bindEmailOtp(BuildContext context) async {
    isLoading = true;
    update([ControllerBuilders.securityController]);
    var req = BindEmailRequest(
      email: LocalStorage.getString(GetXStorageConstants.userEmail),
      emailVcode: emailOtpController.text,
      mobileVcode: mobileOtpController.text,
      googleCode: googleOtpController.text,
    );
    var data = await _repositoryImpl.bindEmail(req);
    data.fold((l) {
      if(l is ServerFailure) {
        isLoading = false;
        update([ControllerBuilders.securityController]);
        ToastUtils.showCustomToast(context, l.message ?? '', false);
      }
    }, (r) {
      String code = r.statusCode ?? '';
      if(code == '1' ) {
        isLoading = false;
        homeController.getProfileData(context);
        ToastUtils.showCustomToast(context, r.message ?? '', true);
        pushReplacementWithSlideTransition(context, const SecurityVerification());
        googleOtpController.clear();
        update([ControllerBuilders.securityController]);
      }
      else {
        isLoading = false;
        update([ControllerBuilders.securityController]);
        ToastUtils.showCustomToast(context, r.message ?? '', false);
      }
    });
    update([ControllerBuilders.securityController]);
  }

  bindMobile(BuildContext context) async {
    isLoading = true;
    update([ControllerBuilders.securityController]);
    var req = BindMobileRequest(
      mobile: LocalStorage.getString(GetXStorageConstants.userMobile),
      emailVcode: emailOtpController.text,
      mobileVcode: mobileOtpController.text,
      googleVcode: googleOtpController.text,
      countryCallingCode: '+91',
      countryCode: "IN"
    );
    var data = await _repositoryImpl.bindMobile(req);
    data.fold((l) {
      if(l is ServerFailure) {
       isLoading = false;
        update([ControllerBuilders.securityController]);
        ToastUtils.showCustomToast(context, l.message ?? '', false);
      }
    }, (r) {
      String code = r.statusCode ?? '';
      if(code == '1' ) {
        isLoading = false;
        homeController.getProfileData(context);
        ToastUtils.showCustomToast(context, r.message ?? '', true);
        pushReplacementWithSlideTransition(context, const SecurityVerification());
        googleOtpController.clear();
        update([ControllerBuilders.securityController]);
      }
      else {
        isLoading = false;
        update([ControllerBuilders.securityController]);
        ToastUtils.showCustomToast(context, r.message ?? '', false);
      }
    });
    update([ControllerBuilders.securityController]);
  }

  unBindEmail(BuildContext context) async {
      isLoading = true;
      var req = UnBindEmailRequest(
        mobileVcode: mobileOtpController.text,
        emailVcode: emailOtpController.text,
        googleVcode: googleOtpController.text
      );
      var data = await _repositoryImpl.unBindEmailOtp(req);
      data.fold((l) {
        if(l is ServerFailure) {
          isLoading = false;
          update([ControllerBuilders.securityController]);
          ToastUtils.showCustomToast(context, l.message ?? '', false);
        }
      }, (r) {
        String code = r.statusCode ?? '';
        if(code == '1' ) {
          isLoading = false;
          homeController.getProfileData(context);
          ToastUtils.showCustomToast(context, r.message ?? '', true);
          pushReplacementWithSlideTransition(context, const SecurityVerification());
          googleOtpController.clear();
          emailOtpController.clear();
          mobileOtpController.clear();
          update([ControllerBuilders.securityController]);
        }
        else {
          isLoading = false;
          update([ControllerBuilders.securityController]);
          ToastUtils.showCustomToast(context, r.message ?? '', false);
        }
      });
      update([ControllerBuilders.securityController]);
  }

  unBindGoogle2Fa(BuildContext context) async {
    isLoading = true;
    var req = UnBindEmailRequest(
        mobileVcode: mobileOtpController.text,
        emailVcode: emailOtpController.text,
        googleVcode: googleOtpController.text
    );
    var data = await _repositoryImpl.unGoogle2Fa(req);
    data.fold((l) {
      if(l is ServerFailure) {
        isLoading = false;
        update([ControllerBuilders.securityController]);
        ToastUtils.showCustomToast(context, l.message ?? '', false);
      }
    }, (r) {
      String code = r.statusCode ?? '';
      if(code == '1' ) {
        isLoading = false;
        homeController.getProfileData(context);
        ToastUtils.showCustomToast(context, r.message ?? '', true);
        pushReplacementWithSlideTransition(context, const SecurityVerification());
        googleOtpController.clear();
        emailOtpController.clear();
        mobileOtpController.clear();
        update([ControllerBuilders.securityController]);
      }
      else {
        isLoading = false;
        update([ControllerBuilders.securityController]);
        ToastUtils.showCustomToast(context, r.message ?? '', false);
      }
    });
    update([ControllerBuilders.securityController]);
  }

  unBindMobile(BuildContext context) async {
    isLoading = true;
    var req = UnBindEmailRequest(
        mobileVcode: mobileOtpController.text,
        emailVcode: emailOtpController.text,
        googleVcode: googleOtpController.text
    );
    var data = await _repositoryImpl.unBindMobile(req);
    data.fold((l) {
      if(l is ServerFailure) {
        isLoading = false;
        update([ControllerBuilders.securityController]);
        ToastUtils.showCustomToast(context, l.message ?? '', false);
      }
    }, (r) {
      String code = r.statusCode ?? '';
      if(code == '1' ) {
        isLoading = false;
        homeController.getProfileData(context);
        ToastUtils.showCustomToast(context, r.message ?? '', true);
        pushReplacementWithSlideTransition(context, const SecurityVerification());
        googleOtpController.clear();
        emailOtpController.clear();
        mobileOtpController.clear();
        update([ControllerBuilders.securityController]);
      }
      else {
        isLoading = false;
        update([ControllerBuilders.securityController]);
        ToastUtils.showCustomToast(context, r.message ?? '', false);
      }
    });
    update([ControllerBuilders.securityController]);
  }
}
