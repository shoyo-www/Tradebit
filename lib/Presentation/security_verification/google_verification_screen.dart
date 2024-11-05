import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tradebit_app/Presentation/dashboard/dashboard.dart';
import 'package:tradebit_app/Presentation/security_verification/security_controller.dart';
import 'package:tradebit_app/Presentation/security_verification/security_verification.dart';
import 'package:tradebit_app/constants/apptextstyle.dart';
import 'package:tradebit_app/constants/constants.dart';
import 'package:tradebit_app/constants/fontsize.dart';
import 'package:tradebit_app/constants/images.dart';
import 'package:tradebit_app/widgets/common_app_bar.dart';
import 'package:tradebit_app/widgets/spacing.dart';
import 'package:tradebit_app/widgets/tradeBit_scaffold.dart';
import 'package:tradebit_app/widgets/trade_bit_container.dart';
import 'package:tradebit_app/widgets/tradebit_text.dart';
import 'package:tradebit_app/widgets/tradebit_textbutton.dart';
import 'package:tradebit_app/widgets/tradebit_textfield.dart';

class GoogleVerificationScreen extends StatefulWidget {
  const GoogleVerificationScreen({super.key});

  @override
  State<GoogleVerificationScreen> createState() => _GoogleVerificationScreenState();
}

class _GoogleVerificationScreenState extends State<GoogleVerificationScreen> {
  final SecurityController securityController = Get.put(SecurityController());

  @override
  Widget build(BuildContext context) {
    return  WillPopScope(
      onWillPop: () async {
        securityController.getBack(context);
        return false;
      },
      child: TradeBitContainer(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor
        ),
        child: SafeArea(
          child: TradeBitScaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(Dimensions.h_50),
            child: TradeBitAppBar(title: 'Google Authenticator',onTap: ()=> securityController.getBack(context)),
          ),
            body: SingleChildScrollView(
              child: GetBuilder(
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TradeBitTextWidget(title: 'Add Extra Layer of security is quickly and\neasy, to keep more secure.', style: AppTextStyle.normalTextStyle(FontSize.sp_12, Theme.of(context).shadowColor)),
                        VerticalSpacing(height: Dimensions.h_30),
                        Align(
                            alignment: Alignment.center,
                            child: TradeBitContainer(
                              height: Dimensions.h_150,
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    color: Theme.of(context).scaffoldBackgroundColor
                                ),
                                child: Image.memory(controller.googleImage!))),
                        VerticalSpacing(height: Dimensions.h_15),
                        TradeBitTextWidget(title: 'If you are unable to scan this QR code, you can enter\nthis code manually.', style: AppTextStyle.normalTextStyle(FontSize.sp_12, Theme.of(context).shadowColor)),
                        VerticalSpacing(height: Dimensions.h_15),
                        TradeBitContainer(
                          margin: EdgeInsets.only(right: Dimensions.w_10),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Theme.of(context).scaffoldBackgroundColor,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(child: TradeBitTextWidget(title: controller.secretKey ?? '', style: AppTextStyle.normalTextStyle(FontSize.sp_14,Theme.of(context).highlightColor))),
                              GestureDetector(
                                  onTap: () {
                                    controller.onCopyClipBoard(context);
                                  },
                                  child: Image.asset(Images.share_light,scale: 2.7)),
                            ],
                          ),
                        ),
                        VerticalSpacing(height: Dimensions.h_20),
                        TradeBitTextFieldLabel(hintText: '', title: "Enter Verification Code", controller: controller.googleOtpController,textColor: Theme.of(context).highlightColor,),
                        Padding(
                          padding: const EdgeInsets.only(left: 4.0),
                          child: TradeBitTextWidget(title: "Please enter the 6-digit verification code shown\nin Google Authenticator", style: AppTextStyle.normalTextStyle(
                              FontSize.sp_12,
                              Theme.of(context).shadowColor
                          )),
                        ),
                        VerticalSpacing(height: Dimensions.h_30),
                        TradeBitTextButton(labelName: 'Confirm', onTap: () {
                          controller.googleOtp(context);
                        },margin: EdgeInsets.zero,height: Dimensions.h_40)
                      ],
                    ),
                  );
                },
              ),
            ))
        ),
      ),
    );
  }

  @override
  void dispose() {
    Get.delete<SecurityController>();
    super.dispose();
  }
}
