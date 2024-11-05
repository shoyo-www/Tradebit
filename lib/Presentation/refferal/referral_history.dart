import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tradebit_app/Presentation/refferal/refferal_controller.dart';
import 'package:tradebit_app/constants/appcolor.dart';
import 'package:tradebit_app/constants/apptextstyle.dart';
import 'package:tradebit_app/constants/constants.dart';
import 'package:tradebit_app/constants/fontsize.dart';
import 'package:tradebit_app/widgets/common_app_bar.dart';
import 'package:tradebit_app/widgets/spacing.dart';
import 'package:tradebit_app/widgets/tradeBit_scaffold.dart';
import 'package:tradebit_app/widgets/trade_bit_container.dart';
import 'package:tradebit_app/widgets/tradebit_text.dart';

class ReferralHistory extends StatefulWidget {
  const ReferralHistory({super.key});

  @override
  State<ReferralHistory> createState() => _ReferralHistoryState();
}

class _ReferralHistoryState extends State<ReferralHistory> {
  RefferalController referralController = Get.put(RefferalController());

  @override
  Widget build(BuildContext context) {
    return TradeBitContainer(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor
      ),
        child: SafeArea(
            child: TradeBitScaffold(
              appBar: PreferredSize(preferredSize: Size.fromHeight(Dimensions.h_50), child: TradeBitAppBar(title: 'Referral History', onTap: () {
                Get.back();
              }
              ),),
                body: Padding(
                  padding:  EdgeInsets.only(left: Dimensions.w_10,right: Dimensions.w_10),
                  child: GetBuilder(
                    init: referralController,
                    id: ControllerBuilders.refferalController,
                    builder: (controller) {
                      return Column(
                        children: [
                          VerticalSpacing(height: Dimensions.h_10),
                          Row(
                            children: [
                              GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () {
                                  controller.getReferral(context);
                                  controller.onReferral();
                                },
                                child: TradeBitContainer(
                                  padding: EdgeInsets.all(Dimensions.h_6),
                                  decoration: BoxDecoration(
                                      color: controller.refferals ? AppColor.appColor : AppColor.transparent,
                                      borderRadius: BorderRadius.circular(Dimensions.h_4)
                                  ),
                                  child: TradeBitTextWidget(title: 'Referrals', style: AppTextStyle.themeBoldTextStyle(
                                      fontSize: FontSize.sp_14,
                                      color: controller.refferals ?AppColor.white : Theme.of(context).shadowColor
                                  ),),
                                ),
                              ),
                              HorizontalSpacing(width: Dimensions.w_20),
                              GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () {
                                  controller.getReferIncome(context);
                                  controller.onCommission();
                                },
                                child: TradeBitContainer(
                                  padding: EdgeInsets.all(Dimensions.h_6),
                                  decoration: BoxDecoration(
                                      color: controller.commission ? AppColor.appColor : AppColor.transparent,
                                      borderRadius: BorderRadius.circular(Dimensions.h_4)
                                  ),
                                  child: TradeBitTextWidget(title: 'Commission', style: AppTextStyle.themeBoldTextStyle(
                                      fontSize: FontSize.sp_14,
                                      color: controller.commission ?AppColor.white : Theme.of(context).shadowColor
                                  ),),
                                ),
                              ),
                            ],
                          ),
                          VerticalSpacing(height: Dimensions.h_30),
                          controller.refferals ?  Padding(
                            padding:  EdgeInsets.only(left: Dimensions.w_10,right: Dimensions.w_10),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TradeBitTextWidget(title: 'UID', style: AppTextStyle.themeBoldTextStyle(
                                        fontSize: FontSize.sp_12,
                                        color: Theme.of(context).shadowColor
                                    ),),
                                    TradeBitTextWidget(title: 'Email', style: AppTextStyle.themeBoldTextStyle(
                                        fontSize: FontSize.sp_12,
                                        color: Theme.of(context).shadowColor
                                    ),),
                                    TradeBitTextWidget(title: 'Completed Date', style: AppTextStyle.themeBoldTextStyle(
                                        fontSize: FontSize.sp_12,
                                        color: Theme.of(context).shadowColor
                                    ),),
                                  ],
                                ),
                                VerticalSpacing(height: Dimensions.h_15),
                               controller.isLoading ? Center(
                                 child: Padding(
                                   padding:  EdgeInsets.only(top: Dimensions.h_200),
                                   child: CupertinoActivityIndicator(
                                     radius: Dimensions.h_12,
                                     color: AppColor.appColor,
                                   ),
                                 ),
                               ) : controller.referral.isNotEmpty ? ListView.separated(
                                  shrinkWrap: true,
                                    itemBuilder: (context,i) {
                                      DateTime dateTime = DateTime.parse(controller.referral[i].updatedAt.toString());
                                      String formattedDate = DateFormat.yMMMMd().format(dateTime);
                                      return Padding(
                                        padding:  EdgeInsets.only(top: Dimensions.h_10,bottom: Dimensions.h_10),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            TradeBitTextWidget(title: controller.referral[i].username ?? '', style: AppTextStyle.themeBoldNormalTextStyle(
                                                fontSize: FontSize.sp_12, color: Theme.of(context).highlightColor
                                            ),),
                                            TradeBitTextWidget(title: controller.referral[i].email ?? '', style: AppTextStyle.themeBoldNormalTextStyle(
                                                fontSize: FontSize.sp_12,
                                                color: Theme.of(context).highlightColor
                                            ),),
                                            TradeBitTextWidget(title: formattedDate, style: AppTextStyle.themeBoldNormalTextStyle(
                                                fontSize: FontSize.sp_12,
                                                color: Theme.of(context).highlightColor
                                            ),),
                                          ],
                                        ),
                                      );
                                    },
                                    separatorBuilder: (context,i) {
                                      return const Divider();
                                    }, itemCount: controller.referral.length) : Center(
                                 child:  Padding(
                                   padding:  EdgeInsets.only(top: Dimensions.h_200),
                                   child: TradeBitTextWidget(title: 'No Data Found', style: AppTextStyle.themeBoldNormalTextStyle(
                                       fontSize: FontSize.sp_16,
                                       color: Theme.of(context).highlightColor
                                   ),),
                                 ),
                               )
                              ],
                            ),
                          ) : Padding(
                            padding:  EdgeInsets.only(left: Dimensions.w_10,right: Dimensions.w_10),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    TradeBitTextWidget(title: 'UID', style: AppTextStyle.themeBoldTextStyle(
                                        fontSize: FontSize.sp_12,
                                        color: Theme.of(context).shadowColor
                                    ),),
                                    TradeBitTextWidget(title: 'Commission', style: AppTextStyle.themeBoldTextStyle(
                                        fontSize: FontSize.sp_12,
                                        color: Theme.of(context).shadowColor
                                    ),),
                                    TradeBitTextWidget(title: 'Status', style: AppTextStyle.themeBoldTextStyle(
                                        fontSize: FontSize.sp_12,
                                        color: Theme.of(context).shadowColor
                                    ),),
                                    TradeBitTextWidget(title: 'Date', style: AppTextStyle.themeBoldTextStyle(
                                        fontSize: FontSize.sp_12,
                                        color: Theme.of(context).shadowColor
                                    ),),
                                  ],
                                ),
                                VerticalSpacing(height: Dimensions.h_15),
                                controller.income ? Center(
                                  child: Padding(
                                    padding:  EdgeInsets.only(top: Dimensions.h_200),
                                    child: CupertinoActivityIndicator(
                                      radius: Dimensions.h_12,
                                      color: AppColor.appColor,
                                    ),
                                  ),
                                ) : controller.referIncome.isNotEmpty ? ListView.separated(
                                    shrinkWrap: true,
                                    itemBuilder: (context,i) {
                                      DateTime dateTime = DateTime.parse(controller.referIncome[i].updatedAt.toString());
                                      String formattedDate = DateFormat.yMMMMd().format(dateTime);
                                      return Padding(
                                        padding:  EdgeInsets.only(top: Dimensions.h_10,bottom: Dimensions.h_10),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            TradeBitTextWidget(title: controller.referIncome[i].username ?? '', style: AppTextStyle.themeBoldNormalTextStyle(
                                                fontSize: FontSize.sp_12, color: Theme.of(context).highlightColor
                                            ),),
                                            HorizontalSpacing(width: Dimensions.w_5),
                                            TradeBitTextWidget(title: controller.referIncome[i].noCommission?.isNotEmpty ?? false ? (controller.referIncome[i].noCommission ?? '') :  '0.0', style: AppTextStyle.themeBoldNormalTextStyle(
                                                fontSize: FontSize.sp_12,
                                                color: Theme.of(context).highlightColor
                                            ),),
                                            HorizontalSpacing(width: Dimensions.w_15),
                                            TradeBitTextWidget(title:  controller.referIncome[i].status == true ? "Active" : "Inactive", style: AppTextStyle.themeBoldNormalTextStyle(
                                                fontSize: FontSize.sp_12,
                                                color: controller.referIncome[i].status == true ? AppColor.green : AppColor.redButton
                                            ),),
                                            TradeBitTextWidget(title:  formattedDate, style: AppTextStyle.themeBoldNormalTextStyle(
                                                fontSize: FontSize.sp_12,
                                                color: Theme.of(context).highlightColor
                                            ),),
                                          ],
                                        ),
                                      );
                                    },
                                    separatorBuilder: (context,i) {
                                      return const Divider();
                                    }, itemCount: controller.referIncome.length) : Center(
                                  child:  Padding(
                                    padding:  EdgeInsets.only(top: Dimensions.h_200),
                                    child: TradeBitTextWidget(title: 'No Data Found', style: AppTextStyle.themeBoldNormalTextStyle(
                                        fontSize: FontSize.sp_16,
                                        color: Theme.of(context).highlightColor
                                    ),),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      );
                    },
                  ),
                ))));
  }
}
