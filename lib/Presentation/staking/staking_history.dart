import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:remove_emoji_input_formatter/remove_emoji_input_formatter.dart';
import 'package:tradebit_app/Presentation/dashboard/dashboard.dart';
import 'package:tradebit_app/Presentation/staking/staking_controller.dart';
import 'package:tradebit_app/constants/appcolor.dart';
import 'package:tradebit_app/constants/apptextstyle.dart';
import 'package:tradebit_app/constants/constants.dart';
import 'package:tradebit_app/constants/fontsize.dart';
import 'package:tradebit_app/constants/images.dart';
import 'package:tradebit_app/widgets/common_app_bar.dart';
import 'package:tradebit_app/widgets/spacing.dart';
import 'package:tradebit_app/widgets/tradeBit_scaffold.dart';
import 'package:tradebit_app/widgets/trade_bit_container.dart';
import 'package:tradebit_app/widgets/tradebit_cache_image.dart';
import 'package:tradebit_app/widgets/tradebit_text.dart';

class StakingHistory extends StatefulWidget {
  const StakingHistory({super.key});

  @override
  State<StakingHistory> createState() => _StakingHistoryState();
}

class _StakingHistoryState extends State<StakingHistory> {

  final StakingController stakingController = Get.put(StakingController());
  ScrollController scrollController = ScrollController();
  ScrollController scrollControllerTransaction = ScrollController();

  @override
  initState() {
    super.initState();
    stakingController.getStakingHistory(context);
    stakingController.getStakingTransactions(context);

  }

