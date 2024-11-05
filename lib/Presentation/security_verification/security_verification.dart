import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:tradebit_app/Presentation/dashboard/dashboard.dart';
import 'package:tradebit_app/Presentation/security_verification/security_controller.dart';
import 'package:tradebit_app/Presentation/security_verification/securtiy_verification_otp.dart';
import 'package:tradebit_app/Presentation/security_verification/unbind_google.dart';
import 'package:tradebit_app/Presentation/setting/setting.dart';
import 'package:tradebit_app/constants/appcolor.dart';
import 'package:tradebit_app/constants/apptextstyle.dart';
import 'package:tradebit_app/constants/constants.dart';
import 'package:tradebit_app/constants/fontsize.dart';
import 'package:tradebit_app/constants/images.dart';
import 'package:tradebit_app/widgets/common_app_bar.dart';
import 'package:tradebit_app/widgets/spacing.dart';
import 'package:tradebit_app/widgets/tradeBit_scaffold.dart';
import 'package:tradebit_app/widgets/trade_bit_container.dart';
import 'package:tradebit_app/widgets/tradebit_text.dart';

class SecurityVerification extends StatefulWidget {
  const SecurityVerification({super.key});

  @override
  State<SecurityVerification> createState() => _SecurityVerificationState();
}

class _SecurityVerificationState extends State<SecurityVerification> {
  final SecurityController controller = Get.put(SecurityController());

