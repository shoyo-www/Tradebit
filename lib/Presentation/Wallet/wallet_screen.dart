import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:tradebit_app/Presentation/Wallet/deposit/deposit_screen.dart';
import 'package:tradebit_app/Presentation/Wallet/wallet_controller.dart';
import 'package:tradebit_app/Presentation/dashboard/dashboard.dart';
import 'package:tradebit_app/constants/appcolor.dart';
import 'package:tradebit_app/constants/apptextstyle.dart';
import 'package:tradebit_app/constants/constants.dart';
import 'package:tradebit_app/constants/fontsize.dart';
import 'package:tradebit_app/constants/images.dart';
import 'package:tradebit_app/data/datasource/local/local_storage.dart';
import 'package:tradebit_app/widgets/spacing.dart';
import 'package:tradebit_app/widgets/trade_bit_container.dart';
import 'package:tradebit_app/widgets/tradebit_cache_image.dart';
import 'package:tradebit_app/widgets/tradebit_scaffold.dart';
import 'package:tradebit_app/widgets/tradebit_text.dart';

class WalletScreen extends StatefulWidget {
  final WalletController controller;
  const WalletScreen({super.key, required this.controller});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  @override
  Widget build(BuildContext context) {
    return TradeBitScaffold(
      backgroundColor: Theme.of(context).cardColor,
      isLoading: widget.controller.walletLoading,
      body: LiquidPullToRefresh(
        height: Dimensions.h_80,
        showChildOpacityTransition: false,
        color: Theme.of(context).cardColor,
        onRefresh: () async{
          widget.controller.getCrypto(context);
          await Future.delayed(const Duration(seconds: 2));
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              TradeBitContainer(
                margin: EdgeInsets.only(left: Dimensions.w_15,right: Dimensions.w_15,bottom: Dimensions.h_10),
                padding: EdgeInsets.only(top: Dimensions.h_20,left: Dimensions.w_10,right: Dimensions.w_10,bottom: Dimensions.h_20),
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
                                  TradeBitTextWidget(title: 'Est Balance', style: AppTextStyle.normalTextStyle(FontSize.sp_12, Theme.of(context).shadowColor)),
                                  HorizontalSpacing(width: Dimensions.w_4),
                                  GestureDetector(
                                      onTap: () {
                                        widget.controller.hideButton();
                                      },
                                      child: Icon(widget.controller.hidePrice ?  Icons.visibility_off : Icons.visibility ,color: Theme.of(context).highlightColor.withOpacity(0.4),size: 18,)),
                                ],
                              ),
                              VerticalSpacing(height: Dimensions.h_10),
                              TradeBitTextWidget(title: widget.controller.hidePrice ? '\$ *****' : double.parse(widget.controller.allQty).toStringAsFixed(2), style: AppTextStyle.themeBoldTextStyle(fontSize: FontSize.sp_26,color: Theme.of(context).highlightColor)),
                              VerticalSpacing(height: Dimensions.h_6),
                              TradeBitTextWidget(title: widget.controller.hidePrice ? '\$ *****' : "\$ ${double.parse(widget.controller.totalBal).toStringAsFixed(2)}", style: AppTextStyle.themeBoldTextStyle(fontSize: FontSize.sp_12,color: Theme.of(context).shadowColor)),
                            ],
                          ),
                        ),
                        const SizedBox(),
                      ],
                    ),
                  ],
                ),
              ),
               TradeBitContainer(
                 margin: EdgeInsets.only(left: Dimensions.w_15,right: Dimensions.w_15,bottom: Dimensions.h_5),
                 decoration: BoxDecoration(
                   borderRadius: BorderRadius.circular(6),
                 ),
                padding: const EdgeInsets.all(5),
                child: Row(
                  children: [
                    SizedBox(
                        height: Dimensions.h_20,
                        width: Dimensions.h_20,
                        child: Image.asset(Images.notification,scale: 4)),
                    HorizontalSpacing(width: Dimensions.w_4),
                    TradeBitTextWidget(title: 'This is a new notification', style: AppTextStyle.normalTextStyle(FontSize.sp_13, Theme.of(context).highlightColor))
                  ],
                ),
              ),
              TradeBitContainer(
                height: Dimensions.h_70,
                margin: EdgeInsets.only(left: Dimensions.w_15,right: Dimensions.w_15),
                padding: EdgeInsets.only(top: Dimensions.h_12,bottom: Dimensions.h_10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Theme.of(context).shadowColor.withOpacity(0.3)
                  )
                ),
                child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: widget.controller.listModal.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (c,i) {
                      return GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          widget.controller.navigate(i, context);
                        },
                        child: Padding(
                          padding: EdgeInsets.only(left: Dimensions.w_20,right: Dimensions.w_20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                  height: Dimensions.h_25,
                                  width: Dimensions.h_25,
                                  child: Image.asset(widget.controller.listModal[i].image)),
                              VerticalSpacing(height: Dimensions.h_5),
                              TradeBitTextWidget(title: widget.controller.listModal[i].name, style: AppTextStyle.normalTextStyle(FontSize.sp_12, Theme.of(context).highlightColor))
                            ],
                          ),
                        ),
                      );
                    }),
              ),
              VerticalSpacing(height: Dimensions.h_30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                       widget.controller.showBottomSheetDeposit(context);
                      },
                      child: TradeBitContainer(
                        margin: EdgeInsets.only(left: Dimensions.w_20),
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                            color: AppColor.transparent,
                            border: Border.all(color:Theme.of(context).shadowColor.withOpacity(0.5)),
                            borderRadius: BorderRadius.circular(30)
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TradeBitTextWidget(title: 'Buy', style: AppTextStyle.themeBoldTextStyle(color: Theme.of(context).highlightColor,fontSize: FontSize.sp_15)),
                            HorizontalSpacing(width: Dimensions.w_8),
                            Image.asset(Images.withdrawImage,scale: 7,color: Theme.of(context).highlightColor,),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        pushWithSlideTransition(context, const DepositScreen());
                      },
                      child: TradeBitContainer(
                        margin: EdgeInsets.only(left: Dimensions.w_20,right: Dimensions.w_20),
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                            color: AppColor.appColor,
                            borderRadius: BorderRadius.circular(30)
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TradeBitTextWidget(title: 'Deposit', style: AppTextStyle.themeBoldTextStyle(color: AppColor.white ,fontSize: FontSize.sp_15)),
                            HorizontalSpacing(width: Dimensions.w_8),
                            Image.asset(Images.depositNew,color: AppColor.white , scale: 7),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              VerticalSpacing(height: Dimensions.h_40),
              Padding(
                padding:  EdgeInsets.only(left: Dimensions.w_15),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: TradeBitTextWidget(title: 'Popular Crypto', style: AppTextStyle.themeBoldNormalTextStyle(
                    color: Theme.of(context).highlightColor,
                    fontSize: FontSize.sp_20
                  )),
                ),
              ),
              VerticalSpacing(height: Dimensions.h_15),
              TradeBitContainer(
                margin: EdgeInsets.only(left: Dimensions.w_15,right: Dimensions.w_15,bottom: Dimensions.h_10),
                height: Dimensions.h_120,
                decoration: BoxDecoration(
                    color: Theme.of(context).cardColor
                ),
                child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: widget.controller.showList.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (c,i) {
                     return GestureDetector(
                       onTap: () {
                         LocalStorage.writeString(GetXStorageConstants.symbol, widget.controller.showList[i].symbol.toString());
                         LocalStorage.writeString(GetXStorageConstants.price, widget.controller.showList[i].price.toString());
                         LocalStorage.writeString(GetXStorageConstants.pair, widget.controller.showList[i].pairWith.toString());
                         LocalStorage.writeString(GetXStorageConstants.name,widget.controller.showList[i].currency.toString());
                         LocalStorage.writeBool(GetXStorageConstants.firstTime, false);
                         LocalStorage.writeBool(GetXStorageConstants.listed, widget.controller.showList[i].listed ?? false);
                         pushReplacementWithSlideTransition(context, DashBoard(index: 2),isBack: true);
                       },
                       child: TradeBitContainer(
                         width: Dimensions.w_100,
                          margin: EdgeInsets.only(right: Dimensions.w_15),
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                              border: Border.all(color: Theme.of(context).shadowColor.withOpacity(0.4)),
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const HorizontalSpacing(width: 10),
                                  SizedBox(
                                      height: Dimensions.h_25,
                                      width: Dimensions.h_25,
                                      child: TradebitCacheImage(image: widget.controller.showList[i].image ?? '',)),
                                  HorizontalSpacing(width: Dimensions.w_35),
                                  SizedBox(
                                      height: Dimensions.h_15,
                                      width: Dimensions.h_15,
                                      child: Image.asset(Images.fire)),
                                ],
                              ),
                              Padding(
                                padding:  EdgeInsets.only(left: 12.0,top: Dimensions.h_3),
                                child: TradeBitTextWidget(title: widget.controller.showList[i].name ?? '', style: AppTextStyle.themeBoldNormalTextStyle(fontSize: FontSize.sp_16,color: Theme.of(context).highlightColor)),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 12.0,top: 3),
                                child: TradeBitTextWidget(title: double.parse(widget.controller.showList[i].price ?? '').toStringAsFixed(2), style: AppTextStyle.normalTextStyle( FontSize.sp_13, Theme.of(context).shadowColor)),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0,top: 3),
                                child: TradeBitTextWidget(title: "${widget.controller.showList[i].change} %" , style: (widget.controller.showList[i].change?.contains('-') ?? false) ? AppTextStyle.themeBoldNormalTextStyle(fontSize: FontSize.sp_18,color: AppColor.red) : AppTextStyle.themeBoldNormalTextStyle(fontSize: FontSize.sp_18,color: AppColor.green)),
                              ),
                            ],
                          ),
                        ),
                     );
                    }),
              ),
              VerticalSpacing(height: Dimensions.h_10),
            ],
          ),
        ),
      ),
    );
  }


}
