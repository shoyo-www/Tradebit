import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tradebit_app/Presentation/Homepage/home_controller.dart';
import 'package:tradebit_app/Presentation/dashboard/dashboard.dart';
import 'package:tradebit_app/Presentation/setting/setting.dart';
import 'package:tradebit_app/constants/appcolor.dart';
import 'package:tradebit_app/constants/apptextstyle.dart';
import 'package:tradebit_app/constants/constants.dart';
import 'package:tradebit_app/constants/fontsize.dart';
import 'package:tradebit_app/constants/images.dart';
import 'package:tradebit_app/widgets/common_app_bar.dart';
import 'package:tradebit_app/widgets/email_phone_button.dart';
import 'package:tradebit_app/widgets/spacing.dart';
import 'package:tradebit_app/widgets/tradeBit_scaffold.dart';
import 'package:tradebit_app/widgets/trade_bit_container.dart';
import 'package:tradebit_app/widgets/tradebit_text.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
 HomeController homeController = Get.put(HomeController());
 ScrollController scrollController = ScrollController();
 
 @override
  void initState() {
    super.initState();
    scrollController.addListener(_onScroll);
 }

 void _onScroll() {
   if (scrollController.offset >= scrollController.position.maxScrollExtent &&
       !scrollController.position.outOfRange) {
     homeController.loadMoreActivities(context);
   }
 }

  @override
  Widget build(BuildContext context) {
    String getStatus() {
      if(homeController.profile?.emailOtp == 1 && homeController.profile?.smsOtp == 1 && homeController.profile?.google2Fa == 1) {
        return 'High';
      }
      if((homeController.profile?.emailOtp == 1 && homeController.profile?.smsOtp == 1  && homeController.profile?.google2Fa == 0)
          || (homeController.profile?.emailOtp == 0 && homeController.profile?.smsOtp == 1 && homeController.profile?.google2Fa == 0) || (homeController.profile?.emailOtp == 1 && homeController.profile?.smsOtp == 0 && homeController.profile?.google2Fa == 1)) {
        return 'Medium';
      }if(homeController.profile?.emailOtp == 1 && homeController.profile?.smsOtp == 0 && homeController.profile?.google2Fa == 0 ) {
        return 'Low';
      }
     return '';
    }
    return WillPopScope(
      onWillPop: () async {
        pushReplacementWithSlideTransition(context, const Setting(),isBack: true);
        return false;
      },
      child: TradeBitContainer(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor
        ),
        child: SafeArea(
          child: GetBuilder(
            init: homeController,
            id: ControllerBuilders.homeController,
            builder: (controller) {
              return  TradeBitScaffold(
                appBar: PreferredSize(preferredSize: Size.fromHeight(Dimensions.h_45), child: TradeBitAppBar(title: 'Profile Overview',onTap: ()=> pushReplacementWithSlideTransition(context, const Setting(),isBack: true))),
                  body:  Padding(
                    padding:  EdgeInsets.only(left: Dimensions.w_10,right: Dimensions.w_10),
                    child: Column(
                        children: [
                          VerticalSpacing(height: Dimensions.h_30),
                          Row(
                            children: [
                               CircleAvatar(
                                backgroundColor: Colors.transparent,
                                radius: Dimensions.h_35,
                                backgroundImage: const AssetImage(Images.avatar),
                              ),
                              HorizontalSpacing(width: Dimensions.w_12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TradeBitTextWidget(title: controller.profile?.name ?? '- - -', style: AppTextStyle.themeBoldNormalTextStyle(fontSize:FontSize.sp_16, color:Theme.of(context).highlightColor)),
                                  TradeBitTextWidget(title: controller.profile?.email ?? '- - -', style: AppTextStyle.themeBoldNormalTextStyle(fontSize:FontSize.sp_14, color:Theme.of(context).shadowColor)),
                                  VerticalSpacing(height: Dimensions.h_4),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      TradeBitTextWidget(title: 'UID: ', style: AppTextStyle.themeBoldTextStyle(fontSize: FontSize.sp_16, color : Theme.of(context).highlightColor)),
                                      TradeBitTextWidget(title: controller.profile?.username ?? '- - -', style: AppTextStyle.themeBoldTextStyle(fontSize: FontSize.sp_16, color: Theme.of(context).shadowColor)),
                                      HorizontalSpacing(width: Dimensions.w_15),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                          VerticalSpacing(height: Dimensions.h_40),
                          TradeBitContainer(
                            height: controller.activity ? Dimensions.h_450 :Dimensions.h_316,
                            padding: EdgeInsets.only(left: Dimensions.w_20,right: Dimensions.w_20,top: controller.activity ? Dimensions.h_15 :Dimensions.h_20,bottom: controller.activity ? Dimensions.h_10 : Dimensions.h_30),
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    EmailPhoneButton(
                                      title: "Profile",
                                      isSelected: controller.isProfile,
                                      onTap: () {
                                        controller.profileButton();
                                      },
                                    ),
                                    HorizontalSpacing(width: Dimensions.w_20),
                                    EmailPhoneButton(
                                      title: "Security",
                                      isSelected: controller.isSecurity,
                                      onTap: () {
                                        controller.securityButton();
                                      },
                                    ),
                                    HorizontalSpacing(width: Dimensions.w_20),
                                    EmailPhoneButton(
                                      title: "Activity",
                                      isSelected: controller.activity,
                                      onTap: () {
                                        controller.getActivity(context);
                                        controller.activityButton();
                                      },
                                    ),
                                  ],
                                ),
                                VerticalSpacing(height: Dimensions.h_10),
                                Divider(color: Theme.of(context).shadowColor,
                                thickness: 0.2),
                                VerticalSpacing(height: controller.activity ? Dimensions.h_10 :Dimensions.h_30),
                                controller.isProfile ? Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        TradeBitTextWidget(title: 'Mobile Number', style: AppTextStyle.themeBoldNormalTextStyle(
                                          fontSize: FontSize.sp_16,color: Theme.of(context).highlightColor
                                        )),
                                        TradeBitTextWidget(title: "+${controller.profile?.countryCallingCode ?? '--'}-${controller.profile?.mobile ?? '- - -'}", style: AppTextStyle.themeBoldNormalTextStyle(
                                            fontSize: FontSize.sp_16,color: Theme.of(context).shadowColor
                                        ))
                                      ],
                                    ),
                                    VerticalSpacing(height: Dimensions.h_20),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        TradeBitTextWidget(title: 'Country Code', style: AppTextStyle.themeBoldNormalTextStyle(
                                            fontSize: FontSize.sp_16,color: Theme.of(context).highlightColor
                                        )),
                                        TradeBitTextWidget(title: controller.profile?.countryCode ?? '- - -', style: AppTextStyle.themeBoldNormalTextStyle(
                                            fontSize: FontSize.sp_16,color: Theme.of(context).shadowColor
                                        ))
                                      ],
                                    ),
                                    VerticalSpacing(height: Dimensions.h_20),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        TradeBitTextWidget(title: 'Status', style: AppTextStyle.themeBoldNormalTextStyle(
                                            fontSize: FontSize.sp_16,color: Theme.of(context).highlightColor
                                        )),
                                        TradeBitTextWidget(title: controller.profile?.status == true ? 'Active' : 'Inactive', style: AppTextStyle.themeBoldNormalTextStyle(
                                            fontSize: FontSize.sp_16,color: controller.profile?.status == true ? AppColor.green : AppColor.redButton
                                        ))
                                      ],
                                    ),
                                    VerticalSpacing(height: Dimensions.h_20),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        TradeBitTextWidget(title: 'Signup Date ', style: AppTextStyle.themeBoldNormalTextStyle(
                                            fontSize: FontSize.sp_16,color: Theme.of(context).highlightColor
                                        )),
                                        TradeBitTextWidget(title: DateFormat('E MMM dd y').format(controller.profile?.createdAt ?? DateTime(2022)), style: AppTextStyle.themeBoldNormalTextStyle(
                                            fontSize: FontSize.sp_16,color: Theme.of(context).shadowColor
                                        ))
                                      ],
                                    ),
                                  ],
                                ): controller.isSecurity ? Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        TradeBitTextWidget(title: 'Safety Strength', style: AppTextStyle.themeBoldNormalTextStyle(fontSize:FontSize.sp_16, color:Theme.of(context).highlightColor)),
                                        TradeBitTextWidget(title: getStatus(), style: AppTextStyle.themeBoldNormalTextStyle(fontSize:FontSize.sp_16, color: getStatus() == 'Low' ? AppColor.redButton : AppColor.green))
                                      ],
                                    ),
                                    VerticalSpacing(height: Dimensions.h_20),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        TradeBitTextWidget(title: 'Email OTP', style: AppTextStyle.themeBoldNormalTextStyle(fontSize:FontSize.sp_16, color:Theme.of(context).highlightColor)),
                                        TradeBitContainer(
                                          padding: EdgeInsets.only(left: Dimensions.w_8,right: Dimensions.w_8,top: Dimensions.h_10,bottom: Dimensions.h_10),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(6),
                                            color: Theme.of(context).scaffoldBackgroundColor
                                          ),
                                            child: TradeBitTextWidget(title: controller.profile?.emailOtp == 0 ? 'Disabled' : 'Enabled', style: AppTextStyle.themeBoldNormalTextStyle(fontSize:FontSize.sp_16, color: controller.profile?.emailOtp == 0 ? Theme.of(context).highlightColor : AppColor.green)))
                                      ],
                                    ),
                                    VerticalSpacing(height: Dimensions.h_10),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        TradeBitTextWidget(title: 'Mobile OTP', style: AppTextStyle.themeBoldNormalTextStyle(fontSize:FontSize.sp_16, color:Theme.of(context).highlightColor)),
                                        TradeBitContainer(
                                            padding: EdgeInsets.only(left: Dimensions.w_8,right: Dimensions.w_8,top: Dimensions.h_10,bottom: Dimensions.h_10),
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(6),
                                                color: Theme.of(context).scaffoldBackgroundColor
                                            ),
                                            child: TradeBitTextWidget(title: controller.profile?.smsOtp == 0 ? 'Disabled' : 'Enabled', style: AppTextStyle.themeBoldNormalTextStyle(fontSize:FontSize.sp_16, color: controller.profile?.smsOtp == 0 ? Theme.of(context).highlightColor : AppColor.green)))
                                      ],
                                    ),
                                    VerticalSpacing(height: Dimensions.h_10),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        TradeBitTextWidget(title: 'Google Authenticator', style: AppTextStyle.themeBoldNormalTextStyle(fontSize:FontSize.sp_16, color:Theme.of(context).highlightColor)),
                                        TradeBitContainer(
                                            padding: EdgeInsets.only(left: Dimensions.w_8,right: Dimensions.w_8,top: Dimensions.h_10,bottom: Dimensions.h_10),
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(6),
                                                color: Theme.of(context).scaffoldBackgroundColor
                                            ),
                                            child: TradeBitTextWidget(title: controller.profile?.google2Fa == 0 ? 'Disabled' : 'Enabled', style: AppTextStyle.themeBoldNormalTextStyle(fontSize:FontSize.sp_16, color: controller.profile?.google2Fa == 0 ? Theme.of(context).highlightColor :AppColor.green)))
                                      ],
                                    ),
                                  ],
                                ) :  Expanded(
                                  child: Stack(
                                    children: [
                                      ListView.builder(
                                          padding: EdgeInsets.only(left: Dimensions.w_10,bottom: Dimensions.h_5),
                                          itemCount: controller.activityList.length,
                                          controller: scrollController,
                                          shrinkWrap: true,
                                          itemBuilder: (c,i) {
                                            DateTime dateTime = DateTime.parse(controller.activityList[i].updatedAt.toString() ?? '');
                                            String formattedDate = DateFormat('dd MMMM').format(dateTime);
                                            String formattedTime = DateFormat.jm().format(dateTime.toLocal());
                                            return Row(
                                              children: [
                                                Column(
                                                  children: [
                                                    TradeBitContainer(
                                                      height: Dimensions.h_20,
                                                      width: Dimensions.w_1,
                                                      decoration: BoxDecoration(
                                                          color: Theme.of(context).shadowColor
                                                      ),
                                                    ),
                                                    VerticalSpacing(height: Dimensions.h_5),
                                                    TradeBitContainer(
                                                      height: Dimensions.h_12,
                                                      width: Dimensions.h_12,
                                                      decoration: const BoxDecoration(
                                                          color: AppColor.appColor,
                                                          shape: BoxShape.circle
                                                      ),
                                                    ),
                                                    VerticalSpacing(height: Dimensions.h_5),
                                                    TradeBitContainer(
                                                      height: Dimensions.h_20,
                                                      width: Dimensions.w_1,
                                                      decoration: BoxDecoration(
                                                          color: Theme.of(context).shadowColor
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                HorizontalSpacing(width: Dimensions.w_20),
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    TradeBitTextWidget(title: controller.activityList[i].type ?? '', style: AppTextStyle.themeBoldNormalTextStyle(
                                                        fontSize: FontSize.sp_14,
                                                        color: Theme.of(context).highlightColor
                                                    )),
                                                    TradeBitTextWidget(title: controller.activityList[i].ip ?? '', style: AppTextStyle.normalTextStyle(
                                                        FontSize.sp_12, AppColor.greyColor
                                                    ))
                                                  ],
                                                ),
                                                const Spacer(),
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.end,
                                                  children: [
                                                    TradeBitTextWidget(title: formattedDate, style: AppTextStyle.themeBoldNormalTextStyle(
                                                        fontSize: FontSize.sp_14,
                                                        color: Theme.of(context).highlightColor
                                                    )),
                                                    TradeBitTextWidget(title: formattedTime, style: AppTextStyle.normalTextStyle(
                                                        FontSize.sp_12, AppColor.greyColor
                                                    )),
                                                  ],
                                                ),
                                              ],
                                            );
                                          }),
                                      Positioned(
                                        bottom: -1,
                                          left: MediaQuery.sizeOf(context).width / 2.5,
                                          child:  controller.loadData ? const CupertinoActivityIndicator(
                                        color: AppColor.appColor,
                                      ) : const SizedBox.shrink() )

                                    ],
                                  ),
                                )

                              ],
                            ),
                          )
                        ]),
                  ));
            },

          ),
        ),
      ),
    );
  }

}
