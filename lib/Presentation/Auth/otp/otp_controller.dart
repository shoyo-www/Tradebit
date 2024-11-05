import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:tradebit_app/Presentation/Auth/login/login.dart';
import 'package:tradebit_app/Presentation/Homepage/home_controller.dart';
import 'package:tradebit_app/Presentation/basic_profile/basic_profile.dart';
import 'package:tradebit_app/Presentation/dashboard/dashboard.dart';
import 'package:tradebit_app/Presentation/utils/validators.dart';
import 'package:tradebit_app/approutes.dart';
import 'package:tradebit_app/constants/appcolor.dart';
import 'package:tradebit_app/constants/apptextstyle.dart';
import 'package:tradebit_app/constants/constants.dart';
import 'package:tradebit_app/constants/fontsize.dart';
import 'package:tradebit_app/core/error/failures.dart';
import 'package:tradebit_app/data/datasource/Repository_impl/auth_repository_imp.dart';
import 'package:tradebit_app/data/datasource/local/local_storage.dart';
import 'package:tradebit_app/data/datasource/remote/models/request/google_request.dart';
import 'package:tradebit_app/data/datasource/remote/models/request/otp_rquest.dart';
import 'package:tradebit_app/data/datasource/remote/models/request/register_email_request.dart';
import 'package:tradebit_app/data/datasource/remote/models/request/register_mobile_request.dart';
import 'package:tradebit_app/data/datasource/remote/models/request/resend_otp.dart';
import 'package:tradebit_app/widgets/spacing.dart';
import 'package:tradebit_app/widgets/trade_bit_container.dart';
import 'package:tradebit_app/widgets/trade_bit_toast.dart';
import 'package:tradebit_app/widgets/tradebit_text.dart';


class OTPController extends GetxController {
  TextEditingController otpController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController googleOtpController = TextEditingController();
  AuthRepositoryImpl repository = AuthRepositoryImpl();
  bool isTimerEnabled = true;
  bool buttonLoading = false;
  int endTime = 0;
  bool resendLoading = false;
  GlobalKey<FormState> googleKey = GlobalKey<FormState>();
  HomeController homeController =Get.put(HomeController());

  otp(BuildContext context, String mobile) async {
    buttonLoading = true;
    update([ControllerBuilders.otpPageController]);
    var request = OtpRequestMobile(
    mobile: mobile,
    mobileVcode: mobileController.text,
    googleVcode: googleOtpController.text,
    loginType: 'mobile');

    var data = await repository.otpLogin(request);
    data.fold((l) {
      if (l is ServerFailure) {
        buttonLoading = false;
        update([ControllerBuilders.otpPageController]);
        ToastUtils.showCustomToast(context, l.message ?? '', false);
      }
    }, (r) async{
      String code = r.statusCode ?? '';
      String message = r.message ?? '';
      if (code == '1') {
        buttonLoading = false;
        ToastUtils.showCustomToast(context, message, true);
        LocalStorage.setAuthToken(r.data?.token ?? '');
        LocalStorage.writeString(GetXStorageConstants.profileStatus, r.data?.user?.profileStatus ?? '');
        LocalStorage.writeString(GetXStorageConstants.userEmail, r.data?.user?.email ?? '');
        LocalStorage.writeString(GetXStorageConstants.userProfile, r.data?.user?.profileImage ?? '');
        LocalStorage.writeString(GetXStorageConstants.userName, r.data?.user?.username ?? '');
        LocalStorage.writeString(GetXStorageConstants.userKycStatus, r.data?.user?.userKycStatus ?? '');
        LocalStorage.writeBool(GetXStorageConstants.isLogin, true);
        LocalStorage.writeBool(GetXStorageConstants.userLogin, false);
        LocalStorage.writeString(GetXStorageConstants.userMobile, r.data?.user?.mobile ?? '');
        LocalStorage.writeBool(GetXStorageConstants.basic, r.data?.user?.profileStatus == 'new' ? true : false);
        if(r.data?.user?.profileStatus == 'new') {
          Get.toNamed(AppRoutes.basicProfile);
        } else {
          pushReplacementWithSlideTransition(context,  DashBoard(index: 0));
        }
        update([ControllerBuilders.otpPageController]);


      } else {
        buttonLoading = false;
        update([ControllerBuilders.otpPageController]);
        ToastUtils.showCustomToast(context, message, false);
      }
    });
    update([ControllerBuilders.otpPageController]);

  }

