import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remove_emoji_input_formatter/remove_emoji_input_formatter.dart';
import 'package:tradebit_app/Presentation/Auth/login/login.dart';
import 'package:tradebit_app/Presentation/dashboard/dashboard.dart';
import 'package:tradebit_app/Presentation/staking/staking_controller.dart';
import 'package:tradebit_app/Presentation/staking/staking_history.dart';
import 'package:tradebit_app/Presentation/staking/staking_order_screen.dart';
import 'package:tradebit_app/constants/appcolor.dart';
import 'package:tradebit_app/constants/apptextstyle.dart';
import 'package:tradebit_app/constants/constants.dart';
import 'package:tradebit_app/constants/fontsize.dart';
import 'package:tradebit_app/data/datasource/local/local_storage.dart';
import 'package:tradebit_app/widgets/spacing.dart';
import 'package:tradebit_app/widgets/tradeBit_scaffold.dart';
import 'package:tradebit_app/widgets/trade_bit_container.dart';
import 'package:tradebit_app/widgets/tradebit_cache_image.dart';
import 'package:tradebit_app/widgets/tradebit_text.dart';
import 'package:shimmer/shimmer.dart';

class Staking extends StatefulWidget {
  const Staking({super.key});

  @override
  State<Staking> createState() => _StakingState();
}

class _StakingState extends State<Staking> {
  final StakingController stakingController = Get.put(StakingController());

