import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tradebit_app/Presentation/Homepage/home_controller.dart';
import 'package:tradebit_app/Presentation/change_password/change_password.dart';
import 'package:tradebit_app/Presentation/dashboard/dashboard.dart';
import 'package:tradebit_app/Presentation/kyc_verfication/kyc_verfication.dart';
import 'package:tradebit_app/Presentation/myfees/myfees.dart';
import 'package:tradebit_app/Presentation/refferal/Refferal.dart';
import 'package:tradebit_app/Presentation/security_verification/security_verification.dart';
import 'package:tradebit_app/Presentation/setting/profile.dart';
import 'package:tradebit_app/Presentation/ticket/my_tickets.dart';
import 'package:tradebit_app/constants/appcolor.dart';
import 'package:tradebit_app/constants/apptextstyle.dart';
import 'package:tradebit_app/constants/constants.dart';
import 'package:tradebit_app/constants/fontsize.dart';
import 'package:tradebit_app/constants/images.dart';
import 'package:tradebit_app/data/datasource/local/local_storage.dart';
import 'package:tradebit_app/widgets/common_app_bar.dart';
import 'package:tradebit_app/widgets/spacing.dart';
import 'package:tradebit_app/widgets/tradeBit_scaffold.dart';
import 'package:tradebit_app/widgets/trade_bit_container.dart';
import 'package:tradebit_app/widgets/tradebit_text.dart';
import 'package:url_launcher/url_launcher.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {

  HomeController homeController = Get.put(HomeController());

  Future<void> launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.inAppWebView,
    )) {
      throw Exception('Could not launch $url');
    }
  }

  bool state = false;

  @override
  Widget build(BuildContext context) {
    return  GetBuilder(
      init: homeController,
      id: ControllerBuilders.homeController,
      builder: (controller) {
        return TradeBitContainer(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor
          ),
          child: SafeArea(
            child: TradeBitScaffold(
              appBar: PreferredSize(preferredSize: Size.fromHeight(Dimensions.h_55), child: TradeBitAppBar(title: 'Settings',onTap: ()=>
                  Navigator.pop(context))),
              body: SingleChildScrollView(
                child: Padding(
                  padding:  EdgeInsets.only(left: Dimensions.w_20,right: Dimensions.w_20),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children : [
                        VerticalSpacing(height: Dimensions.h_10),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: TradeBitTextWidget(title: 'Account', style: AppTextStyle.themeBoldTextStyle(fontSize: FontSize.sp_14,color: Theme.of(context).shadowColor)),
                        ),
                        VerticalSpacing(height: Dimensions.h_10),
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: ()=>  pushReplacementWithSlideTransition(context, const UserProfile()),
                          child: TradeBitContainer(
                            padding:  EdgeInsets.only(top:Dimensions.h_12,bottom: Dimensions.h_12,left: Dimensions.w_4,right: Dimensions.w_4),
                            margin: EdgeInsets.zero,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Theme.of(context).cardColor
                            ),
                            child: Row(
                              children: [
                                const CircleAvatar(
                                  backgroundColor: Colors.transparent,
                                  radius: 30,
                                  backgroundImage: AssetImage(Images.avatar),
                                ),
                                HorizontalSpacing(width: Dimensions.w_12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TradeBitTextWidget(title: LocalStorage.getString(GetXStorageConstants.userEmail), style: AppTextStyle.normalTextStyle(FontSize.sp_14, Theme.of(context).shadowColor)),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        TradeBitTextWidget(title: 'UID: ', style: AppTextStyle.themeBoldTextStyle(fontSize: FontSize.sp_16, color : Theme.of(context).highlightColor)),
                                        TradeBitTextWidget(title: LocalStorage.getString(GetXStorageConstants.userName), style: AppTextStyle.themeBoldTextStyle(fontSize: FontSize.sp_16, color: Theme.of(context).highlightColor)),
                                        HorizontalSpacing(width: Dimensions.w_15),
                                        TradeBitContainer(
                                          margin: EdgeInsets.only(top: Dimensions.h_5),
                                          padding:  EdgeInsets.only(left: Dimensions.w_8,right: Dimensions.w_8,top: Dimensions.h_2,bottom: Dimensions.h_3),
                                          decoration: BoxDecoration(
                                              color: LocalStorage.getString(GetXStorageConstants.userKycStatus) == 'pending' ? AppColor.appColor.withOpacity(0.5) : Colors.green.withOpacity(0.1),
                                              borderRadius: BorderRadius.circular(8),
                                              border: Border.all(color:LocalStorage.getString(GetXStorageConstants.userKycStatus) == 'pending' ? AppColor.appColor.withOpacity(0.5) : Colors.green,width: 1.2)
                                          ),
                                          child:  TradeBitTextWidget(title: controller.profile?.userKycStatus ?? '',
                                              style: AppTextStyle.normalTextStyle(
                                                FontSize.sp_12,
                                                controller.profile?.userKycStatus == 'pending' ? AppColor.white : AppColor.green)),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                Icon(Icons.arrow_forward_ios,color: Theme.of(context).shadowColor,size: 14),
                                HorizontalSpacing(width: Dimensions.w_5),
                              ],
                            ),
                          ),
                        ),
                        VerticalSpacing(height: Dimensions.h_25),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TradeBitTextWidget(
                                title: 'Security Settings',
                                style: AppTextStyle.themeBoldTextStyle(
                                    fontSize: FontSize.sp_14,
                                    color: Theme.of(context).shadowColor)),
                            VerticalSpacing(height: Dimensions.h_15),
                            TradeBitContainer(
                              margin: EdgeInsets.zero,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15), color: Theme.of(context).cardColor),
                              child: Column(
                                children: [
                                  GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    onTap: ()=> pushReplacementWithSlideTransition(context, const ChangePassword()),
                                      child: buildRowItem(Images.changePassword, 'Change Password', 'Change your password in 2 steps')),
                                   TradeBitContainer(
                                    width: double.infinity,
                                    height: 1,
                                    decoration: BoxDecoration(color: Theme.of(context).shadowColor.withOpacity(0.3)),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      controller.profile?.userKycStatus == 'completed' ||  controller.profile?.userKycStatus == 'pending' ? null  :
                                      pushReplacementWithSlideTransition(context, const KycVerification());
                                    },
                                      child: buildRowItem(Images.kyc, 'KYC Verification', "Complying with KYC Regulations")),
                                   TradeBitContainer(
                                    width: double.infinity,
                                    height: 1,
                                    decoration: BoxDecoration(
                                        color: Theme.of(context).shadowColor.withOpacity(0.3)),
                                  ),
                                  GestureDetector(
                                      behavior: HitTestBehavior.opaque,
                                    onTap: () {
                                      pushReplacementWithSlideTransition(context, const SecurityVerification());
                                    },
                                      child: buildRowItem(Images.security, "Security Verification", "Ensuring safety with verification")),
                                ],
                              ),
                            ),
                          ],
                        ),
                        VerticalSpacing(height: Dimensions.h_20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TradeBitTextWidget(
                                title: 'General Settings',
                                style: AppTextStyle.themeBoldTextStyle(
                                    fontSize: FontSize.sp_14,
                                    color: Theme.of(context).shadowColor)),
                            VerticalSpacing(height: Dimensions.h_15),
                            TradeBitContainer(
                              margin: EdgeInsets.zero,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15), color: Theme.of(context).cardColor),
                              child: Column(
                                children: [
                                  GestureDetector(
                                      behavior: HitTestBehavior.opaque,
                                    onTap: ()=> pushWithSlideTransition(context, const Refferal()),
                                      child: buildRowItem(Images.referral, 'Referral Center', 'Maximizing earnings through referrals')),
                                   TradeBitContainer(
                                    width: double.infinity,
                                    height: 1,
                                    decoration: BoxDecoration(color: Theme.of(context).shadowColor.withOpacity(0.3)),
                                  ),
                                  GestureDetector(
                                      behavior: HitTestBehavior.opaque,
                                    onTap: () => pushWithSlideTransition(context, const MyFees()),
                                      child: buildRowItem(Images.fee, 'My Fees', "Breaking down & analyzing the costs")),
                                   TradeBitContainer(
                                    width: double.infinity,
                                    height: 1,
                                    decoration: BoxDecoration(color: Theme.of(context).shadowColor.withOpacity(0.3)),
                                  ),
                                  GestureDetector(
                                      behavior: HitTestBehavior.opaque,
                                    onTap: ()=> pushWithSlideTransition(context, const MyTickets()),
                                      child: buildRowItem(Images.tickets, "My Tickets", "Resolving issue quickly & effectively")),
                                ],
                              ),
                            ),
                          ],
                        ),
                        VerticalSpacing(height: Dimensions.h_20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TradeBitTextWidget(
                                title: 'Theme Settings',
                                style: AppTextStyle.themeBoldTextStyle(
                                    fontSize: FontSize.sp_14,
                                    color: Theme.of(context).shadowColor)),
                            VerticalSpacing(height: Dimensions.h_15),
                            TradeBitContainer(
                              margin: EdgeInsets.zero,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Theme.of(context).cardColor),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Row(
                                      children: [
                                        Image.asset(
                                          Images.darkMode,
                                          scale: 3.5,
                                        ),
                                        HorizontalSpacing(width: Dimensions.w_12),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                TradeBitTextWidget(
                                                    title: LocalStorage.getBool(GetXStorageConstants.day) == true ? "Light Mode" : "Dark Mode",
                                                    style: AppTextStyle.themeBoldTextStyle(
                                                        fontSize: FontSize.sp_15,
                                                        color: Theme.of(context).highlightColor)),
                                                VerticalSpacing(height: Dimensions.h_2),
                                                TradeBitTextWidget(
                                                    title: "Toggle between dark & light mode",
                                                    style: AppTextStyle.normalTextStyle(
                                                        FontSize.sp_10, AppColor.greyColor)),
                                              ],
                                            ),
                                          ],
                                        ),
                                        const Spacer(),
                                        Transform.scale(
                                          scale: 0.8,
                                          child: CupertinoSwitch(
                                            value: LocalStorage.getBool(GetXStorageConstants.day),
                                            onChanged: (value){
                                              setState(() {
                                                LocalStorage().changeTheme();
                                                LocalStorage.writeBool(GetXStorageConstants.day,value);
                                              },
                                              );
                                            },
                                            thumbColor: AppColor.appColor,
                                            activeColor: AppColor.appcolor,
        
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        VerticalSpacing(height: Dimensions.h_20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TradeBitTextWidget(
                                title: 'Privacy Policy',
                                style: AppTextStyle.themeBoldTextStyle(
                                    fontSize: FontSize.sp_14,
                                    color: Theme.of(context).shadowColor)),
                            VerticalSpacing(height: Dimensions.h_15),
                            GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () {
                                launchInBrowser(Uri.parse('https://tradebit.io/About/privacy_policy'));
                              },
                              child: TradeBitContainer(
                                  margin: EdgeInsets.zero,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15), color: Theme.of(context).cardColor),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: TradeBitContainer(
                                      child: Row(
                                        children: [
                                        const Icon(Icons.privacy_tip),
                                        HorizontalSpacing(width: Dimensions.w_12),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                TradeBitTextWidget(
                                                    title: 'Privacy Policy',
                                                    style: AppTextStyle.themeBoldTextStyle(
                                                        fontSize: FontSize.sp_15,
                                                        color: Theme.of(context).highlightColor)),
                                                VerticalSpacing(height: Dimensions.h_2),
                                                TradeBitTextWidget(
                                                    title: 'You can read polices here',
                                                    style: AppTextStyle.normalTextStyle(
                                                        FontSize.sp_10, Theme.of(context).shadowColor)),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                      ),
                                    ),
                                  ),
                              ),
                            ),
                          ],
                        ),
                        VerticalSpacing(height: Dimensions.h_20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TradeBitTextWidget(
                                title: LocalStorage.getBool(GetXStorageConstants.isLogin) == true ? 'Logout' : "Login",
                                style: AppTextStyle.themeBoldTextStyle(
                                    fontSize: FontSize.sp_14,
                                    color: Theme.of(context).shadowColor)),
                            VerticalSpacing(height: Dimensions.h_15),
                            GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () {
                                homeController.showCupertinoDialogWithButtons(context);
                                },
                              child: TradeBitContainer(
                                  margin: EdgeInsets.zero,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15), color: Theme.of(context).cardColor),
                                  child: buildRowItem(Images.logout,'Logout', 'We hope to see you soon!',icon: false)),
                            ),
                          ],
                        ),
                        VerticalSpacing(height: Dimensions.h_20),
        
                      ]
                  ),
                ),
              ),
            ),
          ),
        );
      },

    );
  }

  Padding buildRowItem(String image, String title, String subtitle,{bool icon = true}) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: TradeBitContainer(
        child: Row(children: [
                      Image.asset(image, scale: 3.5,),
                      HorizontalSpacing(width: Dimensions.w_12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TradeBitTextWidget(
                                  title: title,
                                  style: AppTextStyle.themeBoldTextStyle(
                                      fontSize: FontSize.sp_15,
                                      color: Theme.of(context).highlightColor)),
                              VerticalSpacing(height: Dimensions.h_2),
                              TradeBitTextWidget(
                                  title: subtitle,
                                  style: AppTextStyle.normalTextStyle(
                                      FontSize.sp_10, Theme.of(context).shadowColor)),
                            ],
                          ),
                        ],
                      ),
                      const Spacer(),
                       icon ? Icon(
                        Icons.arrow_forward_ios,
                        color: Theme.of(context).shadowColor,
                        size: 14,
                      ) : const SizedBox(),
                    ],
                  ),
      ),
    );
  }
}
