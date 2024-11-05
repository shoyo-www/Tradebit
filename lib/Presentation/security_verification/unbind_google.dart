import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/index.dart';
import 'package:get/get.dart';
import 'package:tradebit_app/Presentation/security_verification/security_controller.dart';
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
import 'package:tradebit_app/widgets/tradebit_textfield.dart';

class UnBindGoogle extends StatefulWidget {
  const UnBindGoogle({super.key});

  @override
  State<UnBindGoogle> createState() => _UnBindGoogleState();
}

class _UnBindGoogleState extends State<UnBindGoogle> {
  final SecurityController securityController = Get.put(SecurityController());
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return  WillPopScope(
      onWillPop: () async {
        securityController.getBack(context);
        return false;
      },
      child: TradeBitContainer(decoration: BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor),
        child: SafeArea(
            child: TradeBitScaffold(
                appBar: PreferredSize(preferredSize: Size.fromHeight(Dimensions.h_50),
                    child: TradeBitAppBar(title: 'Verify ',onTap: ()=> securityController.getBack(context)
                    )),
                body: GetBuilder(
                  init: securityController,
                  id: ControllerBuilders.securityController,
                  builder: (controller) {
                    return TradeBitContainer(
                      width: double.infinity,
                      margin: EdgeInsets.only(left: Dimensions.w_20,right: Dimensions.w_20,top: Dimensions.h_30),
                      padding: EdgeInsets.only(top: Dimensions.h_20,left: Dimensions.w_10,right: Dimensions.w_10,bottom: Dimensions.h_20),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Theme.of(context).cardColor
                      ),
                      child: Form(
                        key: formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 4.0),
                              child: TradeBitTextWidget(title: "Recommended Don't disable security you have\nenabled.", style: AppTextStyle.normalTextStyle(
                                  FontSize.sp_13, Theme.of(context).highlightColor
                              )),
                            ),
                            Visibility(
                              visible: controller.smsOtp == 1,
                              child: Stack(
                                children: [
                                  Visibility(
                                      visible: controller.smsOtp == 1,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          VerticalSpacing(height: Dimensions.h_10),
                                          TradeBitTextFieldLabel(keyboardType: TextInputType.number,hintText: '', title: "Mobile Verification Code", controller: controller.mobileOtpController,textColor: Theme.of(context).highlightColor,validator: Validator.otpValidate,),
                                          TradeBitTextWidget(textOverflow: TextOverflow.visible,title: "We have sent you verification code to ${controller.mobile}", style: AppTextStyle.themeBoldNormalTextStyle(
                                              fontSize: FontSize.sp_12,
                                              color: Theme.of(context).shadowColor
                                          )),
                                        ],
                                      )),
                                  Positioned(
                                    right: 5,
                                    top: Dimensions.h_10,
                                    child: controller.mobileTimer
                                        ? Align(
                                      alignment: Alignment.center,
                                      child: CountdownTimer(
                                        endWidget: GestureDetector(
                                          onTap: () {
                                            controller.requestBindMobileOtp(context);
                                            controller.startTimerMobile();
                                          },
                                          child: Text(
                                            "Get Code",
                                            style: AppTextStyle
                                                .themeBoldNormalTextStyle(
                                                fontSize: FontSize.sp_14,
                                                color: AppColor.appColor),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        endTime: controller.endTimeMobile,
                                        onEnd: () {
                                          controller.mobileTimer = false;
                                        },
                                        textStyle: AppTextStyle
                                            .themeBoldNormalTextStyle(
                                            fontSize: FontSize.sp_14,
                                            color: Theme.of(context).shadowColor),
                                      ),
                                    )
                                        : Align(
                                      alignment: Alignment.center,
                                      child: GestureDetector(
                                        onTap: () {
                                          controller.requestBindMobileOtp(context);
                                          controller.mobileTimer = true;
                                          controller.startTimerMobile();
                                        },
                                        child: Text(
                                          "Get Code",
                                          style: AppTextStyle
                                              .themeBoldNormalTextStyle(
                                              fontSize: FontSize.sp_14,
                                              color: AppColor.appColor),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Visibility(
                                visible: controller.emailOtp == 1,
                                child: VerticalSpacing(height: Dimensions.h_10)),
                            Visibility(
                              visible: controller.emailOtp == 1,
                              child: Stack(
                                children: [
                                  Column(
                                    children: [
                                      Visibility(
                                          visible: controller.emailOtp == 1,
                                          child: TradeBitTextFieldLabel(keyboardType:  TextInputType.number,hintText: '', title: "Email Verification Code", controller: controller.emailOtpController,textColor: Theme.of(context).highlightColor,validator: Validator.otpValidate,)),
                                      TradeBitTextWidget(textOverflow: TextOverflow.visible,title: "We have sent you verification code to ${controller.email}", style: AppTextStyle.themeBoldNormalTextStyle(
                                          fontSize: FontSize.sp_12,
                                          color: Theme.of(context).shadowColor
                                      )),
                                      VerticalSpacing(height: Dimensions.h_20),
                                    ],
                                  ),
                                  Positioned(
                                    right: 5,
                                    child: controller.isTimerEnabled
                                        ? Align(
                                      alignment: Alignment.center,
                                      child: CountdownTimer(
                                        endWidget: GestureDetector(
                                          onTap: () {
                                            controller.emailOtp == 1 ? controller.requestBindEmailOtp(context) : null;
                                          },
                                          child: Text(
                                            "Get Code",
                                            style: AppTextStyle
                                                .themeBoldNormalTextStyle(
                                                fontSize: FontSize.sp_14,
                                                color: AppColor.appColor),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        endTime: controller.endTime,
                                        onEnd: () {
                                          controller.isTimerEnabled = false;
                                        },
                                        textStyle: AppTextStyle
                                            .themeBoldNormalTextStyle(
                                            fontSize: FontSize.sp_14,
                                            color: Theme.of(context).shadowColor),
                                      ),
                                    )
                                        : Align(
                                      alignment: Alignment.center,
                                      child: GestureDetector(
                                        onTap: () {
                                          controller.emailOtp == 1 ? controller.requestBindEmailOtp(context) : null;
                                          controller.isTimerEnabled = true;
                                          controller.startTimer();
                                        },
                                        child: Text(
                                          "Get Code",
                                          style: AppTextStyle
                                              .themeBoldNormalTextStyle(
                                              fontSize: FontSize.sp_14,
                                              color: AppColor.appColor),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            TradeBitTextFieldLabel(keyboardType:  TextInputType.number,hintText: '', title: "Google Authenticator Code", controller: controller.googleOtpController,textColor: Theme.of(context).highlightColor,validator: Validator.otpValidate,),
                            VerticalSpacing(height: Dimensions.h_30),
                            TradeBitTextButton(
                                loading: controller.isLoading,
                                labelName: 'Confirm', onTap: () {
                              if(formKey.currentState!.validate()) {
                                controller.unBindGoogle2Fa(context);
                              }

                            },margin: EdgeInsets.zero,height: Dimensions.h_40),
                            VerticalSpacing(height: Dimensions.h_5),
                          ],
                        ),
                      ),
                    );
                  },
                ))
        ),
      ),
    );
  }
}
