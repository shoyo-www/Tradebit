import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remove_emoji_input_formatter/remove_emoji_input_formatter.dart';
import 'package:tradebit_app/Presentation/Wallet/deposit/deposit_controller.dart';
import 'package:tradebit_app/Presentation/Wallet/withdraw/withdraw_screen.dart';
import 'package:tradebit_app/Presentation/dashboard/dashboard.dart';
import 'package:tradebit_app/constants/apptextstyle.dart';
import 'package:tradebit_app/constants/constants.dart';
import 'package:tradebit_app/constants/fontsize.dart';
import 'package:tradebit_app/data/datasource/local/local_storage.dart';
import 'package:tradebit_app/widgets/spacing.dart';
import 'package:tradebit_app/widgets/tradeBit_scaffold.dart';
import 'package:tradebit_app/widgets/trade_bit_container.dart';
import 'package:tradebit_app/widgets/tradebit_cache_image.dart';
import 'package:tradebit_app/widgets/tradebit_text.dart';

import '../../../widgets/common_app_bar.dart';
class WithdrawList extends StatelessWidget {
  const WithdrawList({super.key});


  @override
  Widget build(BuildContext context) {
    final DepositController controller = Get.put(DepositController());
    return GetBuilder(
      init: controller,
      id: ControllerBuilders.depositController,
      builder: (controller) {
        return WillPopScope(
          onWillPop: () async {
            LocalStorage.getBool(GetXStorageConstants.withdrawFromHome) == true ?
            pushReplacementWithSlideTransition(context,DashBoard(index: 0),isBack: true) :
            LocalStorage.getBool(GetXStorageConstants.fromExchange) == true ?  pushReplacementWithSlideTransition(context,DashBoard(index: 2),isBack: true):
            pushReplacementWithSlideTransition(context,DashBoard(index: 3),isBack: true);
            return false;
          },
          child: TradeBitContainer(
            decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor
            ),
            child: SafeArea(
              child: TradeBitScaffold(
                  isLoading: controller.isLoading,
                  appBar: PreferredSize(preferredSize: Size.fromHeight(Dimensions.h_55), child:
                  TradeBitAppBar(title: 'Withdraw',onTap: ()=>
                  LocalStorage.getBool(GetXStorageConstants.withdrawFromHome) == true ?
                  pushReplacementWithSlideTransition(context,DashBoard(index: 0),isBack: true) :
                  LocalStorage.getBool(GetXStorageConstants.fromExchange) == true ?  pushReplacementWithSlideTransition(context,DashBoard(index: 2),isBack: true):
                  pushReplacementWithSlideTransition(context,DashBoard(index: 3),isBack: true)
                  )
                  ),
                  body:  RefreshIndicator.adaptive(
                    onRefresh: () async {
                      controller.getCrypto(context);
                    },
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Column(
                        children: [
                          Padding(
                            padding:  EdgeInsets.only(left: Dimensions.w_10,right: Dimensions.w_10),
                            child: SizedBox(
                              height: Dimensions.h_35,
                              child: CupertinoTextField(
                                inputFormatters: [RemoveEmojiInputFormatter()],
                                style: AppTextStyle.normalTextStyle(FontSize.sp_16, Theme.of(context).highlightColor),
                                cursorColor: Theme.of(context).shadowColor.withOpacity(0.6),
                                cursorHeight: 14,
                                padding: const EdgeInsets.only(top: 5,left: 10),
                                controller: controller.searchController,
                                onChanged: (e) {
                                  controller.filterSearchWithdraw(e);
                                },
                                decoration:  BoxDecoration(
                                  border: Border.all(
                                      color: Theme.of(context).shadowColor.withOpacity(0.6)
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                placeholder: 'Search here...',
                                placeholderStyle: AppTextStyle.normalTextStyle(FontSize.sp_12, Theme.of(context).shadowColor),
                                suffix: controller.withdrawSearch ? Visibility(
                                  visible: controller.withdrawSearch,
                                  child: GestureDetector(
                                    onTap: () {
                                      controller.onSearchTap();
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 8.0,top: 3,bottom: 3),
                                      child: Icon(Icons.close,color: Colors.grey.withOpacity(0.5),),
                                    ),
                                  ),
                                ) : Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Icon(
                                    CupertinoIcons.search,
                                    color: Colors.grey.withOpacity(0.5),
                                    size: 16,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          VerticalSpacing(height: Dimensions.h_10),
                         controller.isLoading ? const SizedBox.shrink():controller.withdrawList.isNotEmpty ?  ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: controller.withdrawSearch ? controller.withdrawFilter.length : controller.withdrawList.length,
                            itemBuilder: (c, i) {
                              return GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () {
                                  pushWithSlideTransition(context, WithdrawScreen(
                                    currencyNetwork: controller.withdrawSearch ? controller.withdrawFilter : controller.withdrawList,
                                    index: i,
                                    currency: controller.withdrawSearch ? controller.withdrawFilter[i].symbol : controller.withdrawList[i].symbol,
                                    network: controller.withdrawSearch ? controller.withdrawFilter[i].currencyNetworks ?? [] : controller.withdrawList[i].currencyNetworks ?? [],
                                  ));
                                },
                                child: Column(
                                  children: [
                                    TradeBitContainer(
                                      margin: EdgeInsets.only(left: Dimensions.w_6,right: Dimensions.w_6),
                                      padding:  EdgeInsets.only(top: Dimensions.h_10,bottom: Dimensions.h_10,left: Dimensions.h_10,right: Dimensions.h_10),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(30),
                                            child: SizedBox(
                                                height: Dimensions.h_30,
                                                width: Dimensions.h_30,
                                                child: TradebitCacheImage(image: controller.withdrawSearch ? controller.withdrawFilter[i].image ?? '' : controller.withdrawList[i].image ?? '')),
                                          ),
                                          HorizontalSpacing(width: Dimensions.w_10),
                                          TradeBitTextWidget(title: controller.withdrawSearch ? controller.withdrawFilter[i].symbol ?? '' : controller.withdrawList[i].symbol.toString(), style: AppTextStyle.normalTextStyle(FontSize.sp_16, Theme.of(context).highlightColor),),
                                          const Spacer(),
                                          Column(
                                            children: [
                                              TradeBitTextWidget(title: double.parse(controller.withdrawSearch ? controller.withdrawFilter[i].quantity ?? ''
                                                  : controller.withdrawList[i].quantity.toString()).toStringAsFixed(3), style: AppTextStyle.normalTextStyle(FontSize.sp_16, Theme.of(context).highlightColor)),
                                              TradeBitTextWidget(title: " \$ ${double.parse(controller.withdrawSearch ? controller.withdrawFilter[i].cBal.toString() : controller.withdrawList[i].cBal.toString()).toStringAsFixed(2)}"
                                                , style: AppTextStyle.normalTextStyle(FontSize.sp_13, Theme.of(context).shadowColor),),
                                            ],
                                          ),
                                          TradeBitContainer(
                                            margin: EdgeInsets.only(left:Dimensions.w_70),
                                            height: Dimensions.h_20,
                                            padding: const EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Theme.of(context).cardColor
                                            ),
                                            child: Icon(Icons.arrow_forward_ios_outlined,color: Theme.of(context).shadowColor,size: 12,),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }, separatorBuilder: (BuildContext context, int index) {
                            return   Padding(
                              padding: EdgeInsets.only(left: Dimensions.h_15,right: Dimensions.h_15),
                              child: Divider(
                                color: Theme.of(context).shadowColor.withOpacity(0.5),
                              ),
                            );
                          },) : Padding(
                            padding:  EdgeInsets.only(top: Dimensions.h_200),
                            child: TradeBitTextWidget(title: 'Wallet Under Maintenance', style: AppTextStyle.themeBoldNormalTextStyle(
                             fontSize: FontSize.sp_22,color: Theme.of(context).highlightColor
                            )),
                          ),
                        ],
                      ),
                    ),
                  )

              ),
            ),
          ),
        );
      },
    );
  }
}
