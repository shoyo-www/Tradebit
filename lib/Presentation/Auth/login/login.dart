import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tradebit_app/Presentation/Auth/login/login_contoller.dart';
import 'package:tradebit_app/Presentation/Auth/register/register.dart';
import 'package:tradebit_app/Presentation/dashboard/dashboard.dart';
import 'package:tradebit_app/Presentation/utils/validators.dart';
import 'package:tradebit_app/approutes.dart';
import 'package:tradebit_app/constants/appcolor.dart';
import 'package:tradebit_app/constants/apptextstyle.dart';
import 'package:tradebit_app/constants/constants.dart';
import 'package:tradebit_app/constants/fontsize.dart';
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

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final LoginController _loginPageController = Get.put(LoginController());
  GlobalKey<FormState> loginKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    return  GetBuilder<LoginController>(
            init: _loginPageController,
            id: ControllerBuilders.loginPageController,
            builder: (controller) {
              return WillPopScope(
                onWillPop: () async {
                  pushReplacementWithSlideTransition(context,  DashBoard(index: 0),isBack: true);
                  return false;
                }  ,
                child: TradeBitContainer(
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor
                  ),
                  child: SafeArea(
                    child: TradeBitScaffold(
                      appBar: PreferredSize(preferredSize: Size.fromHeight(Dimensions.h_55), child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TradeBitAppBar(title: '', onTap: () {
                        pushReplacementWithSlideTransition(context,  DashBoard(index: 0),isBack: true);
                      }
                      ),
                      GestureDetector(
                        onTap: () {
                          pushReplacementWithSlideTransition(context, const RegisterPage());
                        },
                        child: Padding(
                          padding:  EdgeInsets.only(right: Dimensions.w_15),
                          child: TradeBitTextWidget(title: 'Sign Up', style: AppTextStyle.themeBoldNormalTextStyle(
                              fontSize: FontSize.sp_18,
                              color: AppColor.appColor
                          )),
                        ),
                      )
                    ],
                    )),
                      isLoading: controller.isLoading,
                      body: Form(
                        key: loginKey,
                        child:  Column(
                            children: [
                              SingleChildScrollView(
                                child: Padding(
                                  padding: EdgeInsets.only(left: Dimensions.w_25,right: Dimensions.w_25),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      TradeBitTextWidget(title: 'Tradebit Login', style: AppTextStyle.themeBoldTextStyle(
                                          fontSize: FontSize.sp_24,
                                          color: Theme.of(context).highlightColor
                                      )),
                                      VerticalSpacing(height: Dimensions.h_5),
                                      TradeBitTextWidget(title: 'Join the revolution', style: AppTextStyle.normalTextStyle(
                                          FontSize.sp_16,
                                          Theme.of(context).shadowColor
                                      )),
                                      VerticalSpacing(height: Dimensions.h_15),
                                      Row(
                                        children: [
                                          EmailPhoneButton(
                                            title: "Email",
                                            isSelected: controller.isEmail,
                                            onTap: () {
                                              controller.emailButton(context);
                                            },
                                          ),
                                          HorizontalSpacing(width: Dimensions.h_20),
                                          EmailPhoneButton(
                                            title: "Mobile Number",
                                            isSelected: controller.isPhone,
                                            onTap: () {
                                              controller.phoneButton(context);
                                            },
                                          ),
                                        ],
                                      ),
                                      VerticalSpacing(height: Dimensions.h_20),
                                      controller.isPhone
                                          ? PhoneNumberTextField(
                                        onTap: ()=> controller.onShowCountryCode(context),
                                              title: 'Mobile Number',
                                              name: controller.countryCode?.countryCode ?? 'IN',
                                              phoneNumber: controller.countryCode?.phoneCode ?? '+91',
                                              hintText: "Phone Number",
                                              phoneController: controller.phoneController,
                                            )
                                          : TradeBitTextField(
                                              title: 'Email',
                                              hintText: 'Email',
                                              keyboardType: TextInputType.emailAddress,
                                              validator: Validator.emailValidate,
                                              controller: controller.emailTextController,
                                            ),
                                      VerticalSpacing(height: Dimensions.h_5),
                                      TradeBitPasswordTextField(
                                        obscureText: controller.closeEye,
                                        title: 'Password',
                                        hintText: 'Password',
                                        controller: controller.passwordTextController,
                                        suffixIcon: IconButton(
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
                                      Align(
                                          alignment: Alignment.centerRight,
                                          child: GestureDetector(
                                            onTap: () {
                                              Get.toNamed(AppRoutes.forgotPage);
                                            },
                                            child: TradeBitTextWidget(
                                                title: "Forgot password?",
                                                style: AppTextStyle.themeBoldTextStyle(
                                                    fontSize: FontSize.sp_15,
                                                    color: AppColor.appColor)),
                                          )),
                                      VerticalSpacing(height: Dimensions.h_15),
                                      TradeBitTextButton(
                                        loading: controller.buttonLoading,
                                        labelName: "Login",
                                        style: AppTextStyle.buttonTextStyle(
                                            color: AppColor.white),
                                        onTap: () {
                                          if (loginKey.currentState!.validate()) {
                                            controller.isPhone
                                                ? controller.login(context,'mobile')
                                                : controller.login(context,'email');
                                          }
                                        },
                                        margin: EdgeInsets.zero,
                                        color: AppColor.appColor,
                                      ),
                                      VerticalSpacing(height: Dimensions.h_20),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ),
                ),
              );
            });
  }

  @override
  void dispose() {
    Get.delete<LoginController>();
    super.dispose();
  }
}




