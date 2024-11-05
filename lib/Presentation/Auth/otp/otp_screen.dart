import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:tradebit_app/Presentation/Auth/login/login.dart';
import 'package:tradebit_app/Presentation/Auth/otp/otp_controller.dart';
import 'package:tradebit_app/Presentation/dashboard/dashboard.dart';
import 'package:tradebit_app/Presentation/utils/validators.dart';
import 'package:tradebit_app/constants/appcolor.dart';
import 'package:tradebit_app/constants/apptextstyle.dart';
import 'package:tradebit_app/constants/constants.dart';
import 'package:tradebit_app/constants/fontsize.dart';
import 'package:tradebit_app/widgets/common_app_bar.dart';
import 'package:tradebit_app/widgets/spacing.dart';
import 'package:tradebit_app/widgets/trade_bit_container.dart';
import 'package:tradebit_app/widgets/tradebit_scaffold.dart';
import 'package:tradebit_app/widgets/tradebit_text.dart';
import 'package:tradebit_app/widgets/tradebit_textbutton.dart';

class Otp extends StatefulWidget {
  final String? email;
  final String? mobile;
  final String? type;
  final bool isGoogle;
  final bool isMobile;
  final String? screenType;
  final String? token;
  const Otp({Key? key, this.email, this.mobile, this.type,this.isGoogle = false,this.screenType,this.token,this.isMobile = false}) : super(key: key);

  @override
  OtpState createState() => OtpState();
}

class OtpState extends State<Otp> {
  final OTPController otpController = Get.put(OTPController());
  GlobalKey<FormState> otpKey = GlobalKey<FormState>();