  onResend(BuildContext context,String email,String type,String mobile) async{
    resendLoading = true;
    update([ControllerBuilders.otpPageController]);
    var request = ResendOtpRequest(
      email: email,
      type: type,
      mobile: mobile
    );
    var data = await repository.resendOtp(request);
    data.fold((l)  {
          if (l is ServerFailure){
            ToastUtils.showCustomToast(context, l.message ?? '', false);
            resendLoading = false;
            update([ControllerBuilders.otpPageController]);
            }
        }, (r) {
      String code = r.statusCode ?? '';
      String message = r.message ?? '';
      if (code == '1') {
        isTimerEnabled = true;
        startTimer();
        resendLoading = false;
        ToastUtils.showCustomToast(context, message, true);
        update([ControllerBuilders.otpPageController]);
      } else {
        resendLoading = false;
        ToastUtils.showCustomToast(context, message, false);
        update([ControllerBuilders.otpPageController]);
      }
    });
    update([ControllerBuilders.otpPageController]);
  }

  verifyByMobile(BuildContext context,String token,String mobile) async {
    buttonLoading =true;
    update([ControllerBuilders.otpPageController]);
    var request = RegisterMobileOtpRequest(
      token: token,
      mobile_vcode: otpController.text,
      mobile: mobile,
    );
    var data = await repository.registerByMobile(request);
    data.fold(
        (l) => {
              if (l is ServerFailure)
                {ToastUtils.showCustomToast(context, l.message ?? '', false),
                buttonLoading = false,
                update([ControllerBuilders.otpPageController])}
            }, (r) {
      String code = r.statusCode ?? '';
      String message = r.message ?? '';
      if (code == ApiStatus.success) {
        ToastUtils.showCustomToast(context, message, true);
        buttonLoading = false;
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> const Login()));
        update([ControllerBuilders.otpPageController]);
      } else {
        ToastUtils.showCustomToast(context, message, false);
        buttonLoading = false;
        update([ControllerBuilders.otpPageController]);
      }
    });
    update([ControllerBuilders.otpPageController]);

  }


  verifyRegisterEmail(BuildContext context,String email,String token) async {
    buttonLoading = true;
    update([ControllerBuilders.otpPageController]);
    var request = RegisterEmailOtpRequest(emailVcode: otpController.text, token: token, email: email);
    var data = await repository.verifyEmailRegister(request);
    data.fold((l) => {
          if (l is ServerFailure) {
               buttonLoading = false,
              update([ControllerBuilders.otpPageController]),
              ToastUtils.showCustomToast(context, l.message ?? '', false)
          }
        }, (r) async {
      String code = r.statusCode ?? '';
      String message = r.message ?? '';
      if (code == '1') {
        ToastUtils.showCustomToast(context, message, true);
        buttonLoading = false;
        update([ControllerBuilders.otpPageController]);
        LocalStorage.setAuthToken(r.data?.token ?? '');
        LocalStorage.writeString(GetXStorageConstants.profileStatus, r.data?.user?.profileStatus ?? '');
        LocalStorage.writeString(GetXStorageConstants.userEmail, r.data?.user?.email ?? '');
        LocalStorage.writeString(GetXStorageConstants.userName, r.data?.user?.username ?? '');
        LocalStorage.writeBool(GetXStorageConstants.isLogin, true);
        LocalStorage.writeBool(GetXStorageConstants.userLogin, false);
        LocalStorage.writeString(GetXStorageConstants.user, r.data?.user?.username ?? '');
        LocalStorage.writeString(GetXStorageConstants.userid, r.data?.user?.referralCode ?? '');
        LocalStorage.writeBool(GetXStorageConstants.basicFirst , false);
        await homeController.getProfileData(context);
        Get.toNamed(AppRoutes.basicProfile);
      } else {
        ToastUtils.showCustomToast(context, message, false);
        buttonLoading = false;
        update([ControllerBuilders.otpPageController]);
      }
    });
    update([ControllerBuilders.otpPageController]);
  }

  void startTimer() {
    int totalSeconds = 120;
    endTime = DateTime.now().add(Duration(seconds: totalSeconds)).millisecondsSinceEpoch;
    isTimerEnabled = true;
    update([ControllerBuilders.otpPageController]);
  }

