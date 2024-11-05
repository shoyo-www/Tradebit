import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:tradebit_app/Presentation/Wallet/withdraw/withdraw_controller.dart';
import 'package:tradebit_app/Presentation/utils/validators.dart';
import 'package:tradebit_app/constants/appcolor.dart';
import 'package:tradebit_app/constants/apptextstyle.dart';
import 'package:tradebit_app/constants/constants.dart';
import 'package:tradebit_app/constants/fontsize.dart';
import 'package:tradebit_app/widgets/common_app_bar.dart';
import 'package:tradebit_app/widgets/spacing.dart';
import 'package:tradebit_app/widgets/tradeBit_scaffold.dart';
import 'package:tradebit_app/widgets/trade_bit_container.dart';
import 'package:tradebit_app/widgets/tradebit_text.dart';
import 'package:tradebit_app/widgets/tradebit_textbutton.dart';

class WithDrawVerify extends StatefulWidget {
  const WithDrawVerify({super.key});

  @override
  State<WithDrawVerify> createState() => _WithDrawVerifyState();
}

class _WithDrawVerifyState extends State<WithDrawVerify> {
  final WithDrawController withDrawController = Get.put(WithDrawController());
  String? currency;
  GlobalKey<FormState> globalKey = GlobalKey<FormState>();

  @override
  void initState() {
    currency = Get.arguments['currency'];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: withDrawController,
      id: ControllerBuilders.withdrawController,
      builder: (controller) {
        return TradeBitContainer(
          decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor
          ),
          child: SafeArea(
            child: TradeBitScaffold(
                appBar: PreferredSize(preferredSize: Size.fromHeight(Dimensions.h_55), child: TradeBitAppBar(title: 'Verify Withdraw',onTap: () {
               controller.getBack();
                },
                )),
                body: TradeBitContainer(
                  padding: EdgeInsets.only(left: Dimensions.w_10,right: Dimensions.w_10),
                  margin: EdgeInsets.only(left: Dimensions.h_15,right: Dimensions.h_15,top: Dimensions.h_50),
                  decoration:  BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(15)
                  ),
                  child: Form(
                    key: globalKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        VerticalSpacing(height: Dimensions.h_20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TradeBitTextWidget(
                                title: 'Email otp', style: AppTextStyle.normalTextStyle(  FontSize.sp_15,Theme.of(context).highlightColor)),
                            GestureDetector(
                                onTap: () {
                                  controller.onGetCode(context);
                                },
                                child:  controller.isTimerEnabled ? CountdownTimer(
                                  endWidget: GestureDetector(
                                    onTap: () {
                                      controller.onGetCode(context);
                                    },
                                    child: controller.emailLoading ? const CupertinoActivityIndicator(
                                      color: AppColor.appColor,
                                    ) :const Text(
                                      "Resend New Code",
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: AppColor.appColor,
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
                                    fontSize: FontSize.sp_14,
                                    color: Theme.of(context).shadowColor,
                                  ),
                                ) : controller.emailLoading ? CupertinoActivityIndicator(
                                  radius: Dimensions.h_10,
                                  color: AppColor.appColor,
                                ) : TradeBitTextWidget(title: 'Get Code', style: AppTextStyle.themeBoldNormalTextStyle(fontSize: FontSize.sp_13,color: AppColor.appColor)))
                          ],
                        ),
                        VerticalSpacing(height: Dimensions.h_10),
                        PinCodeTextField(
                          autoDisposeControllers: false,
                          errorTextSpace: 22,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: Validator.otpValidate,
                          keyboardType: TextInputType.number,
                          autoFocus: false,
                          length: 6,
                          obscureText: false,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          animationType: AnimationType.fade,
                          pinTheme: PinTheme(
                            errorBorderColor: AppColor.red,
                            borderWidth: 1,
                            selectedColor: Theme.of(context).highlightColor,
                            selectedFillColor: Theme.of(context).cardColor,
                            inactiveColor: Theme.of(context).shadowColor,
                            activeColor: Theme.of(context).cardColor,
                            activeFillColor: Theme.of(context).cardColor,
                            inactiveFillColor: Theme.of(context).cardColor,
                            shape: PinCodeFieldShape.box,
                            borderRadius: BorderRadius.circular(10),
                            fieldHeight: Dimensions.h_45,
                            fieldWidth: Dimensions.w_45,
                          ),
                          animationDuration: const Duration(milliseconds: 300),
                          controller: controller.email,
                          onCompleted: (v) {},
                          onChanged: (value) {},
                          appContext: context,
                        ),
                        VerticalSpacing(height: Dimensions.h_20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TradeBitTextWidget(
                                title: 'Mobile otp', style: AppTextStyle.normalTextStyle(  FontSize.sp_15,Theme.of(context).highlightColor)),
                            GestureDetector(
                                onTap: () {
                                 controller.mobileLoading ? null : controller.onMobileGetCode(context);
                                },
                                child:  controller.isTimerMobileEnabled ? CountdownTimer(
                                  endWidget: GestureDetector(
                                    onTap: () {
                                      controller.onMobileGetCode(context);
                                    },
                                    child: controller.mobileLoading ? CupertinoActivityIndicator(
                                      color: AppColor.appColor,
                                    ) :const Text(
                                      "Resend New Code",
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: AppColor.appColor,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  endTime: controller.mobileEnd,
                                  onEnd: () {
                                    controller.isTimerMobileEnabled = false;
                                  },
                                  textStyle:  TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: FontSize.sp_14,
                                    color: Theme.of(context).shadowColor,
                                  ),
                                ) : controller.mobileLoading ? CupertinoActivityIndicator(
                                  radius: Dimensions.h_10,
                                  color: AppColor.appColor,
                                ) : TradeBitTextWidget(title: 'Get Code', style: AppTextStyle.themeBoldNormalTextStyle(fontSize: FontSize.sp_13,color: AppColor.appColor)))
                          ],
                        ),
                        VerticalSpacing(height: Dimensions.h_10),
                        PinCodeTextField(
                          autoDisposeControllers: false,
                          errorTextSpace: 22,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: Validator.otpValidate,
                          keyboardType: TextInputType.number,
                          autoFocus: false,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
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
                          controller: controller.mobile,
                          onCompleted: (v) {},
                          onChanged: (value) {},
                          appContext: context,
                        ),
                        VerticalSpacing(height: Dimensions.h_20),
                        TradeBitTextWidget(
                            title: 'Authenticator code', style: AppTextStyle.normalTextStyle(  FontSize.sp_15,Theme.of(context).highlightColor)),
                        VerticalSpacing(height: Dimensions.h_10),
                        PinCodeTextField(
                          autoDisposeControllers: false,
                          errorTextSpace: 22,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: Validator.otpValidate,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
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
                          controller: controller.google,
                          onCompleted: (v) {},
                          onChanged: (value) {},
                          appContext: context,
                        ),
                        VerticalSpacing(height: Dimensions.h_30),
                        TradeBitTextButton(
                            labelName: 'Submit',
                            onTap: () {
                              if(globalKey.currentState!.validate()) {
                              controller.buttonLoading ? null : controller.verifyWithdraw(context,currency ?? '');
                              }
                              }, color: AppColor.appColor,
                            height: Dimensions.h_40,
                            margin: EdgeInsets.zero,
                            loading: controller.buttonLoading),
                        VerticalSpacing(height: Dimensions.h_20),

                      ],
                    ),
                  ),
                )),
          ),
        );
      },
    );
  }
}