  @override
  Widget build(BuildContext context) {
    scrollController.addListener(() {
      if (scrollController.offset >= scrollController.position.maxScrollExtent &&
          !scrollController.position.outOfRange) {
        stakingController.loadMore(context);
      }
    });

    scrollControllerTransaction.addListener(() {
      if (scrollControllerTransaction.offset >= scrollControllerTransaction.position.maxScrollExtent &&
          !scrollControllerTransaction.position.outOfRange) {
        stakingController.loadMoreTransaction(context);
      }
    });

    String getDate( String date) {
      DateTime dateTime = DateTime.parse(date).toLocal();
      String formattedDate = DateFormat.yMd().add_Hm().format(dateTime);
      return formattedDate;
    }
    String showDate( String date) {
      DateTime dateTime = DateTime.parse(date).toLocal();
      String formattedDate = DateFormat.yMd().format(dateTime);
      return formattedDate;
    }
    return WillPopScope(
      onWillPop: () async {
        pushReplacementWithSlideTransition(context,DashBoard(index: 4));
        return false;
      },
      child: TradeBitContainer(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor
        ),
        child: GetBuilder(
          id: ControllerBuilders.stakingController,
          init: stakingController,
          builder: (controller) {
            return
              SafeArea(
                child: TradeBitScaffold(
                  isLoading: controller.isLoading,
                    appBar: PreferredSize(preferredSize: Size.fromHeight(Dimensions.h_55), child: TradeBitAppBar(title: 'Staking History',onTap: ()=>
                        pushReplacementWithSlideTransition(context,DashBoard(index: 4))
                    )),
                    body: Padding(
                      padding:  EdgeInsets.only(left: Dimensions.w_10,right: Dimensions.w_10),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          VerticalSpacing(height: Dimensions.h_10),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  await stakingController.getStakingData();
                                  stakingController.getStakingHistory(context);
                                  controller.onHolding();
                                },
                                child: TradeBitContainer(
                                  padding: const EdgeInsets.only(top: 6,bottom: 6,left: 15,right: 15),
                                  decoration: BoxDecoration(
                                      color: controller.holding
                                          ? AppColor.appColor
                                          : Theme
                                          .of(context)
                                          .scaffoldBackgroundColor,
                                      borderRadius: BorderRadius.circular(6)
                                  ),
                                  child: Center(child: TradeBitTextWidget(
                                      title: 'My Holdings',
                                      style: AppTextStyle.themeBoldTextStyle(
                                          color: controller.holding
                                              ? AppColor.white
                                              : Theme
                                              .of(context)
                                              .shadowColor,
                                          fontSize: FontSize.sp_15))),
                                ),
                              ),
                              HorizontalSpacing(width: Dimensions.w_20),
                              GestureDetector(
                                onTap: () {
                                  stakingController.getStakingTransactions(context);
                                  controller.onTransactions();
                                },
                                child: TradeBitContainer(
                                  padding: const EdgeInsets.only(top: 6,bottom: 6,left: 15,right: 15),
                                  decoration: BoxDecoration(
                                      color: controller.transactions
                                          ? AppColor.appColor
                                          : Theme
                                          .of(context)
                                          .scaffoldBackgroundColor,
                                      borderRadius: BorderRadius.circular(6)
                                  ),
                                  child: Center(child: TradeBitTextWidget(
                                      title: 'Transactions',
                                      style: AppTextStyle.themeBoldTextStyle(
                                          color: controller.transactions
                                              ? AppColor.white
                                              : Theme
                                              .of(context)
                                              .shadowColor,
                                          fontSize: FontSize.sp_15))),
                                ),
                              ),
                            ],
                          ),
                          VerticalSpacing(height: Dimensions.h_20),
                          controller.holding ? SizedBox(
                            height: Dimensions.h_35,
                            child: CupertinoTextField(
                              inputFormatters: [RemoveEmojiInputFormatter()],
                              cursorColor: Theme.of(context).shadowColor,
                              style: AppTextStyle.normalTextStyle(FontSize.sp_14, Theme.of(context).highlightColor),
                              placeholderStyle: AppTextStyle.themeBoldNormalTextStyle(
                                  fontSize: FontSize.sp_14,
                                  color: Theme.of(context).shadowColor.withOpacity(0.4)
                              ),
                              onChanged: (e) {
                                controller.filterSearchZero(e);
                              },
                              decoration:  BoxDecoration(
                                color: Theme.of(context).scaffoldBackgroundColor,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Theme.of(context).shadowColor,width: 0.5)
                              ),
                              placeholder: 'Search here....',
                              suffix: Padding(
                                padding: const EdgeInsets.only(left: 8.0,top: 3,bottom: 3,right: 8),
                                child: Icon(CupertinoIcons.search,color: Theme.of(context).shadowColor.withOpacity(0.4),size: 16,),
                              ),
                            ),
                          ) : SizedBox(
                            height: Dimensions.h_35,
                            child: CupertinoTextField(
                              inputFormatters: [RemoveEmojiInputFormatter()],
                              cursorColor: Theme.of(context).shadowColor,
                              style: AppTextStyle.normalTextStyle(FontSize.sp_14, Theme.of(context).highlightColor),
                              placeholderStyle: AppTextStyle.themeBoldNormalTextStyle(
                                  fontSize: FontSize.sp_14,
                                  color: Theme.of(context).shadowColor.withOpacity(0.4)
                              ),
                              onChanged: (e) {
                                controller.filterSearchTransaction(e);
                              },
                              decoration:  BoxDecoration(
                                  color: Theme.of(context).scaffoldBackgroundColor,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Theme.of(context).shadowColor,width: 0.5)
                              ),
                              placeholder: 'Search here....',
                              suffix: Padding(
                                padding: const EdgeInsets.only(left: 8.0,top: 3,bottom: 3,right: 8),
                                child: Icon(CupertinoIcons.search,color: Theme.of(context).shadowColor.withOpacity(0.4),size: 16,),
                              ),
                            ),
                          )
                          ,
                          VerticalSpacing(height: Dimensions.h_20),
                          controller.transactions ?  Expanded(
                            child: Column(
                              children: [
                                controller.transactionsList.isEmpty ? Center(
                                    child: SizedBox(
                                        height: Dimensions.h_200,
                                        child: Lottie.asset(Images.searchAnimation))
                                ) :  Expanded(
                                  child: Stack(
                                    children: [
                                      ListView.separated(
                                        controller: scrollControllerTransaction,
                                          itemCount: controller.transactionSearch ? controller.transactionsListFilter.length : controller.transactionsList.length ?? 0,
                                          shrinkWrap: true,
                                          itemBuilder: (c,i) {
                                            return  TradeBitContainer(
                                              padding: EdgeInsets.only(top: Dimensions.h_10,bottom: Dimensions.h_10,left: Dimensions.w_10,right: Dimensions.w_10),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          SizedBox(
                                                            height: Dimensions.h_20,
                                                            width: Dimensions.h_20,
                                                            child: TradebitCacheImage(image: controller.transactionSearch ? controller.transactionsListFilter[i].currencyImage ?? '' :controller.transactionsList[i].currencyImage ?? '',),
                                                          ),
                                                          HorizontalSpacing(width: Dimensions.w_10),
                                                          Row(
                                                            children: [
                                                              TradeBitTextWidget(title:controller.transactionSearch ? controller.transactionsListFilter[i].currency ?? '' :  controller.transactionsList[i].currency ?? '', style: AppTextStyle.themeBoldNormalTextStyle(
                                                                  fontSize: FontSize.sp_13,
                                                                  color: Theme.of(context).highlightColor
                                                              )),
                                                              HorizontalSpacing(width: Dimensions.w_10),
                                                              TradeBitContainer(
                                                                padding: EdgeInsets.only(left: Dimensions.h_2,top: Dimensions.h_2,bottom: Dimensions.h_2,right: Dimensions.h_2),
                                                                decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.circular(Dimensions.h_4),
                                                                  border: Border.all(
                                                                    width: 0.5,
                                                                    color: AppColor.appColor
                                                                  )
                                                                ),
                                                                child: TradeBitTextWidget(title: controller.transactionSearch ? controller.transactionsListFilter[i].transactionType ?? '' : controller.transactionsList[i].transactionType ?? '', style: AppTextStyle.themeBoldNormalTextStyle(
                                                                    fontSize: FontSize.sp_13,
                                                                    color: AppColor.appColor
                                                                )),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                      VerticalSpacing(height: Dimensions.h_6),
                                                      Row(
                                                        children: [
                                                          TradeBitTextWidget(title:  'Amt:', style: AppTextStyle.themeBoldNormalTextStyle(
                                                              fontSize: FontSize.sp_12,
                                                              color: Theme.of(context).shadowColor
                                                          )),
                                                          HorizontalSpacing(width: Dimensions.w_5),
                                                          TradeBitTextWidget(title: double.parse(controller.transactionSearch ? controller.transactionsListFilter[i].credit ?? '0.0' : controller.transactionsList[i].credit ?? '0.0').toStringAsFixed(8) , style: AppTextStyle.themeBoldNormalTextStyle(
                                                              fontSize: FontSize.sp_13,
                                                              color: AppColor.green
                                                          )),
                                                        ],
                                                      ),

                                                    ],
                                                  ),
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                    children: [
                                                      TradeBitTextWidget(title: getDate(controller.transactionSearch ? controller.transactionsList[i].updatedAt.toString() : controller.transactionsList[i].updatedAt.toString()) ?? '', style: AppTextStyle.themeBoldNormalTextStyle(
                                                          fontSize: FontSize.sp_13,
                                                          color: Theme.of(context).highlightColor
                                                      )),
                                                      VerticalSpacing(height: Dimensions.h_6),
                                                      Row(
                                                        children: [
                                                          TradeBitTextWidget(title:  'Bal', style: AppTextStyle.themeBoldNormalTextStyle(
                                                              fontSize: FontSize.sp_13,
                                                              color: Theme.of(context).shadowColor
                                                          )),
                                                          HorizontalSpacing(width: Dimensions.w_5),
                                                          TradeBitTextWidget(title: double.parse(controller.transactionSearch ? controller.transactionsList[i].balance ?? '0.0' : controller.transactionsList[i].balance ?? '0.0').toStringAsFixed(8) , style: AppTextStyle.themeBoldNormalTextStyle(
                                                              fontSize: FontSize.sp_13,
                                                              color: Theme.of(context).highlightColor
                                                          )),
                                                        ],
                                                      ),

                                                    ],
                                                  ),
                                                ],
                                              ),
                                            );
                                          }, separatorBuilder: (BuildContext context, int index) {
                                            return const Divider();
                                      },),
                                      Positioned(
                                          bottom: -1,
                                          left: MediaQuery.sizeOf(context).width/ 2.2,
                                          child: controller.isLoadingMoreTransaction ? const CupertinoActivityIndicator(color: AppColor.appColor) : const SizedBox.shrink())
                                    ],
                                  ),
                                )
                              ],
                            ),
                          )
                      : Expanded(
                        child: Column(
                          children: [
                            controller.stakingHistorylength.isEmpty ? Center(
                                child: SizedBox(
                                    height: Dimensions.h_200,
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: Dimensions.h_170,
                                            child: Lottie.asset(Images.searchAnimation)),
                                        TradeBitTextWidget(title: 'N0 Data Found', style: AppTextStyle.themeBoldNormalTextStyle(
                                            fontSize: FontSize.sp_16,
                                            color: AppColor.appColor
                                        )),
                                      ],
                                    ))
                            ) :
                            Expanded(
                              child: ListView.separated(
                                itemCount: controller.holdingSearch ? controller.stakingHistoryFilter.length : controller.stakingHistorylength.length ,
                                shrinkWrap: true,
                                controller: scrollController,
                                itemBuilder: (c,i) {
                                  return  TradeBitContainer(
                                    padding: EdgeInsets.only(top: Dimensions.h_10,bottom: Dimensions.h_10,left: Dimensions.w_10,right: Dimensions.w_10),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        TradeBitTextWidget(title: controller.holdingSearch ? controller.stakingHistoryFilter[i].rewardCurrency ?? ''  : controller.stakingHistorylength[i].rewardCurrency ?? '', style: AppTextStyle.themeBoldNormalTextStyle(
                                                            fontSize: FontSize.sp_13,
                                                            color: Theme.of(context).highlightColor
                                                        )),
                                                        HorizontalSpacing(width: Dimensions.w_10),
                                                        controller.holdingSearch ? controller.stakingHistoryFilter[i].planType == 'fixed' ?  SizedBox.shrink(): GestureDetector(
                                                          behavior: HitTestBehavior.opaque,
                                                          onTap: () {
                                                            controller.cancelOrderDailog(context, controller,controller.stakingHistorylength[i].id ?? 0);
                                                          },
                                                          child: TradeBitContainer(
                                                            padding: EdgeInsets.only(left: Dimensions.h_2,top: Dimensions.h_2,bottom: Dimensions.h_2,right: Dimensions.h_2),
                                                            decoration: BoxDecoration(
                                                                borderRadius: BorderRadius.circular(Dimensions.h_4),
                                                                border: Border.all(
                                                                    width: 0.5,
                                                                    color: AppColor.appColor
                                                                )
                                                            ),
                                                            child: TradeBitTextWidget(title: 'Unsubscribe', style: AppTextStyle.themeBoldNormalTextStyle(
                                                                fontSize: FontSize.sp_13,
                                                                color: AppColor.appColor
                                                            )),
                                                          ),
                                                        ) : controller.stakingHistorylength[i].planType == 'fixed' ?
                                                        SizedBox.shrink(): GestureDetector(
                                                          behavior: HitTestBehavior.opaque,
                                                          onTap: () {
                                                            controller.cancelOrderDailog(context, controller,controller.stakingHistorylength[i].id ?? 0);
                                                          },
                                                          child: TradeBitContainer(
                                                            padding: EdgeInsets.only(left: Dimensions.h_2,top: Dimensions.h_2,bottom: Dimensions.h_2,right: Dimensions.h_2),
                                                            decoration: BoxDecoration(
                                                                borderRadius: BorderRadius.circular(Dimensions.h_4),
                                                                border: Border.all(
                                                                    width: 0.5,
                                                                    color: AppColor.appColor
                                                                )
                                                            ),
                                                            child: TradeBitTextWidget(title: 'Unsubscribe', style: AppTextStyle.themeBoldNormalTextStyle(
                                                                fontSize: FontSize.sp_13,
                                                                color: AppColor.appColor
                                                            )),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                VerticalSpacing(height: Dimensions.h_6),
                                                Row(
                                                  children: [
                                                    TradeBitTextWidget(title:  'Amt:', style: AppTextStyle.themeBoldNormalTextStyle(
                                                        fontSize: FontSize.sp_12,
                                                        color: Theme.of(context).shadowColor
                                                    )),
                                                    HorizontalSpacing(width: Dimensions.w_5),
                                                    TradeBitTextWidget(title: double.parse(controller.holdingSearch ? controller.stakingHistoryFilter[i].amount ?? '0.0' :controller.stakingHistorylength[i].amount ?? '0.0').toStringAsFixed(4) , style: AppTextStyle.themeBoldTextStyle(
                                                        fontSize: FontSize.sp_13,
                                                        color:Theme.of(context).highlightColor
                                                    )),
                                                  ],
                                                ),

                                              ],
                                            ),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              children: [
                                                TradeBitTextWidget(title: "${controller.search ? controller.stakingHistoryFilter[i].stakingPlan?.maturityDays.toString(): controller.stakingHistorylength[i].stakingPlan?.maturityDays.toString()} ${ controller.holdingSearch ? controller.stakingHistoryFilter[i].planType:controller.stakingHistorylength[i].planType}" , style: AppTextStyle.themeBoldNormalTextStyle(
                                                    fontSize: FontSize.sp_13,
                                                    color: Theme.of(context).highlightColor
                                                )),
                                                VerticalSpacing(height: Dimensions.h_6),
                                                Row(
                                                  children: [
                                                    TradeBitTextWidget(title:  'Reward:', style: AppTextStyle.themeBoldNormalTextStyle(
                                                        fontSize: FontSize.sp_13,
                                                        color: Theme.of(context).shadowColor
                                                    )),
                                                    HorizontalSpacing(width: Dimensions.w_5),
                                                    TradeBitTextWidget(title: double.parse(controller.search ? controller.stakingHistoryFilter[i].roiIncome ?? '' : controller.stakingHistorylength[i].roiIncome ?? '0.0').toStringAsFixed(4) , style: AppTextStyle.themeBoldNormalTextStyle(
                                                        fontSize: FontSize.sp_13,
                                                        color: AppColor.green
                                                    )),
                                                  ],
                                                ),
                                                VerticalSpacing(height: Dimensions.h_6),
                                              ],

                                            )
                                          ],
                                        ),
                                        VerticalSpacing(height: Dimensions.h_5),
                                        Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                TradeBitTextWidget(title:  'Sub Date:', style: AppTextStyle.themeBoldNormalTextStyle(
                                                    fontSize: FontSize.sp_12,
                                                    color: Theme.of(context).shadowColor
                                                )),
                                                HorizontalSpacing(width: Dimensions.w_5),
                                                TradeBitTextWidget(title: showDate(controller.holdingSearch ? controller.stakingHistoryFilter[i].activationDate.toString() : controller.stakingHistorylength[i].activationDate.toString()) , style: AppTextStyle.themeBoldTextStyle(
                                                    fontSize: FontSize.sp_13,
                                                    color:Theme.of(context).highlightColor
                                                )),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                TradeBitTextWidget(title:  'Intr.End Date:', style: AppTextStyle.themeBoldNormalTextStyle(
                                                    fontSize: FontSize.sp_12,
                                                    color: Theme.of(context).shadowColor
                                                )),
                                                HorizontalSpacing(width: Dimensions.w_5),
                                                TradeBitTextWidget(title: showDate(controller.holdingSearch ? controller.stakingHistoryFilter[i].expiryDate.toString() :controller.stakingHistorylength[i].expiryDate.toString()) , style: AppTextStyle.themeBoldTextStyle(
                                                    fontSize: FontSize.sp_13,
                                                    color:Theme.of(context).highlightColor
                                                )),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                }, separatorBuilder: (BuildContext context, int index) {
                                return const Divider();
                              },),
                            )
                          ],
                        ),
                      ),

                        ],
                      ),
                    )));
            },
        ),
      ),
    );
  }
}