  @override
  void dispose() {
    stakingController.search =false;
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return TradeBitContainer(
      decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor
      ),
      child: SafeArea(
        child: GetBuilder(
            id: ControllerBuilders.stakingController,
            init: stakingController,
            builder: (controller) {
              return TradeBitScaffold(
                body: SingleChildScrollView(
                  child: Padding(
                    padding:  EdgeInsets.only(left: Dimensions.w_15,right: Dimensions.w_15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        VerticalSpacing(height: Dimensions.h_20),
                        Padding(
                          padding:  EdgeInsets.only(left: Dimensions.w_15),
                          child: TradeBitTextWidget(title: 'Stake & Earn ', style: AppTextStyle.themeBoldNormalTextStyle(
                              fontSize: FontSize.sp_22,
                              color: Theme.of(context).highlightColor
                          )),
                        ),
                        VerticalSpacing(height: Dimensions.h_20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                controller.onAll();
                              },
                              child: TradeBitContainer(
                                padding: const EdgeInsets.only(top: 6,bottom: 6,left: 15,right: 15),
                                decoration: BoxDecoration(
                                    color: controller.all
                                        ? AppColor.appColor
                                        : Theme
                                        .of(context)
                                        .scaffoldBackgroundColor,
                                    borderRadius: BorderRadius.circular(6)
                                ),
                                child: Center(child: TradeBitTextWidget(
                                    title: 'All',
                                    style: AppTextStyle.themeBoldTextStyle(
                                        color: controller.all
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
                                controller.onFixed();
                              },
                              child: TradeBitContainer(
                                padding: const EdgeInsets.only(top: 6,bottom: 6,left: 15,right: 15),
                                decoration: BoxDecoration(
                                    color: controller.fixed
                                        ? AppColor.appColor
                                        : Theme
                                        .of(context)
                                        .scaffoldBackgroundColor,
                                    borderRadius: BorderRadius.circular(6)
                                ),
                                child: Center(child: TradeBitTextWidget(
                                    title: 'Fixed',
                                    style: AppTextStyle.themeBoldTextStyle(
                                        color: controller.fixed
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
                                controller.onFlexible();
                              },
                              child: TradeBitContainer(
                                padding: const EdgeInsets.only(top: 6,bottom: 6,left: 15,right: 15),
                                decoration: BoxDecoration(
                                    color: controller.flexible
                                        ? AppColor.appColor
                                        : Theme
                                        .of(context)
                                        .scaffoldBackgroundColor,
                                    borderRadius: BorderRadius.circular(6)
                                ),
                                child: Center(child: TradeBitTextWidget(
                                    title: 'Flexible',
                                    style: AppTextStyle.themeBoldTextStyle(
                                        color: controller.flexible
                                            ? AppColor.white
                                            : Theme
                                            .of(context)
                                            .shadowColor,
                                        fontSize: FontSize.sp_15))),
                              ),
                            ),
                            const Spacer(),
                            LocalStorage.getBool(GetXStorageConstants.userLogin) == true ? const SizedBox.shrink(): GestureDetector(
                              onTap: () {
                                pushReplacementWithSlideTransition(context, const StakingHistory());
                              },
                              child: TradeBitContainer(
                                padding: const EdgeInsets.only(top: 6,bottom: 8,left: 15,right: 15),
                                decoration: BoxDecoration(
                                    border: Border.all(color: Theme.of(context).shadowColor.withOpacity(0.5),width: 0.5),
                                    color:  Theme.of(context).scaffoldBackgroundColor,
                                    borderRadius: BorderRadius.circular(6)
                                ),
                                child: Center(child: TradeBitTextWidget(
                                    title: 'History',
                                    style: AppTextStyle.themeBoldTextStyle(
                                        color:  Theme
                                            .of(context)
                                            .shadowColor,
                                        fontSize: FontSize.sp_15))),
                              ),
                            )
                          ],
                        ),
                        VerticalSpacing(height: Dimensions.h_20),
                        SizedBox(
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
                              controller.filterSearch(e);
                            },
                            decoration:  BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            placeholder: 'Search',
                            suffix: Padding(
                              padding: const EdgeInsets.only(left: 8.0,top: 3,bottom: 3,right: 8),
                              child: Icon(CupertinoIcons.search,color: Theme.of(context).shadowColor.withOpacity(0.4),size: 16,),
                            ),
                          ),
                        ),
                        VerticalSpacing(height: Dimensions.h_30),
                       controller.isLoading ? ShimmerList() : controller.fixed ? RefreshIndicator(
                         onRefresh: () async {
                           controller.getStaking(context);
                         },
                         child: GridView.builder(
                             itemCount: controller.search ? controller.filterList.length : controller.fixedList.length,
                             shrinkWrap: true,
                             gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                               crossAxisCount: 2,
                               crossAxisSpacing: 7,
                               mainAxisSpacing: 7,
                             ), itemBuilder: (c,i) {
                           return  TradeBitContainer(
                             padding: EdgeInsets.only(left: Dimensions.w_8,right: Dimensions.w_8,top: Dimensions.h_15),
                             decoration: BoxDecoration(
                                 color: Theme.of(context).cardColor,
                                 borderRadius: BorderRadius.circular(8)
                             ),
                             child: Column(
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: [
                                 Row(
                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                   children: [
                                     Row(
                                       children: [
                                         SizedBox(
                                           height: Dimensions.h_20,
                                           width: Dimensions.h_20,
                                           child: TradebitCacheImage(image: controller.search ? controller.filterList[i].stakeCurrencyImage ?? '' : controller.fixedList[i].stakeCurrencyImage ?? ''),
                                         ),
                                         HorizontalSpacing(width: Dimensions.w_5),
                                         TradeBitTextWidget(title: controller.search ? controller.filterList[i].stakeCurrency ?? '' : controller.fixedList[i].stakeCurrency ?? '', style: AppTextStyle.themeBoldNormalTextStyle(
                                             fontSize: FontSize.sp_16,
                                             color: Theme.of(context).highlightColor
                                         ))
                                       ],
                                     ),
                                     LocalStorage.getBool(GetXStorageConstants.userLogin) == false ? GestureDetector(
                                       onTap: () {
                                         Navigator.push(context, MaterialPageRoute(builder: (_)=> StakingOrderScreen(
                                             symbol: controller.search ? controller.filterList[i].stakeCurrency : controller.fixedList[i].stakeCurrency,
                                             index: i,
                                             stakingList: controller.stakingList,
                                             date: DateTime.now(),
                                         )));
                                       },
                                       child: TradeBitContainer(
                                           padding: const EdgeInsets.only(left: 5,right: 5,top: 3,bottom: 5),
                                           decoration:  BoxDecoration(
                                               color: AppColor.appColor.withOpacity(0.8),
                                               borderRadius: BorderRadius.circular(30)
                                           ),
                                           child: TradeBitTextWidget(title: 'Subscribe',style: AppTextStyle.themeBoldNormalTextStyle(
                                               fontSize: FontSize.sp_12,
                                               color: AppColor.white
                                           ),)
                                       ),
                                     ) : TradeBitContainer(
                                         padding: const EdgeInsets.only(left: 5,right: 5,top: 3,bottom: 5),
                                         decoration:  BoxDecoration(
                                             color: AppColor.appColor.withOpacity(0.8),
                                             borderRadius: BorderRadius.circular(30)
                                         ),
                                         child: TradeBitTextWidget(title: 'Subscribe',style: AppTextStyle.themeBoldNormalTextStyle(
                                             fontSize: FontSize.sp_12,
                                             color: AppColor.white
                                         ),)
                                     ),
                                   ],
                                 ),
                                 VerticalSpacing(height: Dimensions.h_12),
                                 Row(
                                   children: [
                                     TradeBitTextWidget(title: "Fixed", style: AppTextStyle.themeBoldNormalTextStyle(
                                         fontSize: FontSize.sp_14,
                                         color: Theme.of(context).highlightColor
                                     )),
                                     TradeBitContainer(
                                       margin: const EdgeInsets.only(left: 4,right: 4),
                                       height: Dimensions.h_12,
                                       width: 1,
                                       decoration: const BoxDecoration(color: AppColor.appColor),
                                     ),
                                     TradeBitTextWidget(title: controller.search ? (controller.filterList[0].oPlanDays?.fixed?[0].toString() ?? '')   : (controller.fixedList[0].oPlanDays?.fixed?[0].toString() ?? ''), style: AppTextStyle.themeBoldNormalTextStyle(
                                         fontSize: FontSize.sp_14,
                                         color: Theme.of(context).highlightColor
                                     )),
                                   ],
                                 ),
                                 VerticalSpacing(height: Dimensions.h_6),
                                 TradeBitTextWidget(title: 'Duration (Days)', style: AppTextStyle.themeBoldNormalTextStyle(
                                     fontSize: FontSize.sp_12,
                                     color: Theme.of(context).shadowColor
                                 )),
                                 VerticalSpacing(height: Dimensions.h_20),
                                 Row(
                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                   children: [
                                     Column(
                                       crossAxisAlignment: CrossAxisAlignment.start,
                                       children: [
                                         TradeBitTextWidget(title: "${controller.search ? controller.filterList[0].sData?.fixed90?.roiPercentage ?? '' : controller.fixedList[0].sData?.fixed90?.roiPercentage ?? '' } %", style: AppTextStyle.themeBoldNormalTextStyle(
                                             fontSize: FontSize.sp_14,
                                             color: Colors.green
                                         )),
                                         TradeBitTextWidget(title: 'Est.APR', style: AppTextStyle.themeBoldNormalTextStyle(
                                             fontSize: FontSize.sp_12,
                                             color: Theme.of(context).shadowColor
                                         )),
                                       ],
                                     ),
                                     Column(
                                       crossAxisAlignment: CrossAxisAlignment.start,
                                       children: [
                                         TradeBitTextWidget(title: controller.search ? controller.fixedList[i].sData?.fixed365?.minStakeAmount ?? '' : controller.fixedList[i].sData?.fixed365?.minStakeAmount ?? '10', style: AppTextStyle.themeBoldNormalTextStyle(
                                             fontSize: FontSize.sp_14,
                                             color: Theme.of(context).highlightColor
                                         )),
                                         TradeBitTextWidget(title: 'Min', style: AppTextStyle.themeBoldNormalTextStyle(
                                             fontSize: FontSize.sp_12,
                                             color: Theme.of(context).shadowColor
                                         )),
                                       ],
                                     ),
                                     Column(
                                       crossAxisAlignment: CrossAxisAlignment.start,
                                       children: [
                                         TradeBitTextWidget(title: controller.search ? controller.fixedList[i].sData?.fixed365?.maxStakeAmount ?? '' : controller.fixedList[i].sData?.fixed365?.maxStakeAmount ?? '10', style: AppTextStyle.themeBoldNormalTextStyle(
                                             fontSize: FontSize.sp_14,
                                             color: Theme.of(context).highlightColor
                                         )),
                                         TradeBitTextWidget(title: 'Max', style: AppTextStyle.themeBoldNormalTextStyle(
                                             fontSize: FontSize.sp_12,
                                             color: Theme.of(context).shadowColor
                                         )),
                                       ],
                                     ),
                                   ],
                                 ),
                               ],
                             ),
                           );
                         }),
                       ) :
                      controller.isLoading ? ShimmerList() : RefreshIndicator(
                         onRefresh: () async {
                           controller.getStaking(context);
                         },
                         child: GridView.builder(
                              itemCount: controller.search ? controller.filterList.length : controller.stakingList.length,
                              shrinkWrap: true,
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 7,
                                mainAxisSpacing: 7,
                              ), itemBuilder: (c,i) {
                            return  TradeBitContainer(
                              padding: EdgeInsets.only(left: Dimensions.w_8,right: Dimensions.w_8,top: Dimensions.h_10),
                              decoration: BoxDecoration(
                                  color: Theme.of(context).cardColor,
                                  borderRadius: BorderRadius.circular(8)
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          SizedBox(
                                            height: Dimensions.h_20,
                                            width: Dimensions.h_20,
                                            child: TradebitCacheImage(image: controller.search ? controller.filterList[i].stakeCurrencyImage ?? '' : controller.stakingList[i].stakeCurrencyImage ?? ''),
                                          ),
                                          HorizontalSpacing(width: Dimensions.w_5),
                                          TradeBitTextWidget(title: controller.search ? controller.filterList[i].stakeCurrency ?? '' : controller.stakingList[i].stakeCurrency ?? '', style: AppTextStyle.themeBoldNormalTextStyle(
                                              fontSize: FontSize.sp_16,
                                              color: Theme.of(context).highlightColor
                                          ))
                                        ],
                                      ),
                                      LocalStorage.getBool(GetXStorageConstants.userLogin) == false ? GestureDetector(
                                        behavior: HitTestBehavior.opaque,
                                        onTap: () {
                                          pushWithSlideTransition(context, StakingOrderScreen(
                                            symbol: controller.search ? controller.filterList[i].stakeCurrency : controller.stakingList[i].stakeCurrency,
                                            index: i,
                                            stakingList: controller.stakingList,
                                            date: DateTime.now(),
                                          ));
                                        },
                                        child: TradeBitContainer(
                                            padding: const EdgeInsets.only(left: 5,right: 5,top: 3,bottom: 5),
                                            decoration:  BoxDecoration(
                                                color: AppColor.appColor.withOpacity(0.8),
                                                borderRadius: BorderRadius.circular(30)
                                            ),
                                            child: TradeBitTextWidget(title: 'Subscribe',style: AppTextStyle.themeBoldNormalTextStyle(
                                                fontSize: FontSize.sp_12,
                                                color: AppColor.white
                                            ),)
                                        ),
                                      ) : GestureDetector(
                                        behavior: HitTestBehavior.opaque,
                                        onTap: () {
                                          pushReplacementWithSlideTransition(context,  const Login());
                                        },
                                        child: TradeBitContainer(
                                            padding: const EdgeInsets.only(left: 5,right: 5,top: 3,bottom: 5),
                                            decoration:  BoxDecoration(
                                                color: AppColor.appColor.withOpacity(0.8),
                                                borderRadius: BorderRadius.circular(30)
                                            ),
                                            child: TradeBitTextWidget(title: 'Subscribe',style: AppTextStyle.themeBoldNormalTextStyle(
                                                fontSize: FontSize.sp_12,
                                                color: AppColor.white
                                            ),)
                                        ),
                                      ),
                                    ],
                                  ),
                                  VerticalSpacing(height: Dimensions.h_15),
                                  Row(
                                    children: [
                                      TradeBitTextWidget(title: controller.search ? (controller.filterList[i].aPlanTypes?.contains('fixed') ?? false ? 'Fixed' : 'Flexible') : controller.all ? (controller.stakingList[i].aPlanTypes?.contains('fixed') ?? false ? 'Fixed' : 'Flexible') : 'Flexible', style: AppTextStyle.themeBoldNormalTextStyle(
                                          fontSize: FontSize.sp_14,
                                          color: Theme.of(context).highlightColor
                                      )),
                                      TradeBitContainer(
                                        margin: const EdgeInsets.only(left: 4,right: 4),
                                        height: Dimensions.h_12,
                                        width: 1,
                                        decoration: const BoxDecoration(color: AppColor.appColor),
                                      ),
                                      TradeBitTextWidget(title: controller.search ? (controller.filterList[i].oPlanDays?.flexible?[0].toString() ?? '- -') : controller.stakingList[i].oPlanDays?.flexible?[0].toString() ?? '- - ', style: AppTextStyle.themeBoldNormalTextStyle(
                                          fontSize: FontSize.sp_14,
                                          color: Theme.of(context).highlightColor
                                      )),
                                    ],
                                  ),
                                  VerticalSpacing(height: Dimensions.h_6),
                                  TradeBitTextWidget(title: 'Duration (Days)', style: AppTextStyle.themeBoldNormalTextStyle(
                                      fontSize: FontSize.sp_12,
                                      color: Theme.of(context).shadowColor
                                  )),
                                  VerticalSpacing(height: Dimensions.h_20),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          TradeBitTextWidget(title: controller.search ?
                                          "${controller.filterList[i].aPlanTypes?.contains('fixed') ?? false ? (controller.filterList[i].sData?.fixed365?.roiPercentage?.isNotEmpty ?? false ?controller.filterList[i].sData?.fixed365?.roiPercentage  :controller.filterList[i].sData?.fixed90?.roiPercentage)  ?? '10' : controller.filterList[i].sData?.flexible365?.roiPercentage ?? '10'}%" :
                                          "${ ((controller.stakingList[i].aPlanTypes?.contains('fixed') ?? false) && controller.all == true) ? (controller.stakingList[i].sData?.fixed365?.roiPercentage?.isNotEmpty ?? false ? controller.stakingList[i].sData?.fixed365?.roiPercentage : controller.stakingList[i].sData?.fixed90?.roiPercentage ) ?? '':  controller.stakingList[i].sData?.flexible365?.roiPercentage ?? '10'}%", style: AppTextStyle.themeBoldNormalTextStyle(
                                              fontSize: FontSize.sp_14,
                                              color: Colors.green
                                          )),
                                          TradeBitTextWidget(title: 'Est.APR', style: AppTextStyle.themeBoldNormalTextStyle(
                                              fontSize: FontSize.sp_12,
                                              color: Theme.of(context).shadowColor
                                          )),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          TradeBitTextWidget(title: controller.search ? (controller.filterList[i].aPlanTypes?.contains('fixed') ?? false ? controller.filterList[i].sData?.fixed365?.minStakeAmount ?? '10' : controller.filterList[i].sData?.flexible365?.minStakeAmount ?? '') : controller.stakingList[i].aPlanTypes?.contains('fixed') ?? false ? controller.stakingList[i].sData?.fixed365?.minStakeAmount ?? '10': controller.stakingList[i].sData?.flexible365?.minStakeAmount ?? '10', style: AppTextStyle.themeBoldNormalTextStyle(
                                              fontSize: FontSize.sp_14,
                                              color: Theme.of(context).highlightColor
                                          )),
                                          TradeBitTextWidget(title: 'Min', style: AppTextStyle.themeBoldNormalTextStyle(
                                              fontSize: FontSize.sp_12,
                                              color: Theme.of(context).shadowColor
                                          )),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          TradeBitTextWidget(title: controller.search ? (controller.filterList[i].aPlanTypes?.contains('fixed') ?? false ? controller.filterList[i].sData?.fixed365?.maxStakeAmount ?? '10' : controller.filterList[i].sData?.flexible365?.maxStakeAmount ?? '') : controller.stakingList[i].aPlanTypes?.contains('fixed') ?? false ? controller.stakingList[i].sData?.fixed365?.maxStakeAmount ?? '10': controller.stakingList[i].sData?.flexible365?.maxStakeAmount ?? '10', style: AppTextStyle.themeBoldNormalTextStyle(
                                              fontSize: FontSize.sp_14,
                                              color: Theme.of(context).highlightColor
                                          )),
                                          TradeBitTextWidget(title: 'Max', style: AppTextStyle.themeBoldNormalTextStyle(
                                              fontSize: FontSize.sp_12,
                                              color: Theme.of(context).shadowColor
                                          )),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          }),
                       )
                      ],
                    ),
                  ),
                ),
              );
            }
        ),
      ),
    );
  }

}


class ShimmerList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Theme.of(context).cardColor,
      highlightColor: Theme.of(context).scaffoldBackgroundColor,
      child: GridView.builder(
          itemCount: 4,
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 7,
            mainAxisSpacing: 7,
          ), itemBuilder: (c,i) {
        return  TradeBitContainer(
          padding: EdgeInsets.only(left: Dimensions.w_8,right: Dimensions.w_8,top: Dimensions.h_10),
          decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(8)
          ),
          child:  Row(
            children: [
              TradeBitContainer(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).shadowColor,
                ),
                width: Dimensions.h_20,
                height: Dimensions.h_20,
              ),
              HorizontalSpacing(width: Dimensions.w_10),
              Expanded(
                child: TradeBitContainer(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.h_4),
                    color: Theme.of(context).shadowColor,
                  ),
                  height: Dimensions.h_20,
                ),
              ),
            ],
          ),
        );
      })
    );
  }
}