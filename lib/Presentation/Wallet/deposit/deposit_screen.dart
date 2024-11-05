import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:remove_emoji_input_formatter/remove_emoji_input_formatter.dart';
import 'package:tradebit_app/Presentation/Wallet/deposit/deposit_controller.dart';
import 'package:tradebit_app/Presentation/Wallet/deposit/deposit_selection.dart';
import 'package:tradebit_app/Presentation/dashboard/dashboard.dart';
import 'package:tradebit_app/constants/apptextstyle.dart';
import 'package:tradebit_app/constants/constants.dart';
import 'package:tradebit_app/constants/fontsize.dart';
import 'package:tradebit_app/constants/images.dart';
import 'package:tradebit_app/data/datasource/local/local_storage.dart';
import 'package:tradebit_app/widgets/spacing.dart';
import 'package:tradebit_app/widgets/tradeBit_scaffold.dart';
import 'package:tradebit_app/widgets/trade_bit_container.dart';
import 'package:tradebit_app/widgets/tradebit_cache_image.dart';
import 'package:tradebit_app/widgets/tradebit_text.dart';

import '../../../widgets/common_app_bar.dart';
class DepositScreen extends StatelessWidget {
  const DepositScreen({super.key});


  @override
  Widget build(BuildContext context) {
    final DepositController controller = Get.put(DepositController());

    return GetBuilder(
      init: controller,
      id: ControllerBuilders.depositController,
      builder: (controller) {
        return WillPopScope(
          onWillPop: () async{
            LocalStorage.getBool(GetXStorageConstants.stakingDeposit) == true ?
            pushReplacementWithSlideTransition(context,DashBoard(index: 0),isBack: true)
                : LocalStorage.getBool(GetXStorageConstants.depositFromHome) == true ? pushReplacementWithSlideTransition(context,DashBoard(index: 0),isBack: true)
                : LocalStorage.getBool(GetXStorageConstants.fromExchange) == true  ?  pushReplacementWithSlideTransition(context,DashBoard(index: 2),isBack: true):
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
                appBar: PreferredSize(preferredSize: Size.fromHeight(Dimensions.h_55), child: TradeBitAppBar(title: 'Deposit', onTap: ()=>
                LocalStorage.getBool(GetXStorageConstants.stakingDeposit) == true ?
                pushReplacementWithSlideTransition(context,DashBoard(index: 0),isBack: true)
                    : LocalStorage.getBool(GetXStorageConstants.depositFromHome) == true ? pushReplacementWithSlideTransition(context,DashBoard(index: 0),isBack: true)
                    : LocalStorage.getBool(GetXStorageConstants.fromExchange) == true  ?  pushReplacementWithSlideTransition(context,DashBoard(index: 2),isBack: true):
                pushReplacementWithSlideTransition(context,DashBoard(index: 3),isBack: true)
                )),
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
                              cursorColor: Theme.of(context).shadowColor.withOpacity(0.6),
                              cursorHeight: 14,
                              style: AppTextStyle.normalTextStyle(FontSize.sp_14, Theme.of(context).highlightColor),
                              padding: const EdgeInsets.only(top: 5,left: 10),
                              controller: controller.searchController,
                              onChanged: (e) {
                                controller.filterSearch(e);
                              },
                              decoration:  BoxDecoration(
                                border: Border.all(
                                    color: Theme.of(context).shadowColor.withOpacity(0.6)
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              placeholder: 'Search here...',
                              placeholderStyle: AppTextStyle.normalTextStyle(FontSize.sp_12, Theme.of(context).shadowColor),
                              suffix: controller.search ? Visibility(
                                visible: controller.search,
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
                        controller.isLoading ? const SizedBox() : controller.depositList.isNotEmpty ? ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.search ? controller.filterList.length : controller.depositList.length,
                  itemBuilder: (c, i) {
                    return GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        controller.depositget();
                        pushWithSlideTransition(context, DepositSelectionScreen(
                          currencyNetwork: controller.search ? controller.filterList : controller.depositList,
                          index: i,
                          network: controller.search ? controller.filterList[i].currencyNetworks ?? [] : controller.depositList[i].currencyNetworks ?? [],
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
                                      child: TradebitCacheImage(image: controller.search ? controller.filterList[i].image ?? '' : controller.depositList[i].image ?? '')),
                                ),
                                HorizontalSpacing(width: Dimensions.w_10),
                                TradeBitTextWidget(title: controller.search ? controller.filterList[i].symbol ?? '' : controller.depositList[i].symbol.toString(), style: AppTextStyle.normalTextStyle(FontSize.sp_16, Theme.of(context).highlightColor),),
                                const Spacer(),
                                Column(
                                  children: [
                                    TradeBitTextWidget(title: double.parse(controller.search ? controller.filterList[i].quantity ?? ''
                                        : controller.depositList[i].quantity.toString()).toStringAsFixed(3), style: AppTextStyle.normalTextStyle(FontSize.sp_16, Theme.of(context).highlightColor)),
                                    TradeBitTextWidget(title: " \$ ${double.parse(controller.search ? controller.filterList[i].cBal.toString() : controller.depositList[i].cBal.toString()).toStringAsFixed(2)}"
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
                                },) :  Padding(
                          padding:  EdgeInsets.only(top: Dimensions.h_40),
                          child: Column(
                            children: [
                              SizedBox(
                                  width: Dimensions.h_200,
                                  child: LottieBuilder.asset(Images.noDataFound)),
                              VerticalSpacing(height: Dimensions.h_30),
                              TradeBitTextWidget(title: 'No Data Found', style: AppTextStyle.themeBoldNormalTextStyle(
                                  fontSize: FontSize.sp_18,
                                  color: Theme.of(context).highlightColor
                              ))
                            ],
                          ),
                        )
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
