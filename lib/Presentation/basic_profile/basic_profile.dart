import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:get/get.dart';
import 'package:remove_emoji_input_formatter/remove_emoji_input_formatter.dart';
import 'package:tradebit_app/Presentation/basic_profile/basic_profile_controller.dart';
import 'package:tradebit_app/Presentation/utils/validators.dart';
import 'package:tradebit_app/approutes.dart';
import 'package:tradebit_app/constants/appcolor.dart';
import 'package:tradebit_app/constants/apptextstyle.dart';
import 'package:tradebit_app/constants/constants.dart';
import 'package:tradebit_app/constants/fontsize.dart';
import 'package:tradebit_app/data/datasource/local/local_storage.dart';
import 'package:tradebit_app/widgets/spacing.dart';
import 'package:tradebit_app/widgets/tradeBit_scaffold.dart';
import 'package:tradebit_app/widgets/trade_bit_container.dart';
import 'package:tradebit_app/widgets/trade_bit_toast.dart';
import 'package:tradebit_app/widgets/tradebit_text.dart';
import 'package:tradebit_app/widgets/tradebit_textbutton.dart';
import 'package:tradebit_app/widgets/tradebit_textfield.dart';


class BasicProfile extends StatefulWidget {
  const BasicProfile({super.key});

  @override
  State<BasicProfile> createState() => _BasicProfileState();
}

class _BasicProfileState extends State<BasicProfile> {
 BasicProfileController basicProfileController = Get.put(BasicProfileController());