  @override
  void initState() {
   otpController.startTimer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OTPController>(
      id: ControllerBuilders.otpPageController,
      init: otpController,
      builder: (controller) {
        return TradeBitContainer(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor
          ),
          child: SafeArea(
            child: TradeBitScaffold(
              appBar: PreferredSize(preferredSize: Size.fromHeight(Dimensions.h_55), child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TradeBitAppBar(title: 'Verification ',onTap: ()=>
                      pushReplacementWithSlideTransition(context, const Login())
                  ),
                ],
              )),
            body: SingleChildScrollView(
              child: Form(
                key: otpKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        VerticalSpacing(height: Dimensions.h_50),
                        Visibility(
                          visible: widget.isMobile == true ? false : true,
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding:  EdgeInsets.only(left: Dimensions.w_15,right: Dimensions.w_15),
                                  child: TradeBitTextWidget(title: 'Enter your 6 digits email verification code ', style: AppTextStyle.themeBoldNormalTextStyle(
                                      color: Theme.of(context).highlightColor.withOpacity(0.8),
                                      fontSize: FontSize.sp_16
                                  )),
                                ),
                              ),
                              VerticalSpacing(height: Dimensions.h_20),
                              Padding(
                                padding: const EdgeInsets.only(left: 20.0,right: 20),
                                child: PinCodeTextField(
                                  autoDisposeControllers: false,
                                  errorTextSpace: 22,
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  validator: Validator.otpValidate,
                                  keyboardType: TextInputType.number,
                                  autoFocus: false,
                                  length: 6,
                                  obscureText: false,
                                  animationType: AnimationType.fade,
                                  pinTheme: PinTheme(
                                    errorBorderColor: AppColor.red,
                                    borderWidth: 1,
                                    selectedColor: Theme.of(context).shadowColor.withOpacity(0.5),
                                    selectedFillColor: Theme.of(context).cardColor,
                                    inactiveColor: Theme.of(context).shadowColor.withOpacity(0.5),
                                    activeColor: Theme.of(context).cardColor,
                                    activeFillColor: Theme.of(context).cardColor,
                                    inactiveFillColor: Theme.of(context).cardColor,
                                    shape: PinCodeFieldShape.box,
                                    borderRadius: BorderRadius.circular(10),
                                    fieldHeight: Dimensions.h_45,
                                    fieldWidth: Dimensions.w_45,
                                  ),
                                  animationDuration: const Duration(milliseconds: 300),
                                  controller: controller.otpController,
                                  enableActiveFill: true,
                                  onCompleted: (v) {},
                                  onChanged: (value) {},
                                  appContext: context,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Visibility(
                          visible: widget.isMobile == true ? true : false,
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding:  EdgeInsets.only(left: Dimensions.w_15,right: Dimensions.w_15),
                                  child: TradeBitTextWidget(title: 'Enter your 6 digits Mobile verification code ', style: AppTextStyle.themeBoldNormalTextStyle(
                                      color: Theme.of(context).highlightColor.withOpacity(0.8),
                                      fontSize: FontSize.sp_16
                                  )),
                                ),
                              ),
                              VerticalSpacing(height: Dimensions.h_20),
                              Padding(
                                padding: const EdgeInsets.only(left: 20.0,right: 20),
                                child: PinCodeTextField(
                                  autoDisposeControllers: false,
                                  errorTextSpace: 22,
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  validator: Validator.otpValidate,
                                  keyboardType: TextInputType.number,
                                  autoFocus: false,
                                  length: 6,
                                  obscureText: false,
                                  animationType: AnimationType.fade,
                                  pinTheme: PinTheme(
                                    errorBorderColor: AppColor.red,
                                    borderWidth: 1,
                                    selectedColor: Theme.of(context).shadowColor.withOpacity(0.5),
                                    selectedFillColor: Theme.of(context).cardColor,
                                    inactiveColor: Theme.of(context).shadowColor.withOpacity(0.5),
                                    activeColor: Theme.of(context).cardColor,
                                    activeFillColor: Theme.of(context).cardColor,
                                    inactiveFillColor: Theme.of(context).cardColor,
                                    shape: PinCodeFieldShape.box,
                                    borderRadius: BorderRadius.circular(10),
                                    fieldHeight: Dimensions.h_45,
                                    fieldWidth: Dimensions.w_45,
                                  ),
                                  animationDuration: const Duration(milliseconds: 300),
                                  controller: controller.mobileController,
                                  enableActiveFill: true,
                                  onCompleted: (v) {},
                                  onChanged: (value) {},
                                  appContext: context,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Visibility(visible: widget.isGoogle,
                            child: VerticalSpacing(height: Dimensions.h_20)),
                        Visibility(
                          visible: widget.isGoogle,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding:  EdgeInsets.only(left: Dimensions.w_15,right: Dimensions.w_15),
                              child: TradeBitTextWidget(title: 'Authenticator Code ', style: AppTextStyle.themeBoldNormalTextStyle(
                                  color: Theme.of(context).highlightColor.withOpacity(0.8),
                                  fontSize: FontSize.sp_16
                              )),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: widget.isGoogle,
                            child: VerticalSpacing(height: Dimensions.h_15)),
                        Visibility(
                          visible: widget.isGoogle,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20.0,right: 20),
                            child: PinCodeTextField(
                              autoDisposeControllers: false,
                              errorTextSpace: 22,
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              validator: Validator.otpValidate,
                              keyboardType: TextInputType.number,
                              autoFocus: false,
                              length: 6,
                              obscureText: false,
                              animationType: AnimationType.fade,
                              pinTheme: PinTheme(
                                errorBorderColor: AppColor.red,
                                borderWidth: 1,
                                selectedColor: Theme.of(context).shadowColor.withOpacity(0.5),
                                selectedFillColor: Theme.of(context).cardColor,
                                inactiveColor: Theme.of(context).shadowColor.withOpacity(0.5),
                                activeColor: Theme.of(context).cardColor,
                                activeFillColor: Theme.of(context).cardColor,
                                inactiveFillColor: Theme.of(context).cardColor,
                                shape: PinCodeFieldShape.box,
                                borderRadius: BorderRadius.circular(10),
                                fieldHeight: Dimensions.h_45,
                                fieldWidth: Dimensions.w_45,
                              ),
                              animationDuration: const Duration(milliseconds: 300),
                              controller: controller.googleOtpController,
                              enableActiveFill: true,
                              onCompleted: (v) {},
                              onChanged: (value) {},
                              appContext: context,
                            ),
                          ),
                        ),
                        VerticalSpacing(height: Dimensions.h_10),
                        TradeBitTextButton(
                          loading: controller.buttonLoading,
                            labelName: 'Verify Account', onTap: () {
                          if (otpKey.currentState!.validate()) {
                            if (widget.screenType == 'login') {
                              if (widget.isGoogle == true) {
                                controller.loginWithGoogle(context, widget.email ?? '', widget.type ?? '',widget.mobile ?? '');
                              }
                              else {
                                widget.type == 'email'
                                    ? controller.loginWithGoogle(context, widget.email ?? '', 'email',widget.mobile ?? '')
                                    : controller.otp(
                                    context, widget.mobile ?? ''); 
                              }
                            } else {
                              widget.type == 'email' ? controller.verifyRegisterEmail(
                                  context, widget.email ?? '',widget.token ?? '') : controller.verifyByMobile(context, widget.token ?? '',widget.mobile ?? '');
                            }
                          }
                        }),
                      ],
                    ),
                    VerticalSpacing(height: Dimensions.h_15),
                     Align(
                       alignment: Alignment.center,
                       child: Text(
                        "Didn't you receive any code?",
                        style: TextStyle(
                          fontSize: FontSize.sp_14,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).shadowColor,
                        ),
                        textAlign: TextAlign.center,
                    ),
                     ),
                    const SizedBox(
                      height: 18,
                    ),
                    controller.isTimerEnabled ? Align(
                      alignment: Alignment.center,
                      child: CountdownTimer(
                        endWidget: GestureDetector(
                          onTap: () {
                            controller.onResend(context, widget.email ?? '', widget.type ?? '',widget.mobile ?? '');
                            },
                          child: controller.resendLoading ? const CupertinoActivityIndicator(
                            color: AppColor.appColor,
                          ) : Text(
                            "Resend Code",
                            style: AppTextStyle.themeBoldNormalTextStyle(
                                fontSize: FontSize.sp_18,
                                color: AppColor.appColor
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        endTime: controller.endTime,
                        onEnd: () {
                          controller.isTimerEnabled = false;
                        },
                        textStyle:  TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: FontSize.sp_20,
                          color: Theme.of(context).shadowColor,
                        ),
                      ),
                    )
                        : Align(
                      alignment: Alignment.center,
                          child: GestureDetector(
                      onTap: () {
                        controller.onResend(context, widget.email ?? '', widget.type ?? '',widget.mobile ?? '');
                          },
                      child: controller.resendLoading ? const CupertinoActivityIndicator(
                        color: AppColor.appColor,
                      ) : Text(
                          "Resend Code",
                          style: AppTextStyle.themeBoldNormalTextStyle(
                            fontSize: FontSize.sp_18,
                            color: AppColor.appColor
                          ),
                          textAlign: TextAlign.center,
                      ),
                    ),
                        ),
                    VerticalSpacing(height: Dimensions.h_30),
                  ],
                ),
              ),
            ), onWillPop: () async {
              pushReplacementWithSlideTransition(context, const Login());
                return false;
            },
      ),
          ),
        );
        },
    );
  }

  @override
  void dispose() {
    super.dispose();
    Get.delete<OTPController>();
  }

}
