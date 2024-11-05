import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tradebit_app/Presentation/Auth/Forget_password/forget_controller.dart';
import 'package:tradebit_app/Presentation/utils/validators.dart';
import 'package:tradebit_app/approutes.dart';
import 'package:tradebit_app/constants/appcolor.dart';
import 'package:tradebit_app/constants/apptextstyle.dart';
import 'package:tradebit_app/constants/constants.dart';
import 'package:tradebit_app/constants/fontsize.dart';
import 'package:tradebit_app/widgets/common_app_bar.dart';
import 'package:tradebit_app/widgets/email_phone_button.dart';
import 'package:tradebit_app/widgets/spacing.dart';
import 'package:tradebit_app/widgets/tradeBit_scaffold.dart';
import 'package:tradebit_app/widgets/trade_bit_container.dart';
import 'package:tradebit_app/widgets/tradebit_text.dart';
import 'package:tradebit_app/widgets/tradebit_textbutton.dart';
import 'package:tradebit_app/widgets/tradebit_textfield.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {

  final ForgotController forgotController = Get.put(ForgotController());

  @override
  Widget build(BuildContext context) {
    return  GetBuilder<ForgotController>(
      id: ControllerBuilders.forgotController,
      init: forgotController,
      builder: (controller) {
        return TradeBitContainer(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor
          ),
          child: SafeArea(
            child: WillPopScope(
              onWillPop: () async => false,
              child: TradeBitScaffold(
                appBar: PreferredSize(preferredSize: Size.fromHeight(Dimensions.h_55),
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TradeBitAppBar(title: 'Forgot Password',onTap: ()=> Navigator.pop(context)),
                    GestureDetector(
                      onTap: () {
                        Get.toNamed(AppRoutes.loginScreen);
                      },
                      child: Padding(
                        padding:  EdgeInsets.only(right: Dimensions.w_15),
                        child: TradeBitTextWidget(title: 'Login Account', style: AppTextStyle.themeBoldNormalTextStyle(
                            fontSize: FontSize.sp_12,
                            color: AppColor.appColor
                        )),
                      ),
                    )
                  ],
                )),
                  body: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TradeBitContainer(
                          decoration: const BoxDecoration(),
                        child: Padding(
                            padding:
                            EdgeInsets.only(
                                left: Dimensions.h_15, right: Dimensions.h_15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                VerticalSpacing(height: Dimensions.h_40),
                                Row(
                                  children: [
                                    EmailPhoneButton(
                                      title: "Email",
                                      isSelected: controller.isEmail,
                                      onTap: () {
                                      },
                                    ),
                                    HorizontalSpacing(width: Dimensions.h_10),
                                  ],
                                ),
                                VerticalSpacing(height: Dimensions.h_15),
                                TradeBitTextField(
                                  keyboardType: TextInputType.emailAddress,
                                  title: 'Email',
                                  hintText: 'Email',
                                  validator: Validator.emailValidate,
                                  controller: controller.emailTextController),
                                VerticalSpacing(height: Dimensions.h_10),
                                TradeBitTextButton(
                                  loading: controller.loading,
                                  labelName: "Send Link",
                                  style: AppTextStyle.buttonTextStyle(
                                      color: AppColor.white),
                                  onTap: () {
                                    controller.isPhone
                                          ? controller.forgotMobile(context)
                                          : controller.forgotByEmail(context);
                                  },
                                  margin: EdgeInsets.zero,
                                  color: AppColor.appColor,
                                ),
                                VerticalSpacing(height: Dimensions.h_15),
                                TradeBitTextWidget(
                                  textAlign: TextAlign.center,
                                    textOverflow: TextOverflow.visible,
                                    maxLines: 2,
                                    title: 'You will receive an email with further  instructions at the email address you provided.',
                                    style: AppTextStyle.normalTextStyle(FontSize.sp_16, Theme.of(context).shadowColor)),
                                VerticalSpacing(height: Dimensions.h_65),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
            ),
          ),
        );
      }
    );
  }

  @override
  void dispose() {
    super.dispose();
    Get.delete<ForgotController>();
  }
}
