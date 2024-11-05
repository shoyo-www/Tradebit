import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:get/get.dart';
import 'package:remove_emoji_input_formatter/remove_emoji_input_formatter.dart';
import 'package:tradebit_app/Presentation/security_verification/security_controller.dart';
import 'package:tradebit_app/Presentation/utils/validators.dart';
import 'package:tradebit_app/constants/appcolor.dart';
import 'package:tradebit_app/constants/apptextstyle.dart';
import 'package:tradebit_app/constants/constants.dart';
import 'package:tradebit_app/constants/fontsize.dart';
import 'package:tradebit_app/data/datasource/local/local_storage.dart';
import 'package:tradebit_app/widgets/common_app_bar.dart';
import 'package:tradebit_app/widgets/phone_textfield.dart';
import 'package:tradebit_app/widgets/spacing.dart';
import 'package:tradebit_app/widgets/tradeBit_scaffold.dart';
import 'package:tradebit_app/widgets/trade_bit_container.dart';
import 'package:tradebit_app/widgets/tradebit_text.dart';
import 'package:tradebit_app/widgets/tradebit_textbutton.dart';
import 'package:tradebit_app/widgets/tradebit_textfield.dart';

class SecurityOtp extends StatefulWidget {
  final String? unBindKey;
  final bool changeMobile;
  const SecurityOtp({super.key,this.unBindKey,this.changeMobile = false});

  @override
  State<SecurityOtp> createState() => _SecurityOtpState();
}