showSheet (BuildContext context, String email,String loginType,String mobile) {
    return showModalBottomSheet
      (backgroundColor: Colors.transparent,
        context: context,
        isScrollControlled: true,
        isDismissible: true,
        builder: (BuildContext context) {
          return DraggableScrollableSheet(
              initialChildSize: 0.80,
              maxChildSize: 0.80,
              minChildSize: 0.80,
              expand: true,
              builder: (context, scrollController) {
                return Container(
                  decoration:  BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30)
                      )
                  ),
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          VerticalSpacing(height: Dimensions.h_40),
                          Center(
                            child: TradeBitTextWidget(
                                title: 'Authenticate',
                                style: AppTextStyle.themeBoldTextStyle(
                                    fontSize: FontSize.sp_22,
                                    color: Theme.of(context).highlightColor
                                )
                            ),
                          ),
                          VerticalSpacing(height: Dimensions.h_40),
                          Padding(
                            padding: EdgeInsets.only(left:Dimensions.w_30),
                            child: TradeBitTextWidget(
                              title: "Google authenticator",
                              style: AppTextStyle.normalTextStyle(FontSize.sp_12, Theme.of(context).highlightColor),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          VerticalSpacing(height: Dimensions.h_15),
                          Container(
                            padding: const EdgeInsets.only(left: 5,right: 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Form(
                              key: googleKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  PinCodeTextField(
                                    validator: Validator.otpValidate,
                                    autovalidateMode: AutovalidateMode.onUserInteraction,
                                    autoFocus: false,
                                    length: 6,
                                    obscureText: false,
                                    animationType: AnimationType.fade,
                                    pinTheme: PinTheme(
                                      borderWidth: 1,
                                      selectedColor: Theme.of(context).cardColor,
                                      selectedFillColor: Theme.of(context).scaffoldBackgroundColor,
                                      inactiveColor: Theme.of(context).cardColor,
                                      activeColor: Theme.of(context).scaffoldBackgroundColor,
                                      activeFillColor: Theme.of(context).cardColor,
                                      inactiveFillColor: Theme.of(context).scaffoldBackgroundColor,
                                      shape: PinCodeFieldShape.box,
                                      borderRadius: BorderRadius.circular(10),
                                      fieldHeight: Dimensions.h_50,
                                      fieldWidth: Dimensions.w_50,
                                    ),
                                    animationDuration: const Duration(milliseconds: 300),
                                    controller: googleOtpController,
                                    enableActiveFill: true,
                                    onCompleted: (v) {},
                                    onChanged: (value) {},
                                    appContext: context,
                                  ),
                                  VerticalSpacing(height: Dimensions.h_10),
                                  Padding(
                                    padding: EdgeInsets.only(left: Dimensions.w_30),
                                    child: TradeBitTextWidget(title: "Enter 6 digit code received on google authenticator", style: AppTextStyle.normalTextStyle(FontSize.sp_12, Theme.of(context).shadowColor)),
                                  ),
                                  VerticalSpacing(height: Dimensions.h_30),
                                  Container(
                                    margin: EdgeInsets.only(left: Dimensions.w_10,right: Dimensions.w_10),
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        if(googleKey.currentState!.validate()) {
                                          loginWithGoogle(context, email,loginType,mobile);
                                        }
                                        },
                                      style: ButtonStyle(
                                        foregroundColor:
                                        MaterialStateProperty.all<Color>(Colors.white),
                                        backgroundColor:
                                        MaterialStateProperty.all<Color>(AppColor.appColor),
                                        shape:
                                        MaterialStateProperty.all<RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10.0),
                                          ),
                                        ),
                                      ),
                                      child:  Padding(
                                        padding: const EdgeInsets.all(14.0),
                                        child: Text(
                                          'SUBMIT',
                                          style: AppTextStyle.themeBoldNormalTextStyle(
                                            fontSize: FontSize.sp_15,
                                            color: Theme.of(context).highlightColor
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          VerticalSpacing(height: Dimensions.h_15),
                        ],
                      ),
                      Positioned(
                          right: 15,
                          top: 25
                          ,child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        }
                        ,child: TradeBitContainer(
                        decoration: BoxDecoration(
                            color: Theme.of(context).shadowColor.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(30)
                        ),
                        height: Dimensions.h_22,
                        width: Dimensions.h_22,
                        child: const Center(child: Icon(Icons.close,size: 18,)),
                      ),
                      ))
                    ],
                  ),
                );
              }
          );
        }
    );
}

   // login(BuildContext context,String type,String mobile,String) async {
   //   isLoading = true;
   //   update([ControllerBuilders.loginPageController]);
   //   var request = LoginRequest(
   //     captchaResponse: 'xxx',
   //     email: emailTextController.text,
   //     password: passwordTextController.text,
   //     loginType: type,
   //     countryCallingCode: '91',
   //     countryCode: 'IN',
   //     mobile: mobile,
   //   );
   //   var data = await repository.login(request);
   //   data.fold((l) {
   //     if (l is ServerFailure) {
   //       ToastUtils.showCustomToast(context, l.message ?? '', false);
   //     }
   //   }, (r) {
   //     String code = r.statusText ?? '';
   //     String message = r.message ?? '';
   //     if (code == 'Success') {
   //       ToastUtils.showCustomToast(context, message, true);
   //     }
   //     else {
   //       update([ControllerBuilders.loginPageController]);
   //       ToastUtils.showCustomToast(context, message, false);
   //     }
   //   }
   //   );
   //   update([ControllerBuilders.loginPageController]);
   // }

