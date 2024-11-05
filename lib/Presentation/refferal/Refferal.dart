import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:tradebit_app/Presentation/dashboard/dashboard.dart';
import 'package:tradebit_app/Presentation/refferal/refferal_controller.dart';
import 'package:tradebit_app/approutes.dart';
import 'package:tradebit_app/constants/appcolor.dart';
import 'package:tradebit_app/constants/apptextstyle.dart';
import 'package:tradebit_app/constants/constants.dart';
import 'package:tradebit_app/constants/fontsize.dart';
import 'package:tradebit_app/constants/images.dart';
import 'package:tradebit_app/data/datasource/local/local_storage.dart';
import 'package:tradebit_app/widgets/common_app_bar.dart';
import 'package:tradebit_app/widgets/spacing.dart';
import 'package:tradebit_app/widgets/trade_bit_container.dart';
import 'package:tradebit_app/widgets/tradebit_scaffold.dart';
import 'package:tradebit_app/widgets/tradebit_text.dart';

class Refferal extends StatefulWidget {
  const Refferal({super.key});

  @override
  State<Refferal> createState() => _RefferalState();
}

class _RefferalState extends State<Refferal> {
   RefferalController refferalController = Get.put(RefferalController());

   @override
  void initState() {
    refferalController.getReferral(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      id: ControllerBuilders.refferalController,
      init: refferalController,
      builder: (controller) {
        return WillPopScope(
          onWillPop: () async {
            LocalStorage.getBool('Referral') == true ? pushReplacementWithSlideTransition(context,DashBoard(index: 0),isBack: true): Navigator.pop(context);
            return false;
          },
          child: TradeBitContainer(
            decoration: BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor),
            child: SafeArea(
              child: TradeBitScaffold(
                appBar: PreferredSize(preferredSize: Size.fromHeight(Dimensions.h_40), child: TradeBitAppBar(title: 'Referral',onTap: ()=> LocalStorage.getBool('Referral') == true ? pushReplacementWithSlideTransition(context,DashBoard(index: 0),isBack: true): Navigator.pop(context))),
                body: SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.only(left: Dimensions.w_15,right: Dimensions.w_15),
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        VerticalSpacing(height: Dimensions.h_20),
                        TradeBitTextWidget(title: 'Invite Friends to ', style: AppTextStyle.themeBoldNormalTextStyle(fontSize: FontSize.sp_26, color:Theme.of(context).highlightColor)),
                        VerticalSpacing(height: Dimensions.h_5),
                        TradeBitTextWidget(
                            textAlign: TextAlign.center,title: 'Double Your Rewards', style:AppTextStyle.themeBoldNormalTextStyle(fontSize: FontSize.sp_26, color:Theme.of(context).highlightColor)),
                        VerticalSpacing(height: Dimensions.h_20),
                        TradeBitTextWidget(
                            textAlign: TextAlign.center,
                            title: 'Get rewarded up to USD \$1,000 (in TBC) for', style: AppTextStyle.themeBoldNormalTextStyle(fontSize: FontSize.sp_15, color:AppColor.appColor)),
                        VerticalSpacing(height: Dimensions.h_5),
                        TradeBitTextWidget(
                          textAlign: TextAlign.center,
                          title: 'every friend you refer',  style: AppTextStyle.themeBoldNormalTextStyle(fontSize: FontSize.sp_15, color:AppColor.appColor),
                        ),
                        VerticalSpacing(height: Dimensions.h_20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TradeBitTextWidget(
                                title: 'No referral limits', style: AppTextStyle.normalTextStyle(FontSize.sp_14, Theme.of(context).highlightColor)),
                            TradeBitTextWidget(
                                title: ' - You can refer as many friends as you ', style: AppTextStyle.normalTextStyle(FontSize.sp_13, Theme.of(context).shadowColor)),
                          ],
                        ),
                        TradeBitTextWidget(
                            textAlign: TextAlign.center,
                            title: 'want you and your friends will each be rewarded ', style: AppTextStyle.normalTextStyle(FontSize.sp_13, Theme.of(context).shadowColor)),
                        TradeBitTextWidget(
                            textAlign: TextAlign.center,
                            title: 'upon meeting the requirements.', style: AppTextStyle.normalTextStyle(FontSize.sp_13, Theme.of(context).shadowColor)),
                        VerticalSpacing(height: Dimensions.h_30),
                        TradeBitContainer(
                          padding: EdgeInsets.only(left: Dimensions.w_10,right: Dimensions.w_10,bottom: Dimensions.h_15),
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular(8)),
                            color: Theme.of(context).cardColor,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              VerticalSpacing(height: Dimensions.h_10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  TradeBitTextWidget(
                                      title: 'Referral Settings', style: AppTextStyle.themeBoldNormalTextStyle(fontSize: FontSize.sp_14, color: Theme.of(context).shadowColor)),
                                  const Spacer(),
                                  Image.asset(Images.quick,scale: 4.5,),
                                  HorizontalSpacing(width: Dimensions.w_10),

                                ],
                              ),
                              VerticalSpacing(height: Dimensions.h_20),
                              TradeBitContainer(
                                  padding: EdgeInsets.only(top: Dimensions.h_20,bottom: Dimensions.h_20,left: Dimensions.w_25,right: Dimensions.w_50),
                                  decoration: BoxDecoration(
                                    borderRadius:  BorderRadius.all(Radius.circular(Dimensions.h_10)),
                                    color: Theme.of(context).scaffoldBackgroundColor,
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              TradeBitTextWidget(
                                                  title: 'Referral Earning', style: AppTextStyle.themeBoldNormalTextStyle(fontSize: FontSize.sp_13, color:Theme.of(context).shadowColor)),
                                              VerticalSpacing(height: Dimensions.h_15),
                                              TradeBitTextWidget(
                                                  title: '0   TBC', style: AppTextStyle.themeBoldNormalTextStyle(fontSize: FontSize.sp_24, color: Theme.of(context).highlightColor)),
                                            ],
                                          ),
                                          const Spacer(),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              TradeBitTextWidget(
                                                  title: 'Welcome Bonus', style: AppTextStyle.themeBoldNormalTextStyle(fontSize: FontSize.sp_13, color:Theme.of(context).shadowColor)),
                                              VerticalSpacing(height: Dimensions.h_15),
                                              TradeBitTextWidget(
                                                  title: '0   TBC', style: AppTextStyle.themeBoldNormalTextStyle(fontSize:FontSize.sp_24, color:Theme.of(context).highlightColor)),

                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  )
                              ),
                              VerticalSpacing(height: Dimensions.h_10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  TradeBitTextWidget(title: 'or share with link', style: AppTextStyle.normalTextStyle(FontSize.sp_13, Theme.of(context).shadowColor)),
                                  GestureDetector(
                                    onTap: () {
                                     controller.onShareButton();
                                    },
                                      child: const FaIcon(FontAwesomeIcons.whatsapp,color: AppColor.green)),
                                ],
                              ),
                              VerticalSpacing(height: Dimensions.h_10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Expanded(
                                    child: TradeBitContainer(
                                      padding: EdgeInsets.only(top: Dimensions.h_10,bottom: Dimensions.h_10,left: Dimensions.w_10),
                                      decoration: BoxDecoration(
                                          borderRadius:  BorderRadius.all(Radius.circular(Dimensions.h_10)),
                                          color: Theme.of(context).scaffoldBackgroundColor
                                      ),

                                      child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: TradeBitTextWidget(title: 'https://tradebit.io/signup?referral=${LocalStorage.getString(GetXStorageConstants.user)}',style: AppTextStyle.normalTextStyle(FontSize.sp_13, Theme.of(context).highlightColor))),
                                    ),
                                  ),
                                  HorizontalSpacing(width: Dimensions.w_10),
                                  GestureDetector(
                                    onTap: ()=> controller.onCopyClipBoard(context, 'https://tradebit.io/signup?referral=${LocalStorage.getString(GetXStorageConstants.user)}'),
                                      child: Image.asset(Images.clipboard,scale: 4)),
                                ],
                              ),
                            ],
                          ),
                        ),
                        VerticalSpacing(height: Dimensions.h_20),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: TradeBitTextWidget(title: 'Steps', style: AppTextStyle.themeBoldNormalTextStyle(fontSize: FontSize.sp_20, color:Theme.of(context).highlightColor)),
                        ),
                        VerticalSpacing(height: Dimensions.h_5),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: TradeBitTextWidget(title: 'Follow these steps to earn rewards', style: AppTextStyle.normalTextStyle(FontSize.sp_14, Theme.of(context).shadowColor)),
                        ),
                        VerticalSpacing(height: Dimensions.h_20),
                        Row(
                          children: [
                            TradeBitContainer(
                              padding:  EdgeInsets.all(Dimensions.h_12),
                              height: Dimensions.h_50,
                              width: Dimensions.w_50,
                              decoration: BoxDecoration(
                                  color: Theme.of(context).cardColor,
                                  shape: BoxShape.circle
                              ),
                              child: Image.asset(Images.sendinvitation,scale: 3),
                            ),
                            HorizontalSpacing(width: Dimensions.w_20),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TradeBitTextWidget(title: 'Send Invitation', style: AppTextStyle.themeBoldNormalTextStyle(fontSize: FontSize.sp_16, color: AppColor.appColor)),
                                VerticalSpacing(height: Dimensions.h_4),
                                TradeBitTextWidget(title: 'Send you referral link to friends and tell \nthem about tradebit', style: AppTextStyle.normalTextStyle(FontSize.sp_13,Theme.of(context).shadowColor))
                              ],
                            )
                          ],
                        ),
                        VerticalSpacing(height: Dimensions.h_5),
                        Padding(
                          padding:  EdgeInsets.only(left: Dimensions.h_20),
                          child: const Align(
                              alignment: Alignment.centerLeft,
                              child: Dotted()),
                        ),
                        Row(
                          children: [
                            TradeBitContainer(
                              padding:  EdgeInsets.all(Dimensions.h_12),
                              height: Dimensions.h_50,
                              width: Dimensions.w_50,
                              decoration: BoxDecoration(
                                  color: Theme.of(context).cardColor,
                                  shape: BoxShape.circle
                              ),
                              child: Image.asset(Images.regestration,scale: 3,),
                            ),
                            HorizontalSpacing(width: Dimensions.w_20),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TradeBitTextWidget(title: 'Registration', style: AppTextStyle.themeBoldNormalTextStyle(fontSize:FontSize.sp_16, color : AppColor.appColor)),
                                TradeBitTextWidget(title: 'Let them register to our services using \nyour referral link', style: AppTextStyle.normalTextStyle(FontSize.sp_13,Theme.of(context).shadowColor))
                              ],
                            )
                          ],
                        ),
                        VerticalSpacing(height: Dimensions.h_5),
                        Padding(
                          padding:  EdgeInsets.only(left: Dimensions.h_20),
                          child: const Align(
                              alignment: Alignment.centerLeft,
                              child: Dotted()),
                        ),
                        Row(
                          children: [
                            TradeBitContainer(
                              padding:  EdgeInsets.all(Dimensions.h_12),
                              height: Dimensions.h_50,
                              width: Dimensions.w_50,
                              decoration: BoxDecoration(
                                  color: Theme.of(context).cardColor,
                                  shape: BoxShape.circle
                              ),
                              child: Image.asset(Images.enjoy,scale: 3,color: Theme.of(context).shadowColor.withOpacity(0.5)),
                            ),
                            HorizontalSpacing(width: Dimensions.w_20),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TradeBitTextWidget(title: 'Enjoy Reward', style: AppTextStyle.themeBoldNormalTextStyle(fontSize: FontSize.sp_16, color: AppColor.appColor)),
                                VerticalSpacing(height: Dimensions.h_4),
                                TradeBitTextWidget(title: 'Get rewarded upto USD \$1000 (in TBC) \nfor every friend you refer', style: AppTextStyle.normalTextStyle(FontSize.sp_13,Theme.of(context).shadowColor))
                              ],
                            )
                          ],
                        ),
                        VerticalSpacing(height: Dimensions.h_40),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TradeBitTextWidget(title: 'Overview', style: AppTextStyle.themeBoldNormalTextStyle(fontSize: FontSize.sp_20, color: Theme.of(context).highlightColor)),
                            GestureDetector(
                              onTap: () {
                                Get.toNamed(AppRoutes.referralHistory);
                              },
                                child: TradeBitTextWidget(title: ' Referral History', style: AppTextStyle.themeBoldNormalTextStyle(fontSize:FontSize.sp_14, color: AppColor.appColor))),
                          ],
                        ),
                        VerticalSpacing(height: Dimensions.h_5),
                        Align(
                            alignment: Alignment.centerLeft,
                            child: TradeBitTextWidget(title: 'Track your referrals rewards', style: AppTextStyle.normalTextStyle(FontSize.sp_14,Theme.of(context).shadowColor))),
                        VerticalSpacing(height: Dimensions.h_20),
                        TradeBitContainer(
                          padding: EdgeInsets.only(top: Dimensions.h_15,bottom: Dimensions.h_15,left: Dimensions.w_20,right: Dimensions.w_20),
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular(8)),
                            color: Theme.of(context).cardColor,
                          ),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        TradeBitTextWidget(title: '0.00', style: AppTextStyle.themeBoldNormalTextStyle(fontSize: FontSize.sp_24, color: Theme.of(context).highlightColor)),
                                        VerticalSpacing(height: Dimensions.h_8),
                                        TradeBitTextWidget(title: 'Your Earnings', style: AppTextStyle.normalTextStyle(FontSize.sp_13, Theme.of(context).shadowColor.withOpacity(0.7))),

                                      ],
                                    ),
                                    Padding(
                                      padding:  EdgeInsets.only(left: Dimensions.w_30),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          TradeBitTextWidget(title: '0.00', style: AppTextStyle.themeBoldNormalTextStyle(fontSize: FontSize.sp_24, color: Theme.of(context).highlightColor)),
                                          VerticalSpacing(height: Dimensions.h_8),
                                          TradeBitTextWidget(title: 'Welcome Bonus', style: AppTextStyle.normalTextStyle(FontSize.sp_13, Theme.of(context).shadowColor.withOpacity(0.7)))

                                        ],
                                      ),
                                    ),
                                    const SizedBox(),
                                  ],
                                ),
                              ),
                              VerticalSpacing(height: Dimensions.h_25),
                              Padding(
                                padding: const EdgeInsets.only(left:8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        TradeBitTextWidget(title: '0.00', style: AppTextStyle.themeBoldNormalTextStyle(fontSize: FontSize.sp_24, color: Theme.of(context).highlightColor)),
                                        VerticalSpacing(height: Dimensions.h_8),
                                        TradeBitTextWidget(title: 'Total Referrals\n who staked ', style: AppTextStyle.normalTextStyle(FontSize.sp_13, Theme.of(context).shadowColor.withOpacity(0.7))),

                                      ],
                                    ),
                                    Padding(
                                      padding:  EdgeInsets.only(left: Dimensions.w_40,right: 10),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          TradeBitTextWidget(title: '0.00', style: AppTextStyle.themeBoldNormalTextStyle(fontSize: FontSize.sp_24, color: Theme.of(context).highlightColor)),
                                          VerticalSpacing(height: Dimensions.h_8),
                                          TradeBitTextWidget(title: 'Total Referrals', style: AppTextStyle.normalTextStyle(FontSize.sp_13, Theme.of(context).shadowColor.withOpacity(0.7)))

                                        ],
                                      ),
                                    ),
                                    SizedBox(),
                                  ],
                                ),
                              ),
                              VerticalSpacing(height: Dimensions.h_10),
                            ],
                          ),
                        ),
                        VerticalSpacing(height: Dimensions.h_30),
                        TradeBitTextWidget(title: ' *Data    update  time  refers to   UTC +  0 time   zone. The data \n  maintenance   time   is 3am - 5am  (UTC+0)  every day.  During this \n period, the   calculation of  today data  is based  on  the  assets of \n previous   day.   After   maintenance,all data will be displayed properly', style: AppTextStyle.normalTextStyle(FontSize.sp_12, Theme.of(context).shadowColor)),
                        VerticalSpacing(height: Dimensions.h_10),
                        TradeBitTextWidget(title: '*Statement: due to the complexity of financial data, there might be \n  nuances and delay. Data displayed above is for reference only. \n  We sincerely apologize for any inconvenience.', style:AppTextStyle.normalTextStyle(FontSize.sp_12, Theme.of(context).shadowColor) ),
                        VerticalSpacing(height: Dimensions.h_25),
                        Align(
                            alignment: Alignment.centerLeft,
                            child: TradeBitTextWidget(title:'Refer your Friends and Earn Together', style: AppTextStyle.normalTextStyle(FontSize.sp_20, Theme.of(context).highlightColor))),
                        VerticalSpacing(height: Dimensions.h_20),
                        Image.asset(Images.Refer,),
                        VerticalSpacing(height: Dimensions.h_25),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },

    );
  }

  @override
  void dispose() {
  Get.delete<RefferalController>();
    super.dispose();
  }
}

class Dotted extends StatelessWidget {
  const Dotted({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: Dimensions.h_8,
          width: 0.5,
          color: Theme.of(context).shadowColor,
        ),
        VerticalSpacing(height: Dimensions.h_2),
        Container(
          height: Dimensions.h_8,
          width: 0.5,
          color: Theme.of(context).shadowColor,
        ),
        VerticalSpacing(height: Dimensions.h_2),
        Container(
          height: Dimensions.h_8,
          width: 0.5,
          color: Theme.of(context).shadowColor,
        ),
        VerticalSpacing(height: Dimensions.h_2),
        Container(
          height: Dimensions.h_8,
          width: 0.5,
          color: Theme.of(context).shadowColor,
        ),
        VerticalSpacing(height: Dimensions.h_2),
        Container(
          height: Dimensions.h_8,
          width: 0.5,
          color: Theme.of(context).shadowColor,
        ),
        VerticalSpacing(height: Dimensions.h_2),
        Container(
          height: Dimensions.h_8,
          width: 0.5,
          color: Theme.of(context).shadowColor,
        ),
        VerticalSpacing(height: Dimensions.h_2),
      ],
    );
  }
}