  @override
  void initState() {
    controller.getSecurityDetails(context);
    controller.bindEmailAndMobile(context);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return  WillPopScope(
      onWillPop: () async {
        pushReplacementWithSlideTransition(context, const Setting(),isBack: true);
        return false;
      },
      child: TradeBitContainer(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor
        ),
        child: SafeArea(
          child: TradeBitScaffold(
            appBar: PreferredSize(preferredSize: Size.fromHeight(Dimensions.h_50),
            child:  TradeBitAppBar(title: 'Security Verification',onTap: ()=>  pushReplacementWithSlideTransition(context, const Setting(),isBack: true))),
              body:  GetBuilder(
                id: ControllerBuilders.securityController,
                init: controller,
                builder: (controller) {
                  return SingleChildScrollView(
                    child: Padding(
                      padding:  EdgeInsets.only(left: Dimensions.w_10,right: Dimensions.w_10,top: Dimensions.h_15),
                      child: Column(
                        children: [
                          TradeBitContainer(
                            width: double.infinity,
                            padding:  EdgeInsets.only(left: Dimensions.w_10,top: Dimensions.h_15,bottom: Dimensions.h_5),
                            decoration: BoxDecoration(
                                color: Theme.of(context).cardColor,
                                borderRadius: BorderRadius.circular(10)
                            ),
                            child: Padding(
                              padding:  EdgeInsets.only(left: Dimensions.w_8,right: Dimensions.w_20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TradeBitTextWidget(title: 'Security Settings', style: AppTextStyle.themeBoldNormalTextStyle(
                                      fontSize: FontSize.sp_18,color: Theme.of(context).highlightColor
                                  )),
                                  VerticalSpacing(height: Dimensions.h_15),
                                  Row(
                                    children: [
                                      Image.asset(Images.emailAuth,scale: 10),
                                      HorizontalSpacing(width: Dimensions.w_10),
                                      TradeBitTextWidget(title: 'Email Authentication', style: AppTextStyle.themeBoldNormalTextStyle(
                                          fontSize: FontSize.sp_15,color: Theme.of(context).highlightColor
                                      )),
                                      const Spacer(),
                                      // Visibility(
                                      //   visible: controller.emailOtp == 1,
                                      //   child: GestureDetector(
                                      //     onTap: () {
                                      //
                                      //     },
                                      //     child: TradeBitContainer(
                                      //       padding: EdgeInsets.symmetric(horizontal: Dimensions.w_10,vertical: Dimensions.h_5),
                                      //       decoration: BoxDecoration(
                                      //           borderRadius: BorderRadius.circular(6),
                                      //           color: Theme.of(context).scaffoldBackgroundColor
                                      //       ),
                                      //       child: TradeBitTextWidget(title: "Change",style: AppTextStyle.themeBoldNormalTextStyle(
                                      //           fontSize: FontSize.sp_12,
                                      //           color: Theme.of(context).highlightColor
                                      //       ),),
                                      //     ),
                                      //   ),
                                      // ),
                                      HorizontalSpacing(width: Dimensions.w_5),
                                      controller.smsOtp == 0 ? GestureDetector(
                                        child: TradeBitContainer(
                                          padding: EdgeInsets.symmetric(horizontal: Dimensions.w_10,vertical: Dimensions.h_5),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(6),
                                              color: Theme.of(context).scaffoldBackgroundColor
                                          ),
                                          child: TradeBitTextWidget(title: controller.emailOtp == 0 ? 'Enable' : "Remove",style: AppTextStyle.themeBoldNormalTextStyle(
                                              fontSize: FontSize.sp_12,
                                              color: Theme.of(context).highlightColor
                                          ),),
                                        ),
                                      )  : GestureDetector(
                                         onTap: () {
                                          if(controller.emailOtp == 0 && controller.smsOtp == 0) {
                                          }else if(
                                          controller.emailOtp == 0 && controller.smsOtp == 1 || controller.emailOtp == 1 && controller.smsOtp == 0) {
                                            pushReplacementWithSlideTransition(context, const SecurityOtp(unBindKey: 'email'));
                                          }
                                          else if(controller.emailOtp == 1 && controller.smsOtp == 1){
                                            pushReplacementWithSlideTransition(context, const SecurityOtp(unBindKey: 'email'));
                                          }

                                          },
                                        child: TradeBitContainer(
                                          padding: EdgeInsets.symmetric(horizontal: Dimensions.w_10,vertical: Dimensions.h_5),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(6),
                                              color: Theme.of(context).scaffoldBackgroundColor
                                          ),
                                          child: TradeBitTextWidget(title: controller.emailOtp == 0 ? 'Enable' : "Remove",style: AppTextStyle.themeBoldNormalTextStyle(
                                              fontSize: FontSize.sp_12,
                                              color: Theme.of(context).highlightColor
                                          ),),
                                        ),
                                      )
                                    ],
                                  ),
                                  VerticalSpacing(height: Dimensions.h_10),
                                  TradeBitTextWidget(title: 'Turn on Email verification to make your\naccount more secure.',
                                      style: AppTextStyle.normalTextStyle(FontSize.sp_11, Theme.of(context).shadowColor)),
                                  VerticalSpacing(height: Dimensions.h_5),
                                  const Divider(),
                                  VerticalSpacing(height: Dimensions.h_10),
                                  Row(
                                    children: [
                                      Image.asset(Images.smsAuth,scale: 10),
                                      HorizontalSpacing(width: Dimensions.w_10),
                                      TradeBitTextWidget(title: 'Mobile Authentication', style: AppTextStyle.themeBoldNormalTextStyle(
                                          fontSize: FontSize.sp_15,color: Theme.of(context).highlightColor
                                      )),
                                      const Spacer(),
                                      // Visibility(
                                      //   visible: controller.smsOtp == 1,
                                      //   child: GestureDetector(
                                      //     onTap: () {
                                      //
                                      //     },
                                      //     child: TradeBitContainer(
                                      //       padding: EdgeInsets.symmetric(horizontal: Dimensions.w_10,vertical: Dimensions.h_5),
                                      //       decoration: BoxDecoration(
                                      //           borderRadius: BorderRadius.circular(6),
                                      //           color: Theme.of(context).scaffoldBackgroundColor
                                      //       ),
                                      //       child: TradeBitTextWidget(title: "Change",style: AppTextStyle.themeBoldNormalTextStyle(
                                      //           fontSize: FontSize.sp_12,
                                      //           color: Theme.of(context).highlightColor
                                      //       ),),
                                      //     ),
                                      //   ),
                                      // ),
                                      HorizontalSpacing(width: Dimensions.w_5),
                                      controller.emailOtp == 0 ? GestureDetector(
                                        child: TradeBitContainer(
                                          padding: EdgeInsets.symmetric(horizontal: Dimensions.w_10,vertical: Dimensions.h_5),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(6),
                                              color: Theme.of(context).scaffoldBackgroundColor
                                          ),
                                          child: TradeBitTextWidget(title: controller.smsOtp == 0 ? 'Enable' : "Remove",style: AppTextStyle.themeBoldNormalTextStyle(
                                              fontSize: FontSize.sp_12,
                                              color: Theme.of(context).highlightColor
                                          ),),
                                        ),
                                      ) : GestureDetector(
                                        onTap: () {
                                          if(controller.emailOtp == 0 && controller.smsOtp == 1|| controller.smsOtp == 0 && controller.emailOtp == 1) {
                                            pushReplacementWithSlideTransition(context, const SecurityOtp());
                                          }else if(
                                          controller.emailOtp == 0 && controller.smsOtp == 0) {
                                            null;
                                          }
                                          else if(controller.emailOtp == 1 && controller.smsOtp == 1){
                                            pushReplacementWithSlideTransition(context, const SecurityOtp());
                                          }
                                        },
                                        child: TradeBitContainer(
                                          padding: EdgeInsets.symmetric(horizontal: Dimensions.w_10,vertical: Dimensions.h_5),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(6),
                                              color: Theme.of(context).scaffoldBackgroundColor
                                          ),
                                          child: TradeBitTextWidget(title: controller.smsOtp == 0 ? 'Enable' : "Remove",style: AppTextStyle.themeBoldNormalTextStyle(
                                              fontSize: FontSize.sp_12,
                                              color: Theme.of(context).highlightColor
                                          ),),
                                        ),
                                      )
                                    ],
                                  ),
                                  VerticalSpacing(height: Dimensions.h_10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      TradeBitTextWidget(title: 'Turn on Mobile verification to make your\naccount more secure.',
                                          style: AppTextStyle.normalTextStyle(FontSize.sp_11, Theme.of(context).shadowColor)),
                                      Visibility(
                                        visible: controller.smsOtp == 1,
                                        child: GestureDetector(
                                          onTap: () {
                                            pushReplacementWithSlideTransition(context, const SecurityOtp(changeMobile: true));
                                          },
                                          child: TradeBitContainer(
                                            padding: EdgeInsets.symmetric(horizontal: Dimensions.w_10,vertical: Dimensions.h_5),
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(6),
                                                color: Theme.of(context).scaffoldBackgroundColor
                                            ),
                                            child: TradeBitTextWidget(title: "Change",style: AppTextStyle.themeBoldNormalTextStyle(
                                                fontSize: FontSize.sp_12,
                                                color: Theme.of(context).highlightColor
                                            ),),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  VerticalSpacing(height: Dimensions.h_5),
                                  const Divider(),
                                  VerticalSpacing(height: Dimensions.h_10),
                                  Row(
                                    children: [
                                      Image.asset(Images.googleAuth,scale: 10),
                                      HorizontalSpacing(width: Dimensions.w_10),
                                      TradeBitTextWidget(title: 'Google Authentication', style: AppTextStyle.themeBoldNormalTextStyle(
                                          fontSize: FontSize.sp_15,
                                          color: Theme.of(context).highlightColor
                                      )),
                                      const Spacer(),
                                      controller.isLoading ? const CupertinoActivityIndicator(
                                        color: AppColor.appColor
                                      ) : GestureDetector(
                                        onTap: () {
                                          controller.google2Fa == 0 ? controller.onGoogle(context) :
                                          pushReplacementWithSlideTransition(context, const UnBindGoogle());
                                        },
                                        child: TradeBitContainer(
                                          padding: EdgeInsets.symmetric(horizontal: Dimensions.w_10,vertical: Dimensions.h_5),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(6),
                                              color: Theme.of(context).scaffoldBackgroundColor
                                          ),
                                          child: TradeBitTextWidget(title: controller.google2Fa == 0 ? 'Enable' : 'Remove',style: AppTextStyle.themeBoldNormalTextStyle(
                                              fontSize: FontSize.sp_12,
                                              color: Theme.of(context).highlightColor
                                          ),),
                                        ),
                                      )
                                    ],
                                  ),
                                  VerticalSpacing(height: Dimensions.h_10),
                                  TradeBitTextWidget(title: 'Turn on Google Authentication to make your\naccount more secure.',
                                      style: AppTextStyle.normalTextStyle(FontSize.sp_11, Theme.of(context).shadowColor)),
                                  VerticalSpacing(height: Dimensions.h_15)
                                ],
                              ),
                            ),
                          ),
                          VerticalSpacing(height: Dimensions.h_15),
                          TradeBitContainer(
                            padding: EdgeInsets.only(left: Dimensions.w_15,top: Dimensions.h_20,bottom: Dimensions.h_10,right: Dimensions.w_20),
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: Theme.of(context).cardColor,
                                borderRadius: BorderRadius.circular(10)
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    TradeBitTextWidget(title: 'Anti-Phishing Code', style: AppTextStyle.themeBoldNormalTextStyle(
                                        fontSize: FontSize.sp_15,color: Theme.of(context).highlightColor
                                    )),
                                    HorizontalSpacing(width: Dimensions.w_5),
                                    TradeBitContainer(
                                      padding: EdgeInsets.symmetric(horizontal: Dimensions.w_10,vertical: Dimensions.h_5),
                                      decoration: BoxDecoration(
                                          color: const Color(0xFFFFF2CC),
                                          borderRadius: BorderRadius.circular(30)
                                      ),
                                      child: TradeBitTextWidget(title: 'Coming Soon',style: AppTextStyle.themeBoldNormalTextStyle(
                                          fontSize: FontSize.sp_10,color: AppColor.appColor
                                      ),),
                                    ),
                                    const Spacer(),
                                    TradeBitContainer(
                                      padding: EdgeInsets.symmetric(horizontal: Dimensions.w_10,vertical: Dimensions.h_5),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(6),
                                          color: Theme.of(context).scaffoldBackgroundColor
                                      ),
                                      child: TradeBitTextWidget(title: 'Setup',style: AppTextStyle.themeBoldNormalTextStyle(
                                          fontSize: FontSize.sp_12,
                                          color: Theme.of(context).highlightColor
                                      ),),
                                    )
                                  ],
                                ),
                                Padding(
                                  padding:  EdgeInsets.only(top: Dimensions.h_8),
                                  child: TradeBitTextWidget(title: 'The anti-phishing code can protect you\nfrom phishing attempts and frauds.',
                                      style: AppTextStyle.normalTextStyle(FontSize.sp_11, Theme.of(context).shadowColor)),
                                ),
                                VerticalSpacing(height: Dimensions.h_20),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              )),
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
