import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tradebit_app/Presentation/exchange/exhange_controller.dart';
import 'package:tradebit_app/constants/appcolor.dart';
import 'package:tradebit_app/constants/apptextstyle.dart';
import 'package:tradebit_app/constants/constants.dart';
import 'package:tradebit_app/constants/fontsize.dart';
import 'package:tradebit_app/data/datasource/local/local_storage.dart';
import 'package:tradebit_app/widgets/extensions.dart';
import 'package:tradebit_app/widgets/spacing.dart';
import 'package:tradebit_app/widgets/trade_bit_container.dart';
import 'package:tradebit_app/widgets/tradebit_text.dart';
import'package:shimmer/shimmer.dart';

class OrderHistory extends StatefulWidget {
  final ExchangeController controller;
  const OrderHistory({super.key,required this.controller});

  @override
  State<OrderHistory> createState() => _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistory> {
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
    return (widget.controller.shimmer) ? Shimmer.fromColors(
        baseColor: Theme.of(context).cardColor,
        highlightColor: Theme.of(context).scaffoldBackgroundColor,
        child: ListView.builder(
            itemCount: 4,
            itemBuilder: (c,i) {
              return Padding(
                padding:  EdgeInsets.symmetric(horizontal: Dimensions.w_10,
                    vertical: Dimensions.h_8),
                child: Row(
                  children: [
                    TradeBitContainer(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).cardColor,
                      ),
                      width: Dimensions.h_20,
                      height: Dimensions.h_20,
                    ),
                    HorizontalSpacing(width: Dimensions.w_10),
                    Expanded(
                      child: TradeBitContainer(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(Dimensions.h_4),
                          color: Theme.of(context).cardColor,
                        ),
                        height: Dimensions.h_20,
                      ),
                    ),
                  ],
                ),
              );
            })
    )
        :  (widget.controller.orderHistoryList?.isNotEmpty ?? false ) ?
    Stack(
      children: [
        ListView.separated(
          controller: scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.only(top: Dimensions.h_8),
          itemCount: widget.controller.orderHistoryList?.length ?? 0 + 1,
          itemBuilder: (c,i) {
              String getTime( DateTime date) {
                final dateTime = date.toLocal().toDateString(DateFormats.hhmma) ?? '';
                return dateTime;
              }
              String getDate( DateTime date) {
                final dateTime = date.toLocal().toDateString(DateFormats.ddMMMyyyy) ?? '';
                return dateTime;
              }
              return  TradeBitContainer(
                padding: EdgeInsets.only(top: Dimensions.h_5,bottom: Dimensions.h_2,left: Dimensions.w_10,right: Dimensions.w_10),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                ),
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
                                    TradeBitTextWidget(title: widget.controller.orderHistoryList?[i].currency ?? '', style: AppTextStyle.themeBoldNormalTextStyle(
                                        fontSize: FontSize.sp_13,
                                        color: Theme.of(context).highlightColor
                                    )),
                                    HorizontalSpacing(width: Dimensions.w_10),
                                    TradeBitContainer(
                                      padding: EdgeInsets.symmetric(vertical: Dimensions.h_2,horizontal: Dimensions.w_8),
                                      decoration:  BoxDecoration(
                                          color: AppColor.appColor.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(Dimensions.h_4),
                                          border: Border.all(
                                              width: 0.5,
                                              color: AppColor.appColor
                                          )
                                      ),
                                      child: TradeBitTextWidget(title: widget.controller.orderHistoryList?[i].type ?? '' , style: AppTextStyle.normalTextStyle(
                                          FontSize.sp_11, Theme.of(context).highlightColor
                                      )),
                                    ),
                                    HorizontalSpacing(width: Dimensions.w_10),
                                    TradeBitContainer(
                                      padding: EdgeInsets.symmetric(vertical: Dimensions.h_2,horizontal: Dimensions.w_8),
                                      decoration:  BoxDecoration(
                                          borderRadius: BorderRadius.circular(Dimensions.h_4),
                                          border: Border.all(
                                              width: 0.5,
                                              color: widget.controller.orderHistoryList?[i].orderType == 'buy' ? AppColor.green : AppColor.redButton
                                          )
                                      ),
                                      child: TradeBitTextWidget(title: widget.controller.orderHistoryList?[i].orderType?.toUpperCase() ?? '' , style: AppTextStyle.normalTextStyle(
                                          FontSize.sp_11, widget.controller.orderHistoryList?[i].orderType == 'buy' ? AppColor.green : AppColor.redButton
                                      )),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            VerticalSpacing(height: Dimensions.h_6),
                            Row(
                              children: [
                                TradeBitTextWidget(title:  'Price:', style: AppTextStyle.themeBoldNormalTextStyle(
                                    fontSize: FontSize.sp_12,
                                    color: Theme.of(context).shadowColor
                                )),
                                HorizontalSpacing(width: Dimensions.w_5),
                                TradeBitTextWidget(title: double.parse(widget.controller.orderHistoryList?[i].atPrice ?? '0.0').toStringAsFixed(4) , style: AppTextStyle.themeBoldTextStyle(
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
                            TradeBitTextWidget(title:  "${getDate(widget.controller.orderHistoryList?[i].updatedAt ?? DateTime(10))} ${getTime(widget.controller.orderHistoryList?[i].updatedAt ?? DateTime(10))}", style: AppTextStyle.themeBoldNormalTextStyle(
                                fontSize: FontSize.sp_13,
                                color: Theme.of(context).shadowColor
                            )),
                            VerticalSpacing(height: Dimensions.h_6),
                            Row(
                              children: [
                                TradeBitTextWidget(title:  'Qty:', style: AppTextStyle.themeBoldNormalTextStyle(
                                    fontSize: FontSize.sp_13,
                                    color: Theme.of(context).shadowColor
                                )),
                                HorizontalSpacing(width: Dimensions.w_5),
                                TradeBitTextWidget(title: double.parse(widget.controller.orderHistoryList?[i].quantity ?? '0.0').toStringAsFixed(4) , style: AppTextStyle.themeBoldNormalTextStyle(
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
                  ],
                ),
              );
            } , separatorBuilder: (BuildContext context, int index) {
            return const Divider();
        },),
        Positioned(
          top: Dimensions.h_70,
            left: MediaQuery.sizeOf(context).width/ 2.2,
            child: widget.controller.loadMoreData ? const CupertinoActivityIndicator(color: AppColor.appColor) : const SizedBox.shrink())

      ],
    ) : Center(
      child: Padding(
        padding:  EdgeInsets.only(top: Dimensions.h_50),
        child: TradeBitTextWidget(title:  LocalStorage.getBool(GetXStorageConstants.userLogin) == true ? "Please Login first" : "No Data Found", style: AppTextStyle.themeBoldNormalTextStyle(
            fontSize: FontSize.sp_16,color: Theme.of(context).highlightColor
        )),
      ),
    );
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}
