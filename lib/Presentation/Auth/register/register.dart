import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remove_emoji_input_formatter/remove_emoji_input_formatter.dart';
import 'package:tradebit_app/Presentation/Auth/login/login.dart';
import 'package:tradebit_app/Presentation/Auth/register/register_controller.dart';
import 'package:tradebit_app/Presentation/dashboard/dashboard.dart';
import 'package:tradebit_app/Presentation/utils/validators.dart';
import 'package:tradebit_app/constants/appcolor.dart';
import 'package:tradebit_app/constants/apptextstyle.dart';
import 'package:tradebit_app/constants/constants.dart';
import 'package:tradebit_app/constants/fontsize.dart';
import 'package:tradebit_app/data/datasource/local/local_storage.dart';
import 'package:tradebit_app/widgets/common_app_bar.dart';
import 'package:tradebit_app/widgets/email_phone_button.dart';
import 'package:tradebit_app/widgets/phone_textfield.dart';
import 'package:tradebit_app/widgets/spacing.dart';
import 'package:tradebit_app/widgets/tradeBit_scaffold.dart';
import 'package:tradebit_app/widgets/trade_bit_container.dart';
import 'package:tradebit_app/widgets/trade_bit_passwordfield.dart';
import 'package:tradebit_app/widgets/tradebit_text.dart';
import 'package:tradebit_app/widgets/tradebit_textbutton.dart';
import 'package:tradebit_app/widgets/tradebit_textfield.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
final RegisterController registerController = Get.put(RegisterController());

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: TradeBitContainer(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor
        ),
        child: SafeArea(
          child: TradeBitScaffold(
            appBar: PreferredSize(preferredSize: Size.fromHeight(Dimensions.h_55), child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TradeBitAppBar(title: '',onTap: ()=> pushReplacementWithSlideTransition(context, const Login(),isBack: true)),
                GestureDetector(
                  onTap: () {
                    pushReplacementWithSlideTransition(context, const Login(),isBack: true);
                  },
                  child: Padding(
                    padding:  EdgeInsets.only(right: Dimensions.w_15),
                    child: TradeBitTextWidget(title: 'Login Account', style: AppTextStyle.themeBoldNormalTextStyle(
                      fontSize: FontSize.sp_18,
                      color: AppColor.appColor
                    )),
                  ),
                )
              ],
            )),
              body: GetBuilder<RegisterController>(
                  id: ControllerBuilders.registerController,
                  init: registerController,
                  builder: (controller) {
                    return SingleChildScrollView(
                      child: Form(
                        key: controller.registerKey,
                        child: Padding(
                          padding: EdgeInsets.only(left: Dimensions.w_20,right: Dimensions.w_20,top: Dimensions.h_10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                             TradeBitTextWidget(title: 'Create Tradebit Account', style: AppTextStyle.themeBoldTextStyle(
                               fontSize: FontSize.sp_22,
                               color: Theme.of(context).highlightColor
                             )),
                              VerticalSpacing(height: Dimensions.h_5),
                              TradeBitTextWidget(title: 'Join the revolution', style: AppTextStyle.normalTextStyle(
                                  FontSize.sp_16,
                                   Theme.of(context).shadowColor
                              )),
                              TradeBitContainer(
                                decoration: const BoxDecoration(
                                  color: Colors.transparent
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    VerticalSpacing(height: Dimensions.h_20),
                                    Row(
                                      children: [
                                        EmailPhoneButton(
                                          title: "Email",
                                          isSelected: controller.isEmail,
                                          onTap: () {
                                            controller.emailButton(context);
                                          },
                                        ),
                                        HorizontalSpacing(width: Dimensions.h_10),
                                        EmailPhoneButton(
                                          title: "Mobile Number",
                                          isSelected: controller.isPhone,
                                          onTap: () {
                                            controller.phoneButton();
                                          },
                                        ),
                                      ],
                                    ),
                                    VerticalSpacing(height: Dimensions.h_20),
                                    controller.isPhone
                                        ? PhoneNumberTextField(
                                      onTap: () {
                                        controller.onShowCountryCode(context);
                                      },
                                            title: 'Mobile Number',
                                            name: controller.countryCode?.countryCode ?? "IN",
                                            phoneNumber: controller.countryCode?.phoneCode ?? '+91',
                                            hintText: "Phone Number",
                                            phoneController: controller.phoneController,
                                          )
                                        : TradeBitTextField(
                                            title: 'Email',
                                            hintText: 'Email Address',
                                            validator: Validator.emailValidate,
                                            controller: controller.emailController,
                                          ),
                                    TradeBitPasswordTextField(
                                      obscureText: controller.closeEye,
                                      title: 'Password',
                                      hintText: 'Password',
                                      controller: controller.passwordController,
                                      suffixIcon: Padding(
                                        padding: const EdgeInsets.only(right: 8.0),
                                        child: IconButton(
                                            splashColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            onPressed: () {
                                              controller.changeEye();
                                            },
                                            icon: Icon(
                                                controller.closeEye
                                                    ? Icons.visibility
                                                    : Icons.visibility_off,
                                                color: Theme.of(context).shadowColor.withOpacity(0.4))),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        TradeBitTextWidget(
                                            title: "Invited by (ID)",
                                            style: AppTextStyle.themeBoldTextStyle(
                                                fontSize: FontSize.sp_16,color: Theme.of(context).shadowColor.withOpacity(0.8))),
                                        IconButton(
                                            splashColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            onPressed: () {
                                              controller.invitedButtonClicked();
                                            },
                                            icon: Icon(
                                              controller.invitedClicked
                                                  ? Icons.arrow_drop_up
                                                  : Icons.arrow_drop_down,
                                              color: Theme.of(context).shadowColor.withOpacity(0.8),
                                            ))
                                      ],
                                    ),
                                    Visibility(
                                        visible: controller.invitedClicked,
                                        child: TextFormField(
                                          inputFormatters: [RemoveEmojiInputFormatter()],
                                          decoration: InputDecoration(
                                            filled: true,
                                              fillColor: Theme.of(context).cardColor,
                                              enabledBorder: OutlineInputBorder(
                                                  borderSide:  BorderSide(
                                                      color: Theme.of(context).shadowColor.withOpacity(0.3)),
                                                  borderRadius: BorderRadius.circular(12)),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide:
                                                     BorderSide(color: Theme.of(context).shadowColor.withOpacity(0.3)),
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              border: OutlineInputBorder(
                                                borderSide:
                                                     BorderSide(color: Theme.of(context).shadowColor.withOpacity(0.3)),
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              hintText: "Inviter UID (optional)",
                                              hintStyle: AppTextStyle.normalTextStyle(
                                                  FontSize.sp_13, Theme.of(context).shadowColor.withOpacity(0.4))),
                                        )),
                                    controller.invitedClicked
                                        ? VerticalSpacing(height: Dimensions.h_15)
                                        : VerticalSpacing(height: Dimensions.h_8),
                                    Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            controller.agreeButton();
                                          },
                                          child: Container(
                                            margin: const EdgeInsets.only(top: 3),
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(4),
                                                color: controller.agreeButtonTapped ? AppColor.appColor : AppColor.transparent,
                                                border: Border.all(color: controller.agreeButtonTapped ? AppColor.appColor : Theme.of(context).shadowColor)),
                                            height: Dimensions.h_12,
                                            width: Dimensions.h_12,
                                          ),
                                        ),
                                        HorizontalSpacing(width: Dimensions.h_5),
                                        TradeBitTextWidget(
                                            title: "I have read and Agree to ",
                                            style: AppTextStyle.bodyMediumTextStyle(
                                                color: AppColor.greyColor)),
                                        Expanded(
                                          child: TradeBitTextWidget(
                                              title: "Tradebit User Agreement",
                                              style: AppTextStyle.bodyMediumTextStyle(
                                                  color: Theme.of(context).highlightColor)),
                                        ),
                                        TradeBitTextWidget(
                                            title: " and",
                                            style: AppTextStyle.bodyMediumTextStyle(
                                                color: AppColor.greyColor)),

                                      ],
                                    ),
                                    Padding(
                                      padding:  EdgeInsets.only(left: Dimensions.w_20),
                                      child: TradeBitTextWidget(
                                          title: "Privacy policy",
                                          style: AppTextStyle.bodyMediumTextStyle(
                                              color: Theme.of(context).highlightColor)),
                                    ),
                                    VerticalSpacing(height: Dimensions.h_20),
                                    TradeBitTextButton(
                                      loading: controller.isLoading,
                                      height: Dimensions.h_40,
                                      labelName: "Sign Up",
                                      style: AppTextStyle.buttonTextStyle(
                                          color: AppColor.white),
                                      onTap: () {
                                        if(controller.registerKey.currentState!.validate())
                                          {controller.isPhone
                                                ? controller.registerByMobile(context)
                                                : controller.registerByEmail(context);
                                          }
                                        },
                                      margin: EdgeInsets.zero,
                                      color: AppColor.appColor,
                                    ),
                                    VerticalSpacing(height: Dimensions.h_15),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  })),
        ),
      ),
    );
  }

@override
void dispose() {
  super.dispose();
  Get.delete<RegisterController>();
}
}
