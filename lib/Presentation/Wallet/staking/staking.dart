import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:remove_emoji_input_formatter/remove_emoji_input_formatter.dart';
import 'package:tradebit_app/Presentation/Wallet/staking/reedem.dart';
import 'package:tradebit_app/Presentation/Wallet/wallet_controller.dart';
import 'package:tradebit_app/constants/appcolor.dart';
import 'package:tradebit_app/constants/apptextstyle.dart';
import 'package:tradebit_app/constants/constants.dart';
import 'package:tradebit_app/constants/fontsize.dart';
import 'package:tradebit_app/constants/images.dart';
import 'package:tradebit_app/widgets/spacing.dart';
import 'package:tradebit_app/widgets/tradeBit_scaffold.dart';
import 'package:tradebit_app/widgets/trade_bit_container.dart';
import 'package:tradebit_app/widgets/tradebit_cache_image.dart';
import 'package:tradebit_app/widgets/tradebit_text.dart';

class StakingScreen extends StatefulWidget {
  final WalletController controller;
  const StakingScreen({super.key, required this.controller});

  @override
  State<StakingScreen> createState() => _StakingScreenState();
}

class _StakingScreenState extends State<StakingScreen> {

  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if (scrollController.offset >= scrollController.position.maxScrollExtent &&
          !scrollController.position.outOfRange) {
        widget.controller.loadMore(context);
      }
    });
  }

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
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                                        widget.controller.hideButton();
                                      },
                                      child: Icon(widget.controller.hidePrice ?  Icons.visibility_off : Icons.visibility ,color: Theme.of(context).highlightColor.withOpacity(0.4),size: 18,)),
                                ],
                              ),
                              VerticalSpacing(height: Dimensions.h_10),
                              TradeBitTextWidget(title: widget.controller.hidePrice ? '\$ *****' : widget.controller.stakeWalletBalance, style: AppTextStyle.themeBoldTextStyle(fontSize: FontSize.sp_22,color: Theme.of(context).highlightColor)),
                              VerticalSpacing(height: Dimensions.h_3),
                              TradeBitTextWidget(title: widget.controller.hidePrice ? '\$ *****' : "\$ ${'0.000000000'}", style: AppTextStyle.themeBoldTextStyle(fontSize: FontSize.sp_15,color: Theme.of(context).shadowColor)),
                            ],
                          ),
                        ),
                        Padding(
                          padding:  EdgeInsets.only(right: Dimensions.w_8),
                          child: GestureDetector(
                              onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (context)=> const Redeem())),
                              child: TradeBitTextWidget(title: 'Redeem ', style: AppTextStyle.themeBoldNormalTextStyle(fontSize:FontSize.sp_15, color:Theme.of(context).shadowColor))),
                        ),
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
                          TradeBitTextWidget(title: "Assets", style: AppTextStyle.themeBoldTextStyle(fontSize: FontSize.sp_20,color: Theme.of(context).highlightColor)),
                          VerticalSpacing(height: Dimensions.h_3),
                          const Spacer(),
                          Padding(
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
                                controller: widget.controller.stakingSearchController,
                                onChanged: (e) {
                                  widget.controller.filterSearchStaking(e);
                                },
                                decoration:  BoxDecoration(
                                  border: Border.all(
                                      color: Theme.of(context).shadowColor.withOpacity(0.6)
                                  ),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                placeholder: 'Search here...',
                                placeholderStyle: AppTextStyle.normalTextStyle(FontSize.sp_12, Theme.of(context).shadowColor),
                                suffix: widget.controller.stakingSearch ? Visibility(
                                  visible: widget.controller.stakingSearch,
                                  child: GestureDetector(
                                    onTap: () {
                                      widget.controller.onSearchStaking();
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
                    widget.controller.stakingHistorylength.isEmpty ? Padding(
                      padding:  EdgeInsets.only(top: Dimensions.h_40),
                      child: Column(
                        children: [
                          SizedBox(
                              width: Dimensions.h_200,
                              child: LottieBuilder.asset(Images.noDataFound)),
                          VerticalSpacing(height: Dimensions.h_30),
                          TradeBitTextWidget(title: 'No Data Found', style: AppTextStyle.themeBoldNormalTextStyle(
                              fontSize: FontSize.sp_18,
                              color: Theme.of(context).highlightColor))
                        ],
                      ),
                    ) : ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      controller: scrollController,
                      itemCount: widget.controller.stakingSearch ? widget.controller.filterListStaking.length : widget.controller.stakingHistorylength.length,
                      itemBuilder: (c, i) {
                        return GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            // Navigator.push(context, MaterialPageRoute(builder: (context)=> StakingDetails(index: i, currencyNetwork: widget.controller.search ? widget.controller.filterListStaking : widget.controller.stakingHistorylength)));
                          },
                          child: TradeBitContainer(
                            width: MediaQuery.sizeOf(context).width,
                            margin: EdgeInsets.only(left: Dimensions.w_6,right: Dimensions.w_6),
                            padding:  EdgeInsets.only(top: Dimensions.h_10,bottom: Dimensions.h_10,left: Dimensions.h_15,right: Dimensions.h_15),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(30),
                                  child: SizedBox(
                                      height: Dimensions.h_25,
                                      width: Dimensions.h_25,
                                      child: TradebitCacheImage(image: widget.controller.stakingSearch ? widget.controller.image ?? '' : widget.controller.image ?? '')),
                                ),
                                HorizontalSpacing(width: Dimensions.w_5),
                                TradeBitTextWidget(title: widget.controller.stakingSearch ? widget.controller.filterListStaking[i].stakeCurrency ?? '' : widget.controller.stakingHistorylength[i].stakeCurrency.toString(), style: AppTextStyle.themeBoldNormalTextStyle(fontSize : FontSize.sp_16, color: Theme.of(context).highlightColor),),
                                const Spacer(),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    TradeBitTextWidget(title: double.parse(widget.controller.stakingSearch ? widget.controller.filterListStaking[i].amount.toString() : widget.controller.stakingHistorylength[i].amount.toString()).toStringAsFixed(8), style: AppTextStyle.normalTextStyle(FontSize.sp_15, Theme.of(context).highlightColor)),
                                    TradeBitTextWidget(title: double.parse(widget.controller.stakingSearch ? widget.controller.filterListStaking[i].roiIncome.toString() : widget.controller.stakingHistorylength[i].roiIncome.toString()).toStringAsFixed(8), style: AppTextStyle.normalTextStyle(FontSize.sp_12, AppColor.green)),
                                  ],
                                ),
                                HorizontalSpacing(width: Dimensions.w_20),
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


// class StakingDetails extends StatefulWidget {
//   final int index;
//   final List<PairDatum> currencyNetwork;
//   const StakingDetails({super.key, required this.index, required this.currencyNetwork});
//
//   @override
//   State<StakingDetails> createState() => _StakingDetailsState();
// }
//
// class _StakingDetailsState extends State<StakingDetails> {
//
//   @override
//   Widget build(BuildContext context) {
//     return  TradeBitContainer(
//       decoration: BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor),
//       child: SafeArea(
//         child: TradeBitScaffold(
//             appBar: PreferredSize(preferredSize: Size.fromHeight(Dimensions.h_55), child: TradeBitAppBar(title: '',onTap: ()=> Navigator.pop(context))),
//             body:  Padding(
//               padding:  EdgeInsets.only(left: Dimensions.w_20,right: Dimensions.w_20),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   VerticalSpacing(height: Dimensions.h_10),
//                   Row(
//                     children: [
//                       SizedBox(
//                           height: Dimensions.h_30,
//                           width: Dimensions.h_30,
//                           child: TradebitCacheImage(image: widget.currencyNetwork[widget.index].stakeCurrencyImage ?? '')),
//                       HorizontalSpacing(width: Dimensions.w_10),
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           TradeBitTextWidget(title: widget.currencyNetwork[widget.index].stakeCurrency ?? '', style: AppTextStyle.themeBoldNormalTextStyle(fontSize: FontSize.sp_26,color: Theme.of(context).highlightColor)),
//                           VerticalSpacing(height: Dimensions.h_2),
//                         ],
//                       ),
//                     ],
//                   ),
//                   VerticalSpacing(height: Dimensions.h_30),
//                   TradeBitTextWidget(title: 'Total (USDT)', style: AppTextStyle.themeBoldNormalTextStyle(fontSize: FontSize.sp_14,color: Theme.of(context).highlightColor)),
//                   VerticalSpacing(height: Dimensions.h_5),
//                   TradeBitTextWidget(title: totalQty?.toStringAsFixed(8) ?? '', style: AppTextStyle.themeBoldNormalTextStyle(fontSize: FontSize.sp_26,color: Theme.of(context).highlightColor)),
//                   TradeBitTextWidget(title: '\$ ${total?.toStringAsFixed(3)}', style: AppTextStyle.themeBoldNormalTextStyle(fontSize: FontSize.sp_14,color: Theme.of(context).shadowColor)),
//                   VerticalSpacing(height: Dimensions.h_25),
//                   Row(
//                     children: [
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           TradeBitTextWidget(title: 'Available', style: AppTextStyle.themeBoldNormalTextStyle(fontSize: FontSize.sp_15,color: Theme.of(context).highlightColor)),
//                           VerticalSpacing(height: Dimensions.h_2),
//                           TradeBitTextWidget(title: double.parse(widget.currencyNetwork[widget.index].quantity ?? '').toStringAsFixed(8), style: AppTextStyle.themeBoldNormalTextStyle(fontSize: FontSize.sp_14,color: Theme.of(context).highlightColor)),
//                           VerticalSpacing(height: Dimensions.h_5),
//                           TradeBitTextWidget(title: '\$${double.parse(widget.currencyNetwork[widget.index].cBal ?? '').toStringAsFixed(3)}', style: AppTextStyle.themeBoldNormalTextStyle(fontSize: FontSize.sp_14,color: Theme.of(context).shadowColor)),
//                         ],
//                       ),
//                       HorizontalSpacing(width: Dimensions.w_135),
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           TradeBitTextWidget(title: 'Frozen', style: AppTextStyle.themeBoldNormalTextStyle(fontSize: FontSize.sp_15,color: Theme.of(context).highlightColor)),
//                           VerticalSpacing(height: Dimensions.h_2),
//                           TradeBitTextWidget(title: double.parse(widget.currencyNetwork[widget.index].freezedBalance ?? '').toStringAsFixed(8), style: AppTextStyle.themeBoldNormalTextStyle(fontSize: FontSize.sp_14,color: Theme.of(context).highlightColor)),
//                           VerticalSpacing(height: Dimensions.h_5),
//                           TradeBitTextWidget(title: '\$${double.parse(widget.currencyNetwork[widget.index].fcBal ?? '').toStringAsFixed(3)}', style: AppTextStyle.themeBoldNormalTextStyle(fontSize: FontSize.sp_14,color: Theme.of(context).shadowColor)),
//                         ],
//                       ),
//                     ],
//                   ),
//                   GestureDetector(
//                     onTap: ()=> Navigator.pushReplacement(context, MaterialPageRoute(builder: (c)=> DashBoard(index: 2))),
//                     child: TradeBitContainer(
//                       margin: EdgeInsets.only(top: Dimensions.h_45),
//                       padding: const EdgeInsets.all(12),
//                       decoration: BoxDecoration(
//                         color: Theme.of(context).cardColor,
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               TradeBitTextWidget(title: 'Buy & Sell Crypto', style: AppTextStyle.themeBoldNormalTextStyle(
//                                   fontSize: FontSize.sp_18,
//                                   color: Theme.of(context).highlightColor
//                               )),
//                               VerticalSpacing(height: Dimensions.h_2),
//                               TradeBitTextWidget(title: 'Visa/MasterCard/Apple Pay/Bank Transfer', style: AppTextStyle.themeBoldNormalTextStyle(
//                                   fontSize: FontSize.sp_13,
//                                   color: Theme.of(context).shadowColor
//                               ))
//                             ],
//                           ),
//                           Icon(Icons.arrow_forward_ios,color: Theme.of(context).highlightColor,size: 12)
//                         ],
//                       ),
//                     ),
//                   ),
//                   GestureDetector(
//                     onTap: ()=> Navigator.pushReplacement(context, MaterialPageRoute(builder: (c)=> DashBoard(index: 4))),
//                     child: TradeBitContainer(
//                       margin: EdgeInsets.only(top: Dimensions.h_10),
//                       padding: const EdgeInsets.all(12),
//                       decoration: BoxDecoration(
//                         color: Theme.of(context).cardColor,
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               TradeBitTextWidget(title: 'Stake & Earn', style: AppTextStyle.themeBoldNormalTextStyle(
//                                   fontSize: FontSize.sp_18,
//                                   color: Theme.of(context).highlightColor
//                               )),
//                               VerticalSpacing(height: Dimensions.h_2),
//                               TradeBitTextWidget(title: 'Earn safely & conveniently', style: AppTextStyle.themeBoldNormalTextStyle(
//                                   fontSize: FontSize.sp_13,
//                                   color: Theme.of(context).shadowColor
//                               ))
//                             ],
//                           ),
//                           Icon(Icons.arrow_forward_ios,color: Theme.of(context).highlightColor,size: 12,)
//                         ],
//                       ),
//                     ),
//                   )
//                 ],
//               ),
//             )),
//       ),
//     );
//   }
// }

