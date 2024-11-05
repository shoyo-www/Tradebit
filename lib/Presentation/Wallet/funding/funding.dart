import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:remove_emoji_input_formatter/remove_emoji_input_formatter.dart';
import 'package:tradebit_app/Presentation/Wallet/coin_details.dart';
import 'package:tradebit_app/Presentation/Wallet/wallet_controller.dart';
import 'package:tradebit_app/Presentation/dashboard/dashboard.dart';
import 'package:tradebit_app/constants/apptextstyle.dart';
import 'package:tradebit_app/constants/fontsize.dart';
import 'package:tradebit_app/widgets/spacing.dart';
import 'package:tradebit_app/widgets/trade_bit_container.dart';
import 'package:tradebit_app/widgets/tradebit_cache_image.dart';
import 'package:tradebit_app/widgets/tradebit_scaffold.dart';
import 'package:tradebit_app/widgets/tradebit_text.dart';

class Funding extends StatelessWidget {
  final WalletController controller;
  const Funding({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return  TradeBitScaffold(
        backgroundColor: Theme.of(context).cardColor,
        body: SingleChildScrollView(
          child: Column(
            children: [
              TradeBitContainer(
                margin: EdgeInsets.only(left: Dimensions.w_15,right: Dimensions.w_15,bottom: Dimensions.h_10),
                padding: EdgeInsets.only(top: Dimensions.h_25,left: Dimensions.w_10,right: Dimensions.w_10,bottom: Dimensions.h_10),
                width: Dimensions.deviceWidth,
                decoration:  BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Theme.of(context).scaffoldBackgroundColor
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding:  EdgeInsets.only(left: Dimensions.w_8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  TradeBitTextWidget(title: 'Available Balance', style: AppTextStyle.normalTextStyle(FontSize.sp_15, Theme.of(context).shadowColor)),
                                  HorizontalSpacing(width: Dimensions.w_15),
                                  GestureDetector(
                                      onTap: () {
                                        controller.hideButton();
                                      },
                                      child: Icon(controller.hidePrice ?  Icons.visibility_off : Icons.visibility ,color: Theme.of(context).highlightColor.withOpacity(0.4),size: 18,)),
                                ],
                              ),
                              VerticalSpacing(height: Dimensions.h_10),
                              TradeBitTextWidget(title: controller.hidePrice ? '\$ *****' : double.parse(controller.fundQuant).toStringAsFixed(2), style: AppTextStyle.themeBoldTextStyle(fontSize: FontSize.sp_22,color: Theme.of(context).highlightColor)),
                              VerticalSpacing(height: Dimensions.h_3),
                              TradeBitTextWidget(title: controller.hidePrice ? '\$ *****' : "\$ ${double.parse(controller.fundBalance).toStringAsFixed(2)}", style: AppTextStyle.themeBoldTextStyle(fontSize: FontSize.sp_15,color: Theme.of(context).shadowColor)),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TradeBitTextWidget(title: 'Freeze Total', style: AppTextStyle.normalTextStyle(FontSize.sp_15, Theme.of(context).shadowColor)),
                            VerticalSpacing(height: Dimensions.h_10),
                            TradeBitTextWidget(title: controller.hidePrice ? '\$ *****' : controller.freezeFundingQuantity, style: AppTextStyle.themeBoldTextStyle(fontSize: FontSize.sp_22,color: Theme.of(context).highlightColor)),
                            VerticalSpacing(height: Dimensions.h_3),
                            TradeBitTextWidget(title: controller.hidePrice ? '\$ *****' : "\$ ${controller.freezeFundPrice}", style: AppTextStyle.themeBoldTextStyle(fontSize: FontSize.sp_15,color: Theme.of(context).shadowColor)),
                          ],
                        ),
                        const SizedBox(),
                      ],
                    ),
                    VerticalSpacing(height: Dimensions.h_20),
                  ],
                ),
              ),
              VerticalSpacing(height: Dimensions.h_10),
              TradeBitContainer(
                decoration: BoxDecoration(
                    color: Theme.of(context).cardColor
                ),
                child: Column(
                  children: [
                    VerticalSpacing(height: Dimensions.h_10),
                    Padding(
                      padding: const EdgeInsets.only(left: 30,right: 8),
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TradeBitTextWidget(title: "Assets", style: AppTextStyle.themeBoldTextStyle(fontSize: FontSize.sp_20,color: Theme.of(context).highlightColor)),
                              VerticalSpacing(height: Dimensions.h_3),
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      controller.hideZeroBal();
                                    },
                                    child: TradeBitContainer(
                                      height: Dimensions.h_10,
                                      width: Dimensions.h_10,
                                      decoration: BoxDecoration(
                                          color: controller.hideZeroBalance ? Theme.of(context).scaffoldBackgroundColor : Theme.of(context).cardColor,
                                          border: Border.all(
                                              color: Theme.of(context).shadowColor.withOpacity(0.5)
                                          )
                                      ),
                                      child: controller.hideZeroBalance ?  Icon(Icons.check,color: Theme.of(context).highlightColor,size: 10,) : const SizedBox(),
                                    ),
                                  ),
                                  HorizontalSpacing(width: Dimensions.w_5),
                                  TradeBitTextWidget(title: "Hide 0 Balance", style: AppTextStyle.themeBoldTextStyle(fontSize: FontSize.sp_12,color: Theme.of(context).shadowColor)),
                                ],
                              ),
                            ],
                          ),
                          const Spacer(),
                          controller.hideZeroBalance ? Padding(
                            padding:  EdgeInsets.only(left: Dimensions.w_10,right: Dimensions.w_10),
                            child: SizedBox(
                              height: Dimensions.h_30,
                              width: MediaQuery.sizeOf(context).width / 2.5,
                              child: CupertinoTextField(
                                inputFormatters: [RemoveEmojiInputFormatter()],
                                style: AppTextStyle.normalTextStyle(FontSize.sp_12, Theme.of(context).highlightColor),
                                cursorColor: Theme.of(context).shadowColor.withOpacity(0.6),
                                cursorHeight: 14,
                                padding: const EdgeInsets.only(top: 0,left: 10),
                                controller: controller.zeroSearchControllerFund,
                                onChanged: (e) {
                                  controller.filterSearchZeroFund(e);
                                },
                                decoration:  BoxDecoration(
                                  border: Border.all(
                                      color: Theme.of(context).shadowColor.withOpacity(0.6)
                                  ),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                placeholder: 'Search here...',
                                placeholderStyle: AppTextStyle.normalTextStyle(FontSize.sp_12, Theme.of(context).shadowColor),
                                suffix: controller.zeroSearchFund ? Visibility(
                                  visible: controller.zeroSearchFund,
                                  child: GestureDetector(
                                    onTap: () {
                                      controller.zeroSearchFundClear();
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
                          ) : Padding(
                            padding:  EdgeInsets.only(left: Dimensions.w_10,right: Dimensions.w_10),
                            child: SizedBox(
                              height: Dimensions.h_30,
                              width: MediaQuery.sizeOf(context).width / 2.5,
                              child: CupertinoTextField(
                                inputFormatters: [RemoveEmojiInputFormatter()],
                                style: AppTextStyle.normalTextStyle(FontSize.sp_12, Theme.of(context).highlightColor),
                                cursorColor: Theme.of(context).shadowColor.withOpacity(0.6),
                                cursorHeight: 14,
                                padding: const EdgeInsets.only(top: 0,left: 10),
                                controller: controller.searchController,
                                onChanged: (e) {
                                  controller.filterSearch(e);
                                },
                                decoration:  BoxDecoration(
                                  border: Border.all(
                                      color: Theme.of(context).shadowColor.withOpacity(0.6)
                                  ),
                                  borderRadius: BorderRadius.circular(30),
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
                        ],
                      ),
                    ),
                    VerticalSpacing(height: Dimensions.h_15),
                    VerticalSpacing(height: Dimensions.h_10),
                   controller.hideZeroBalance ? ListView.separated(
                     shrinkWrap: true,
                     physics: const NeverScrollableScrollPhysics(),
                     itemCount: controller.zeroSearchFund ? controller.zeroFilterFund.length : controller.zeroFilterListFund.length,
                     itemBuilder: (c, i) {
                       return GestureDetector(
                         behavior: HitTestBehavior.opaque,
                         onTap: () {
                           controller.getSymbol(controller.zeroSearchFund ? controller.zeroFilterFund[i].symbol ?? '' :controller.zeroFilterListFund[i].symbol ?? '');
                           pushWithSlideTransition(context, CoinDetails(
                             currencyNetwork:controller.zeroSearchFund ? controller.zeroFilterFund:  controller.zeroFilterListFund ?? [],
                             index: i,
                             network: controller.zeroSearchFund ? controller.zeroFilterFund[i].currencyNetworks ?? [] :  controller.zeroFilterListFund[i].currencyNetworks ?? [],
                             symbol: controller.zeroSearchFund ? controller.zeroFilterFund[i].symbol ?? '' : controller.zeroFilterListFund[i].symbol ?? '',
                           ));
                         },
                         child: TradeBitContainer(
                           margin: EdgeInsets.only(left: Dimensions.w_6,right: Dimensions.w_6),
                           padding:  EdgeInsets.only(top: Dimensions.h_10,bottom: Dimensions.h_10,left: Dimensions.h_15,right: Dimensions.h_15),
                           child: Row(
                             children: [
                               ClipRRect(
                                 borderRadius: BorderRadius.circular(30),
                                 child: SizedBox(
                                     height: Dimensions.h_25,
                                     width: Dimensions.h_25,
                                     child: TradebitCacheImage(image:controller.zeroSearchFund ? controller.zeroFilterFund[i].image ?? '' : controller.zeroFilterListFund[i].image ?? '')),
                               ),
                               HorizontalSpacing(width: Dimensions.w_10),
                               Column(
                                 crossAxisAlignment: CrossAxisAlignment.start,
                                 children: [
                                   TradeBitTextWidget(title: controller.zeroSearchFund ? controller.zeroFilterFund[i].symbol.toString() : controller.zeroFilterListFund[i].symbol.toString(), style: AppTextStyle.themeBoldNormalTextStyle(fontSize : FontSize.sp_16, color: Theme.of(context).highlightColor),),
                                   TradeBitTextWidget(title: controller.zeroSearchFund ? controller.zeroFilterFund[i].name ?? '' : controller.zeroFilterListFund[i].name.toString(), style: AppTextStyle.normalTextStyle( FontSize.sp_13,Theme.of(context).shadowColor),),
                                 ],
                               ),
                               const Spacer(),
                               Column(
                                 crossAxisAlignment: CrossAxisAlignment.end,
                                 children: [
                                   TradeBitTextWidget(title: double.parse(controller.zeroSearchFund ? controller.zeroFilterFund[i].fundQuantity.toString() : controller.zeroFilterListFund[i].fundQuantity.toString()).toStringAsFixed(8), style: AppTextStyle.normalTextStyle(FontSize.sp_15, Theme.of(context).highlightColor)),
                                   TradeBitTextWidget(title: "\$ ${double.parse(controller.zeroSearchFund ? controller.zeroFilterFund[i].fundBal.toString():  controller.zeroFilterListFund[i].fundBal.toString()).toStringAsFixed(2)}", style: AppTextStyle.normalTextStyle(FontSize.sp_13, Theme.of(context).shadowColor)),
                                 ],
                               ),
                               HorizontalSpacing(width: Dimensions.w_15),
                               Icon(Icons.arrow_forward_ios,size: 12,color: Theme.of(context).highlightColor,)
                             ],
                           ),
                         ),
                       );
                     }, separatorBuilder: (BuildContext context, int index) {
                     return Padding(
                       padding: EdgeInsets.only(left: Dimensions.h_15,right: Dimensions.h_15),
                       child: Divider(
                         color: Theme.of(context).shadowColor.withOpacity(0.5),
                       ),
                     );
                   },) : ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: controller.search ? controller.filterList.length : controller.walletList?.length ?? 0,
                      itemBuilder: (c, i) {
                        return GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            controller.getSymbol(controller.search ? controller.filterList[i].symbol ?? '' : controller.walletList?[i].symbol ?? '');
                            pushWithSlideTransition(context, CoinDetails(
                              currencyNetwork:controller.zeroSearchFund ? controller.zeroFilterFund:  controller.zeroFilterListFund ?? [],
                              index: i,
                              network: controller.zeroSearchFund ? controller.zeroFilterFund[i].currencyNetworks ?? [] :  controller.zeroFilterListFund[i].currencyNetworks ?? [],
                              symbol: controller.zeroSearchFund ? controller.zeroFilterFund[i].symbol ?? '' : controller.zeroFilterListFund[i].symbol ?? '',
                            ));
                          },
                          child: TradeBitContainer(
                            margin: EdgeInsets.only(left: Dimensions.w_6,right: Dimensions.w_6),
                            padding:  EdgeInsets.only(top: Dimensions.h_10,bottom: Dimensions.h_10,left: Dimensions.h_15,right: Dimensions.h_15),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(30),
                                  child: SizedBox(
                                      height: Dimensions.h_25,
                                      width: Dimensions.h_25,
                                      child: TradebitCacheImage(image: controller.search ? controller.filterList[i].image ?? '' : controller.walletList?[i].image ?? '')),
                                ),
                                HorizontalSpacing(width: Dimensions.w_10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TradeBitTextWidget(title: controller.search ? controller.filterList[i].symbol ?? '' : controller.walletList![i].symbol.toString(), style: AppTextStyle.themeBoldNormalTextStyle(fontSize : FontSize.sp_16, color: Theme.of(context).highlightColor),),
                                    TradeBitTextWidget(title:  controller.search ? controller.filterList[i].name ?? '' : controller.walletList![i].name.toString(), style: AppTextStyle.normalTextStyle( FontSize.sp_13,Theme.of(context).shadowColor),),

                                  ],
                                ),
                                const Spacer(),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    TradeBitTextWidget(title: double.parse(controller.search ? controller.filterList[i].fundQuantity ?? ''
                                        : controller.walletList![i].fundQuantity.toString()).toStringAsFixed(8), style: AppTextStyle.normalTextStyle(FontSize.sp_15, Theme.of(context).highlightColor)),
                                    TradeBitTextWidget(title: "\$ ${double.parse(controller.search ? controller.filterList[i].fundBal ?? '' : controller.walletList![i].fundBal.toString()).toStringAsFixed(2)}", style: AppTextStyle.normalTextStyle(FontSize.sp_13, Theme.of(context).shadowColor)),
                                  ],
                                ),
                                HorizontalSpacing(width: Dimensions.w_15),
                                Icon(Icons.arrow_forward_ios,size: 12,color: Theme.of(context).highlightColor)
                              ],
                            ),
                          ),
                        );
                      }, separatorBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: EdgeInsets.only(left: Dimensions.h_15,right: Dimensions.h_15),
                        child: Divider(
                          color: Theme.of(context).shadowColor.withOpacity(0.5),
                        ),
                      );
                    },)
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}