loginWithGoogle(BuildContext context ,String email,String loginType,String mobile) async{
    buttonLoading = true;
    update([ControllerBuilders.otpPageController]);
  var request = GoogleLoginrequest(
      email: email,
      emailVcode: otpController.text,
      mobile_vcode: mobileController.text,
      googleVcode: googleOtpController.text,
      loginType: loginType,
      mobile: mobile
  );

  var data = await repository.googleLogin(request);
  data.fold((l) {

    if (l is ServerFailure) {
      buttonLoading = false;
      update([ControllerBuilders.otpPageController]);
      ToastUtils.showCustomToast(context, l.message ?? '', false);
    }
  }, (r) {
    String code = r.statusCode ?? '';
    String message = r.message ?? '';
    if (code == '1') {
      buttonLoading = false;
      otpController.clear();
      googleOtpController.clear();
      ToastUtils.showCustomToast(context, message, true);
      LocalStorage.setAuthToken(r.data?.token ?? '');
      LocalStorage.writeString(GetXStorageConstants.profileStatus, r.data?.user?.profileStatus ?? '');
      LocalStorage.writeString(GetXStorageConstants.userEmail, r.data?.user?.email ?? '');
      LocalStorage.writeString(GetXStorageConstants.userName, r.data?.user?.username ?? '');
      LocalStorage.writeBool(GetXStorageConstants.isLogin, true);
      LocalStorage.writeBool(GetXStorageConstants.userLogin, false);
      LocalStorage.writeString(GetXStorageConstants.user, r.data?.user?.username ?? '');
      LocalStorage.writeString(GetXStorageConstants.userid, r.data?.user?.referralCode ?? '');
      update([ControllerBuilders.otpPageController]);
      if(r.data?.user?.profileStatus == 'new') {
        Get.toNamed(AppRoutes.basicProfile);
      } else {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> DashBoard(index: 0)));
      }
    } else {
      buttonLoading = false;
      update([ControllerBuilders.otpPageController]);
      ToastUtils.showCustomToast(context, message, false);
    }
  });
  update([ControllerBuilders.otpPageController]);
}

}
