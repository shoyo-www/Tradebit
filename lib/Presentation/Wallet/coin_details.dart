import 'package:flutter/material.dart';
import 'package:tradebit_app/Presentation/Wallet/deposit/deposit.dart';
import 'package:tradebit_app/Presentation/Wallet/withdraw/withdraw.dart';
import 'package:tradebit_app/Presentation/dashboard/dashboard.dart';
import 'package:tradebit_app/constants/appcolor.dart';
import 'package:tradebit_app/constants/apptextstyle.dart';
import 'package:tradebit_app/constants/constants.dart';
import 'package:tradebit_app/constants/fontsize.dart';
import 'package:tradebit_app/constants/images.dart';
import 'package:tradebit_app/data/datasource/local/local_storage.dart';
import 'package:tradebit_app/data/datasource/remote/models/response/walletListResponse.dart';
import 'package:tradebit_app/widgets/common_app_bar.dart';
import 'package:tradebit_app/widgets/spacing.dart';
import 'package:tradebit_app/widgets/tradeBit_scaffold.dart';
import 'package:tradebit_app/widgets/trade_bit_container.dart';
import 'package:tradebit_app/widgets/tradebit_cache_image.dart';
import 'package:tradebit_app/widgets/tradebit_text.dart';

class CoinDetails extends StatefulWidget {
  final int index;
  final List<Datum> currencyNetwork;
  final List<CurrencyNetwork> network;
  final String symbol;
  const CoinDetails({super.key, required this.index, required this.currencyNetwork, required this.network,required this.symbol});

  @override
  State<CoinDetails> createState() => _CoinDetailsState();
}

class _CoinDetailsState extends State<CoinDetails> {
  double? total;
  double? totalQty;