class _SecurityOtpState extends State<SecurityOtp> {
  final SecurityController securityController = Get.put(SecurityController());
  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> formKey = GlobalKey<FormState>();
    return TradeBitContainer(decoration: BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor),
        child: WillPopScope(
          onWillPop: () async {
            securityController.getBack(context);
            return false;
          },
          child: SafeArea(
              child: TradeBitScaffold(
                appBar: PreferredSize(preferredSize: Size.fromHeight(Dimensions.h_50),
                    child: TradeBitAppBar(title: widget.changeMobile ? 'Change mobile ' : 'Verify ',onTap: ()=> securityController.getBack(context))),
                  body: GetBuilder(
                    init: securityController,
                    id: ControllerBuilders.securityController,
                    builder: (controller) {
                      return SingleChildScrollView(
                        child: TradeBitContainer(
                          width: double.infinity,
                          margin: EdgeInsets.only(left: Dimensions.w_20,right: Dimensions.w_20,top: Dimensions.h_10),
                          padding: EdgeInsets.only(top: Dimensions.h_20,left: Dimensions.w_10,right: Dimensions.w_10,bottom: Dimensions.h_10),
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
                                  child: TradeBitTextWidget(textOverflow: TextOverflow.visible,title: "Recommended Don't disable security you have\nenabled.", style: AppTextStyle.normalTextStyle(
                                      FontSize.sp_13, Theme.of(context).highlightColor
                                  )),
                                ),
                                VerticalSpacing(height: Dimensions.h_5),
                                Visibility(
                                  visible: widget.changeMobile == true,
                                   child: Column(
                                  children: [
                                    VerticalSpacing(height: Dimensions.h_10),
                                    PhoneNumberTextField(
                                      onTap: ()=> controller.onShowCountryCode(context),
                                      title: 'Mobile Number',
                                      name: controller.countryCode?.countryCode ?? 'IN',
                                      phoneNumber: controller.countryCode?.phoneCode ?? '+91',
                                      hintText: " New Mobile Number",
                                      phoneController: controller.mobileController,
                                    ),
                                    Stack(
                                      children: [
                                        TradeBitTextFieldLabel(enabled : true ,
                                            hintText: '',
                                            title: "New Mobile Verification Number",
                                            controller: controller.mobileNewOtpController,
                                            hintStyle: AppTextStyle.themeBoldNormalTextStyle(
                                                color: Theme.of(context).highlightColor,
                                                fontSize: FontSize.sp_13),
                                            validator: Validator.otpValidate,
                                            textColor: Theme.of(context).highlightColor,
                                            inputFormatters: [RemoveEmojiInputFormatter()],
                                            keyboardType: TextInputType.number),
                                        Positioned(
                                          right: 5,
                                          child: controller.mobileTimer
                                              ? Align(
                                            alignment: Alignment.center,
                                            child: CountdownTimer(
                                              endWidget: GestureDetector(
                                                onTap: () {
                                                  controller.getNewMobileOtp(context);
                                                },
                                                child: controller.newMobileLoading ? const CupertinoActivityIndicator(
                                                  color: AppColor.appColor,
                                                ) : Text(
                                                  "Get Code",
                                                  style: AppTextStyle
                                                      .themeBoldNormalTextStyle(
                                                      fontSize: FontSize.sp_14,
                                                      color: AppColor.appColor),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                              endTime: controller.mobileTime,
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
                                                controller.getNewMobileOtp(context);
                                              },
                                              child: controller.newMobileLoading ? const CupertinoActivityIndicator(
                                                color: AppColor.appColor,
                                              ) : Text(
                                                "Get Code",
                                                style: AppTextStyle
                                                    .themeBoldNormalTextStyle(
                                                    fontSize: FontSize.sp_14,
                                                    color: AppColor.appColor),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),

                                  ],
                                )),
                                Visibility(
                                    visible: controller.emailOtp == 0,
                                    child: TradeBitTextFieldLabel(enabled : false ,hintText: '', title: "Email", controller: TextEditingController(text: LocalStorage.getString(GetXStorageConstants.userEmail)),hintStyle: AppTextStyle.themeBoldNormalTextStyle(color: Theme.of(context).highlightColor,fontSize: FontSize.sp_13),textColor: Theme.of(context).highlightColor)),
                                Visibility(
                                  visible: controller.emailOtp == 0,
                                  child: Stack(
                                    children: [
                                      Visibility(
                                          visible: controller.emailOtp == 0,
                                          child: TradeBitTextFieldLabel(keyboardType: const TextInputType.numberWithOptions(
                                            decimal: true
                                          ),hintText: '', title: "Email Verification Code", controller: controller.emailOtpController,textColor: Theme.of(context).highlightColor,validator: Validator.otpValidate,)),
                                      Positioned(
                                      right: 5,
                                      child: controller.isTimerEnabled
                                          ? Align(
                                              alignment: Alignment.center,
                                              child: CountdownTimer(
                                                endWidget: GestureDetector(
                                                  onTap: () {
                                                    controller.requestBindEmailOtp(context);
                                                  },
                                                  child: controller.emailLoading ? const CupertinoActivityIndicator(
                                                    color: AppColor.appColor,
                                                  ) : Text(
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
                                                  controller.requestBindEmailOtp(context);
                                                },
                                                child: controller.emailLoading ? const CupertinoActivityIndicator(
                                                  color: AppColor.appColor,
                                                ) : Text(
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
                                  visible: controller.emailOtp == 0,
                                  child: TradeBitTextWidget(title: "We have sent you verification code to ${LocalStorage.getString(GetXStorageConstants.userMobile)}", style: AppTextStyle.themeBoldNormalTextStyle(
                                      fontSize: FontSize.sp_12,
                                      color: Theme.of(context).shadowColor
                                  )),
                                ),
                                VerticalSpacing(height: Dimensions.h_10),
                                Visibility(
                                    visible: controller.smsOtp == 0,
                                    child: TradeBitTextFieldLabel(
                                        keyboardType:  TextInputType.number,enabled : false ,hintText: '', title: "Mobile", controller: TextEditingController(text: LocalStorage.getString(GetXStorageConstants.userMobile)),hintStyle: AppTextStyle.themeBoldNormalTextStyle(color: Theme.of(context).highlightColor,fontSize: FontSize.sp_13),textColor: Theme.of(context).highlightColor)),
                                Visibility(
                                  visible: controller.smsOtp == 0,
                                  child: Stack(
                                    children: [
                                      Visibility(
                                          visible: controller.smsOtp == 0,
                                          child: TradeBitTextFieldLabel(keyboardType: TextInputType.number,hintText: '', title: "Mobile Verification Code", controller: controller.mobileOtpController,textColor: Theme.of(context).highlightColor,validator: Validator.otpValidate,)),
                                      Positioned(
                                        right: 5,
                                        child: controller.mobileTimer
                                            ? Align(
                                          alignment: Alignment.center,
                                          child: CountdownTimer(
                                            endWidget: GestureDetector(
                                              onTap: () {
                                                controller.requestBindMobileOtp(context);
                                              },
                                              child: controller.mobilLoading ? const CupertinoActivityIndicator(
                                                color: AppColor.appColor,
                                              ) : Text(
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
                                            },
                                            child: controller.mobilLoading ? const CupertinoActivityIndicator(
                                              color: AppColor.appColor,
                                            ) : Text(
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
                                  visible: controller.smsOtp == 1,
                                  child: Stack(
                                    children: [
                                      Visibility(
                                        visible: controller.smsOtp == 1,
                                          child: TradeBitTextFieldLabel(keyboardType: TextInputType.number,hintText: '', title: "Mobile Verification Code", controller: controller.mobileOtpController,textColor: Theme.of(context).highlightColor,validator: Validator.otpValidate,)),
                                      Positioned(
                                        right: 5,
                                        child: controller.mobileTimer
                                            ? Align(
                                          alignment: Alignment.center,
                                          child: CountdownTimer(
                                            endWidget: GestureDetector(
                                              onTap: () {
                                                controller.requestBindMobileOtp(context);
                                              },
                                              child: controller.mobilLoading ? const CupertinoActivityIndicator(
                                                color: AppColor.appColor,
                                              ):Text(
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
                                            },
                                            child: controller.mobilLoading ? const CupertinoActivityIndicator(
                                              color: AppColor.appColor,
                                            ):Text(
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
                                TradeBitTextWidget(title: "We have sent you verification code to ${LocalStorage.getString(GetXStorageConstants.userMobile)}", style: AppTextStyle.themeBoldNormalTextStyle(
                                    fontSize: FontSize.sp_12,
                                    color: Theme.of(context).shadowColor
                                )),
                                Visibility(
                                  visible: controller.emailOtp == 1,
                                    child: VerticalSpacing(height: Dimensions.h_10)),
                                Visibility(
                                  visible: controller.emailOtp == 1,
                                  child: Stack(
                                    children: [
                                      Visibility(
                                          visible: controller.emailOtp == 1,
                                          child: Column(
                                            children: [
                                              TradeBitTextFieldLabel(keyboardType:  TextInputType.number,hintText: '', title: "Email Verification Code", controller: controller.emailOtpController,textColor: Theme.of(context).highlightColor,validator: Validator.otpValidate,),
                                              TradeBitTextWidget(textOverflow: TextOverflow.visible,title: "We have sent you verification code to ${controller.email}", style: AppTextStyle.themeBoldNormalTextStyle(
                                                  fontSize: FontSize.sp_12,
                                                  color: Theme.of(context).shadowColor
                                              )),
                                              VerticalSpacing(height: Dimensions.h_15),
                                            ],
                                          )),

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
                                              child: controller.emailLoading ? const CupertinoActivityIndicator(
                                                color: AppColor.appColor,
                                              ) :Text(
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
                                            },
                                            child: controller.emailLoading ? const CupertinoActivityIndicator(
                                              color: AppColor.appColor,
                                            ) : Text(
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
                                  visible: controller.google2Fa == 1,
                                    child: TradeBitTextFieldLabel(keyboardType: TextInputType.number,hintText: '', title: "Google Authenticator Code", controller: controller.googleOtpController,textColor: Theme.of(context).highlightColor,validator: Validator.otpValidate,)),
                                VerticalSpacing(height: Dimensions.h_5),
                                TradeBitTextButton(
                                  loading: controller.isLoading,
                                    labelName: 'Confirm', onTap: () {
                                    if(formKey.currentState!.validate()) {
                                      if(widget.changeMobile == true) {
                                        controller.isLoading ? null :controller.changeNumber(context);
                                      } else if(widget.unBindKey == 'email') {
                                        controller.emailOtp == 1 ? (controller.isLoading ? null : controller.unBindEmail(context)): (controller.isLoading ? null : controller.bindEmailOtp(context));
                                      } else if(widget.unBindKey == 'google') {
                                        controller.isLoading ? null : controller.unBindGoogle2Fa(context) ;
                                      }
                                      else {
                                        controller.smsOtp == 1 ? (controller.isLoading ? null : controller.unBindMobile(context)): (controller.isLoading ? null : controller.bindMobile(context));
                                      }
                                    }

                                    },margin: EdgeInsets.zero,height: Dimensions.h_40),
                                VerticalSpacing(height: Dimensions.h_10),
                              ],
                            ),
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