  @override
  Widget build(BuildContext context) {
    return  WillPopScope(
      onWillPop: () async => false,
      child: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: SafeArea(
          child: TradeBitScaffold(
              body: SingleChildScrollView(
                child: GetBuilder(
                  init: basicProfileController,
                  id: ControllerBuilders.basicController,
                  builder: (controller) {
                    return Padding(
                      padding:  EdgeInsets.only(left: Dimensions.w_10,right: Dimensions.w_10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          VerticalSpacing(height: Dimensions.h_30),
                          Center(
                            child: TradeBitTextWidget(title: "You're just one step away!", style: AppTextStyle.themeBoldTextStyle(
                                fontSize: FontSize.sp_24,color: Theme.of(context).highlightColor
                            )),
                          ),
                          VerticalSpacing(height: Dimensions.h_20),
                          TradeBitTextWidget(textAlign: TextAlign.center,textOverflow: TextOverflow.visible,title: "Take less than 2 minutes to fill the information for best user experience.", style: AppTextStyle.normalTextStyle(
                              FontSize.sp_16, Theme.of(context).shadowColor
                          )),
                          VerticalSpacing(height: Dimensions.h_40),
                          EasyStepper(
                            activeStep: controller.activeStep,
                            stepShape: StepShape.circle,
                            borderThickness: 2,
                            lineStyle: LineStyle(
                              lineLength: Dimensions.w_80,
                              lineSpace: 1,
                              lineType: LineType.normal,
                              unreachedLineColor: Colors.grey.withOpacity(0.5),
                              finishedLineColor: AppColor.appColor,
                              activeLineColor: Colors.grey.withOpacity(0.5),
                            ),
                            disableScroll: true,
                            internalPadding: Dimensions.w_10,
                            defaultStepBorderType: BorderType.normal,
                            finishedStepBorderColor: AppColor.appColor,
                            finishedStepTextColor: AppColor.appColor,
                            finishedStepBackgroundColor: AppColor.appColor,
                            activeStepIconColor: AppColor.appColor,
                            showLoadingAnimation: false,
                            steps: [
                              EasyStep(
                                customStep: const Icon(Icons.location_on_rounded),
                                customTitle: Text(
                                  'Location',
                                  style: AppTextStyle.themeBoldTextStyle(
                                      fontSize: FontSize.sp_12,
                                      color: Theme.of(context).highlightColor
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              EasyStep(
                                customStep: const Icon(Icons.phone_android),
                                customTitle: Text(
                                  'Mobile',
                                  style: AppTextStyle.themeBoldTextStyle(
                                      fontSize: FontSize.sp_12,
                                      color: Theme.of(context).highlightColor
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              EasyStep(
                                customStep: const Icon(Icons.person),
                                customTitle: Text(
                                  style: AppTextStyle.themeBoldTextStyle(
                                      fontSize: FontSize.sp_12,
                                      color: Theme.of(context).highlightColor
                                  ),
                                  'Personal',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                            onStepReached:(index)=> controller.nextPage(index),
                          ),
                          VerticalSpacing(height: Dimensions.h_20),
                          Visibility(
                            visible: controller.location,
                            child: GestureDetector(
                              onTap: ()=> controller.onTap(context),
                              child: TradeBitContainer(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    color: Theme.of(context).cardColor,
                                    borderRadius: BorderRadius.circular(Dimensions.h_4)
                                ),
                                padding: EdgeInsets.only(top: Dimensions.h_4,bottom: Dimensions.h_6,left: Dimensions.w_10,right: Dimensions.w_10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        TradeBitTextWidget(title:  controller.countryName?.flagEmoji ?? '',
                                            style: AppTextStyle.themeBoldNormalTextStyle(
                                                fontSize: FontSize.sp_24,
                                                color: Theme.of(context).highlightColor)),
                                        HorizontalSpacing(width: Dimensions.w_10),
                                        TradeBitTextWidget(title:  controller.countryName?.name ?? 'Choose Country',
                                            style: AppTextStyle.themeBoldNormalTextStyle(
                                                fontSize: FontSize.sp_12,
                                                color: Theme.of(context).highlightColor)),
                                      ],
                                    ),
                                    RotatedBox(
                                        quarterTurns: 3,
                                        child: Icon(Icons.arrow_back_ios,size: Dimensions.h_12)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: controller.mobile,
                              child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  TradeBitTextWidget(title: 'Mobile number',
                                      style: AppTextStyle.themeBoldNormalTextStyle(
                                          fontSize: FontSize.sp_12,
                                          color: Theme.of(context).shadowColor)),
                                  GestureDetector(
                                    onTap: () {
                                      controller.buttonLoading ? null : controller.onGenerateOtp(context);
                                    },
                                    child:  controller.isTimerEnabled ? Align(
                                      alignment: Alignment.center,
                                      child: CountdownTimer(
                                        endWidget: GestureDetector(
                                          onTap: () {
                                            controller.buttonLoading? null : controller.onGenerateOtp(context);
                                          },
                                          child: controller.buttonLoading ? const CupertinoActivityIndicator(
                                            color: AppColor.appColor,
                                          ) : Text(
                                            "Get Code",
                                            style: AppTextStyle.themeBoldNormalTextStyle(
                                                fontSize: FontSize.sp_13,
                                                color: AppColor.appColor
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        endTime: controller.endTime,
                                        onEnd: () {
                                          controller.isTimerEnabled = false;
                                        },
                                        textStyle:  AppTextStyle.themeBoldNormalTextStyle(
                                            fontSize: FontSize.sp_13,
                                            color: AppColor.appColor
                                        ),
                                      ),
                                    )
                                        : Align(
                                      alignment: Alignment.center,
                                      child: GestureDetector(
                                        onTap: () {
                                          controller.buttonLoading? null : controller.onGenerateOtp(context);
                                          controller.isTimerEnabled = true;
                                        },
                                        child:  controller.buttonLoading ? const CupertinoActivityIndicator(
                                          color: AppColor.appColor,
                                        ) :Text(
                                          "Get Code",
                                          style: AppTextStyle.themeBoldNormalTextStyle(
                                              fontSize: FontSize.sp_13,
                                              color: AppColor.appColor
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),),
                                ],
                              ),
                              VerticalSpacing(height: Dimensions.h_8),
                              TradeBitTextField(hintStyle: AppTextStyle.normalTextStyle(FontSize.sp_12, Theme.of(context).shadowColor),
                                  contentPadding: EdgeInsets.only(left: Dimensions.w_10,top: Dimensions.h_10,bottom: Dimensions.h_15),
                                  hintText: LocalStorage.getBool(GetXStorageConstants.emailVcode) == false ? 'Enter Email Address' :'Enter phone number',
                                  title: '',
                                  onChanged: (e) {

                                  },
                                  inputFormatters: [  LengthLimitingTextInputFormatter(10),RemoveEmojiInputFormatter()],
                                  keyboardType: TextInputType.number,
                                  controller: controller.mobileController),
                              Visibility(
                                  visible: controller.otp ,
                                  child: Column(
                                    children: [
                                      VerticalSpacing(height: Dimensions.h_8),
                                      TradeBitTextFieldLabel(
                                        height: Dimensions.h_50,
                                          inputFormatters: [
                                            LengthLimitingTextInputFormatter(6),
                                          ],
                                          contentPadding: EdgeInsets.only(left: Dimensions.w_10,top: Dimensions.h_8,bottom: Dimensions.h_10),
                                          hintText: 'Enter OTP',
                                          title: 'Enter otp ',
                                          controller: LocalStorage.getBool(GetXStorageConstants.emailVcode) == false ? controller.emailOtpController : controller.otpController,
                                          borderEnable: true,
                                          keyboardType:  LocalStorage.getBool(GetXStorageConstants.emailVcode) == false ? TextInputType.emailAddress : TextInputType.number,
                                          color: Theme.of(context).cardColor,
                                          validator: Validator.otpValidate),
                                    ],
                                  )),
                            ],
                          )),
                          VerticalSpacing(height: controller.mobile ? Dimensions.h_10 : controller.profile ? Dimensions.h_1 : Dimensions.h_30),
                          Visibility(
                            visible: controller.location,
                            child: TradeBitTextButton(margin: EdgeInsets.zero,height: Dimensions.h_40,color: AppColor.appColor,labelName: 'Next', onTap: () {
                              if(controller.countryName == null ) {
                                ToastUtils.showCustomToast(context, 'Please select country', false);
                              } else {
                                controller.onNextTap();
                              }
                
                            }),
                          ),
                          Visibility(
                            visible: controller.mobile,
                            child: TradeBitTextButton(margin: EdgeInsets.zero,height: Dimensions.h_40,color: AppColor.appColor,labelName: 'Next', onTap: () {
                              if(LocalStorage.getBool(GetXStorageConstants.emailVcode) == false ? controller.emailOtpController.text.isEmpty : controller.mobileController.text.isEmpty) {
                                ToastUtils.showCustomToast(context, LocalStorage.getBool(GetXStorageConstants.emailVcode) == false ? "Enter email address":'Enter mobile number', false);
                              } else if( controller.otpController.text.isEmpty) {
                                ToastUtils.showCustomToast(context, 'please Enter otp ', false);
                              } else {
                                controller.validateOtp(context);
                              }
                
                            }),
                          ),
                          Visibility(
                            visible: controller.profile,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TradeBitTextWidget(title: ' First Name',
                                    style: AppTextStyle.themeBoldNormalTextStyle(
                                        fontSize: FontSize.sp_12,
                                        color: Theme.of(context).shadowColor)),
                                VerticalSpacing(height: Dimensions.h_5),
                                TradeBitTextField(hintStyle: AppTextStyle.normalTextStyle(FontSize.sp_12, Theme.of(context).shadowColor),
                                    contentPadding: EdgeInsets.only(left: Dimensions.w_10,top: Dimensions.h_10,bottom: Dimensions.h_13),
                                    hintText: 'Enter first name',
                                    title: '',
                                    controller: controller.nameController),
                                TradeBitTextWidget(title: ' Last Name',
                                    style: AppTextStyle.themeBoldNormalTextStyle(
                                        fontSize: FontSize.sp_12,
                                        color: Theme.of(context).shadowColor)),
                                VerticalSpacing(height: Dimensions.h_5),
                                TradeBitTextField(hintStyle: AppTextStyle.normalTextStyle(FontSize.sp_12, Theme.of(context).shadowColor),
                                    contentPadding: EdgeInsets.only(left: Dimensions.w_10,top: Dimensions.h_10,bottom: Dimensions.h_13),
                                    hintText: 'Enter last name',
                                    title: '',
                                    controller: controller.lastnameController),
                                VerticalSpacing(height: Dimensions.h_10),
                                TradeBitTextButton(margin: EdgeInsets.zero,height: Dimensions.h_40,color: AppColor.appColor,labelName: 'Submit', onTap: () {
                                  if(controller.lastnameController.text.isEmpty) {
                                    ToastUtils.showCustomToast(context, 'Please enter last name', false);
                                  } else if( controller.nameController.text.isEmpty) {
                                    ToastUtils.showCustomToast(context, 'Please enter first name ', false);
                                  }  else {
                                    controller.updateProfile(context);
                                  }
                                }),
                              ],
                            ),
                          ),
                          VerticalSpacing(height: Dimensions.h_10),
                          GestureDetector(
                            onTap: () {
                           LocalStorage.writeBool(GetXStorageConstants.basic, false);
                           LocalStorage.writeBool(GetXStorageConstants.userLogin, true);
                            Get.offAllNamed(AppRoutes.loginScreen);
                            },
                            child: Center(
                              child: TradeBitTextWidget(title: ' Cancel',
                                  style: AppTextStyle.themeBoldNormalTextStyle(
                                      fontSize: FontSize.sp_15,
                                      color: AppColor.appColor)),
                            ),
                          ),
                          VerticalSpacing(height: Dimensions.h_10),
                        ],
                      ),
                    );
                  },
                ),
              )),
        ),
      ),
    );
  }
}