  @override
  void initState() {
    total = double.parse(widget.currencyNetwork[widget.index].cBal ?? '') + double.parse(widget.currencyNetwork[widget.index].freezedBalance ?? '');
    totalQty = double.parse(widget.currencyNetwork[widget.index].quantity ?? '') + double.parse(widget.currencyNetwork[widget.index].fcBal ?? '');
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return  TradeBitContainer(
      decoration: BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor),
      child: SafeArea(
        child: TradeBitScaffold(
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      pushWithSlideTransition(context, Deposit(index: widget.index,
                        currencyNetwork: widget.currencyNetwork,
                        network: widget.network, symbol: widget.symbol,
                      ));
                    },
                    child: TradeBitContainer(
                      margin: EdgeInsets.only(left: Dimensions.w_20,right: Dimensions.w_20),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: AppColor.white,
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TradeBitTextWidget(title: 'Deposit', style: AppTextStyle.themeBoldTextStyle(color: AppColor.black ,fontSize: FontSize.sp_15)),
                          HorizontalSpacing(width: Dimensions.w_8),
                          SizedBox(
                              height: Dimensions.h_25,
                              width: Dimensions.h_25,
                              child: Image.asset(Images.deposit,scale: 4,color: AppColor.black)),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      pushWithSlideTransition(context, Withdraw(index: widget.index,
                        currencyNetwork: widget.currencyNetwork,
                        network: widget.network,
                      ));
                    },
                    child: TradeBitContainer(
                      margin: EdgeInsets.only(left: Dimensions.w_20,right: Dimensions.w_20),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: AppColor.appColor,
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TradeBitTextWidget(title: 'Withdraw', style: AppTextStyle.themeBoldTextStyle(color: AppColor.white ,fontSize: FontSize.sp_15)),
                          HorizontalSpacing(width: Dimensions.w_8),
                          SizedBox(
                              height: Dimensions.h_25,
                              width: Dimensions.h_25,
                              child: Image.asset(Images.withdrawLight)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          appBar: PreferredSize(preferredSize: Size.fromHeight(Dimensions.h_55), child: TradeBitAppBar(title: '',onTap: ()=> Navigator.pop(context))),
            body:  Padding(
              padding:  EdgeInsets.only(left: Dimensions.w_20,right: Dimensions.w_20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  VerticalSpacing(height: Dimensions.h_10),
                  Row(
                    children: [
                      SizedBox(
                          height: Dimensions.h_30,
                          width: Dimensions.h_30,
                          child: TradebitCacheImage(image: widget.currencyNetwork[widget.index].image ?? '')),
                      HorizontalSpacing(width: Dimensions.w_10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TradeBitTextWidget(title: widget.currencyNetwork[widget.index].symbol ?? '', style: AppTextStyle.themeBoldNormalTextStyle(fontSize: FontSize.sp_26,color: Theme.of(context).highlightColor)),
                          VerticalSpacing(height: Dimensions.h_2),
                          TradeBitTextWidget(title: widget.currencyNetwork[widget.index].name ?? '', style: AppTextStyle.themeBoldNormalTextStyle(fontSize: FontSize.sp_16,color: Theme.of(context).shadowColor)),
                        ],
                      ),
                    ],
                  ),
                   VerticalSpacing(height: Dimensions.h_30),
                  TradeBitTextWidget(title: 'Total (USDT)', style: AppTextStyle.themeBoldNormalTextStyle(fontSize: FontSize.sp_14,color: Theme.of(context).highlightColor)),
                  VerticalSpacing(height: Dimensions.h_5),
                  TradeBitTextWidget(title: totalQty?.toStringAsFixed(8) ?? '', style: AppTextStyle.themeBoldNormalTextStyle(fontSize: FontSize.sp_26,color: Theme.of(context).highlightColor)),
                  TradeBitTextWidget(title: '\$ ${total?.toStringAsFixed(3)}', style: AppTextStyle.themeBoldNormalTextStyle(fontSize: FontSize.sp_14,color: Theme.of(context).shadowColor)),
                  VerticalSpacing(height: Dimensions.h_25),
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TradeBitTextWidget(title: 'Available', style: AppTextStyle.themeBoldNormalTextStyle(fontSize: FontSize.sp_15,color: Theme.of(context).highlightColor)),
                          VerticalSpacing(height: Dimensions.h_2),
                          TradeBitTextWidget(title: double.parse(widget.currencyNetwork[widget.index].quantity ?? '').toStringAsFixed(8), style: AppTextStyle.themeBoldNormalTextStyle(fontSize: FontSize.sp_14,color: Theme.of(context).highlightColor)),
                          VerticalSpacing(height: Dimensions.h_5),
                          TradeBitTextWidget(title: '\$${double.parse(widget.currencyNetwork[widget.index].cBal ?? '').toStringAsFixed(3)}', style: AppTextStyle.themeBoldNormalTextStyle(fontSize: FontSize.sp_14,color: Theme.of(context).shadowColor)),
                        ],
                      ),
                      HorizontalSpacing(width: Dimensions.w_135),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TradeBitTextWidget(title: 'Frozen', style: AppTextStyle.themeBoldNormalTextStyle(fontSize: FontSize.sp_15,color: Theme.of(context).highlightColor)),
                          VerticalSpacing(height: Dimensions.h_2),
                          TradeBitTextWidget(title: double.parse(widget.currencyNetwork[widget.index].freezedBalance ?? '').toStringAsFixed(8), style: AppTextStyle.themeBoldNormalTextStyle(fontSize: FontSize.sp_14,color: Theme.of(context).highlightColor)),
                          VerticalSpacing(height: Dimensions.h_5),
                          TradeBitTextWidget(title: '\$${double.parse(widget.currencyNetwork[widget.index].fcBal ?? '').toStringAsFixed(3)}', style: AppTextStyle.themeBoldNormalTextStyle(fontSize: FontSize.sp_14,color: Theme.of(context).shadowColor)),
                        ],
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: ()=> pushReplacementWithSlideTransition(context,DashBoard(index: 2)),
                    child: TradeBitContainer(
                      margin: EdgeInsets.only(top: Dimensions.h_45),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TradeBitTextWidget(title: 'Buy & Sell Crypto', style: AppTextStyle.themeBoldNormalTextStyle(
                                fontSize: FontSize.sp_18,
                                color: Theme.of(context).highlightColor
                              )),
                              VerticalSpacing(height: Dimensions.h_2),
                              TradeBitTextWidget(title: 'Visa/MasterCard/Apple Pay/Bank Transfer', style: AppTextStyle.themeBoldNormalTextStyle(
                                  fontSize: FontSize.sp_13,
                                  color: Theme.of(context).shadowColor
                              ))
                            ],
                          ),
                           Icon(Icons.arrow_forward_ios,color: Theme.of(context).highlightColor,size: 12)
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: ()=> pushReplacementWithSlideTransition(context,DashBoard(index: 4)),
                    child: TradeBitContainer(
                      margin: EdgeInsets.only(top: Dimensions.h_10),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TradeBitTextWidget(title: 'Stake & Earn', style: AppTextStyle.themeBoldNormalTextStyle(
                                fontSize: FontSize.sp_18,
                                color: Theme.of(context).highlightColor
                              )),
                              VerticalSpacing(height: Dimensions.h_2),
                              TradeBitTextWidget(title: 'Earn safely & conveniently', style: AppTextStyle.themeBoldNormalTextStyle(
                                  fontSize: FontSize.sp_13,
                                  color: Theme.of(context).shadowColor
                              ))
                            ],
                          ),
                           Icon(Icons.arrow_forward_ios,color: Theme.of(context).highlightColor,size: 12,)
                        ],
                      ),
                    ),
                  )
                ],
              ),
            )),
      ),
    );
  }
}
