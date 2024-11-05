import 'dart:convert';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:intl/intl.dart';
import 'package:supercharged/supercharged.dart';
import 'package:tradebit_app/Presentation/Market/market.dart';
import 'package:tradebit_app/Presentation/exchange/exhange_controller.dart';
import 'package:tradebit_app/constants/appcolor.dart';
import 'package:tradebit_app/constants/apptextstyle.dart';
import 'package:tradebit_app/constants/constants.dart';
import 'package:tradebit_app/constants/fontsize.dart';
import 'package:tradebit_app/data/datasource/local/local_storage.dart';
import 'package:tradebit_app/widgets/common_app_bar.dart';
import 'package:tradebit_app/widgets/lib/chart_style.dart';
import 'package:tradebit_app/widgets/lib/k_chart_widget.dart';
import 'package:tradebit_app/widgets/lib/renderer/main_renderer.dart';
import 'package:tradebit_app/widgets/spacing.dart';
import 'package:tradebit_app/widgets/tradeBit_scaffold.dart';
import 'package:tradebit_app/widgets/trade_bit_container.dart';
import 'package:tradebit_app/widgets/tradebit_text.dart';

class ChartScreen extends StatelessWidget {
  final ExchangeController exchangeController;
  const ChartScreen({super.key,required this.exchangeController});

  @override
  Widget build(BuildContext context) {
    return  TradeBitContainer(
        decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor
        ),
        child: SafeArea(
            child: GetBuilder(
              init: exchangeController,
              id: ControllerBuilders.exchangeController,
              builder: (controller) {
                return TradeBitScaffold(
                  appBar: PreferredSize(preferredSize: Size.fromHeight(Dimensions.h_50), child:  TradeBitAppBar(title: LocalStorage.getBool(GetXStorageConstants.firstTime) == true ? 'BTCUSDT' : LocalStorage.getString(GetXStorageConstants.symbol), onTap: (){
                    Navigator.pop(context);
                  } )),
                  body: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: Dimensions.w_8,right: Dimensions.w_10),
                          child: StreamBuilder(
                            stream: controller.streamControllerMarket.stream,
                            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                              if(snapshot.connectionState == ConnectionState.active && snapshot.hasData && snapshot.data.toString().contains('e')) {
                                final data = openOrderResponseFromJson(snapshot.data);
                                final data2 = listedResponseFromJson(snapshot.data);
                                controller.change = double.parse(LocalStorage.getBool(GetXStorageConstants.listed) == true ? data2.c ?? '0.0' :data.openOrderResponseC ?? '0.0');
                                controller.change24 = double.parse(LocalStorage.getBool(GetXStorageConstants.listed) == true ? data2.c ?? '0.0' : data.openOrderResponseB ?? '0.0');
                                controller.high = double.parse(LocalStorage.getBool(GetXStorageConstants.listed) == true ? data2.h ?? '0.0' : data.h ?? '0.0');
                                controller.low = double.parse(LocalStorage.getBool(GetXStorageConstants.listed) == true ? data2.l ?? '0.0' : data.openOrderResponseL ?? '0.0');
                                controller.qty = LocalStorage.getBool(GetXStorageConstants.listed) == true ? data2.q ?? '0.0'   : data.q ?? 0.0 ;
                                controller.vol =  LocalStorage.getBool(GetXStorageConstants.listed) == true ? data2.v ?? "0.0" : data.v ?? 0.0;
                                return  Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        TradeBitTextWidget(title: controller.change?.toStringAsFixed(4) ?? '0.0', style: AppTextStyle.themeBoldNormalTextStyle(
                                            fontSize: FontSize.sp_24,
                                            color: AppColor.green
                                        )),
                                        TradeBitTextWidget(title: "\$ ${controller.change?.toStringAsFixed(4) ?? '0.0'}", style: AppTextStyle.themeBoldNormalTextStyle(
                                            fontSize: FontSize.sp_13,
                                            color: Theme.of(context).highlightColor
                                        )),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            TradeBitTextWidget(title: 'Vol', style: AppTextStyle.normalTextStyle(FontSize.sp_12, Theme.of(context).shadowColor)),
                                            TradeBitTextWidget(title: controller.vol == null ? '0.0': double.parse(controller.vol.toString()).toStringAsFixed(4) , style: AppTextStyle.themeBoldNormalTextStyle(
                                                fontSize: FontSize.sp_12,
                                                color: Theme.of(context).highlightColor
                                            )),
                                            VerticalSpacing(height: Dimensions.h_8),
                                            TradeBitTextWidget(title: 'Low', style: AppTextStyle.normalTextStyle(FontSize.sp_12, Theme.of(context).shadowColor)),
                                            TradeBitTextWidget(title: controller.low?.toStringAsFixed(4) ?? '- -', style: AppTextStyle.themeBoldNormalTextStyle(
                                                fontSize: FontSize.sp_12,
                                                color: AppColor.redButton
                                            )),
                                          ],
                                        ),
                                        HorizontalSpacing(width: Dimensions.w_30),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            TradeBitTextWidget(title: 'Qty', style: AppTextStyle.normalTextStyle(FontSize.sp_12, Theme.of(context).shadowColor)),
                                            TradeBitTextWidget(title: double.parse(controller.qty.toString()).toStringAsFixed(4), style: AppTextStyle.themeBoldNormalTextStyle(
                                                fontSize: FontSize.sp_12,
                                                color: Theme.of(context).highlightColor
                                            )),
                                            VerticalSpacing(height: Dimensions.h_8),
                                            TradeBitTextWidget(title: 'High', style: AppTextStyle.normalTextStyle(FontSize.sp_12, Theme.of(context).shadowColor)),
                                            TradeBitTextWidget(title: controller.high?.toStringAsFixed(4) ?? '- -', style: AppTextStyle.themeBoldNormalTextStyle(
                                                fontSize: FontSize.sp_12,
                                                color: AppColor.green
                                            )),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              }
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      TradeBitTextWidget(title: LocalStorage.getString(GetXStorageConstants.price), style: AppTextStyle.themeBoldNormalTextStyle(
                                          fontSize: FontSize.sp_24,
                                          color: AppColor.redButton
                                      )),
                                      TradeBitTextWidget(title: LocalStorage.getString(GetXStorageConstants.price), style: AppTextStyle.themeBoldNormalTextStyle(
                                          fontSize: FontSize.sp_14,
                                          color: Theme.of(context).highlightColor
                                      )),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          TradeBitTextWidget(title: 'Vol', style: AppTextStyle.normalTextStyle(FontSize.sp_12, Theme.of(context).shadowColor)),
                                          TradeBitTextWidget(title: controller.vol == null ? '0.0': controller.vol.toString(), style: AppTextStyle.themeBoldNormalTextStyle(
                                              fontSize: FontSize.sp_12,
                                              color: Theme.of(context).highlightColor
                                          )),
                                          VerticalSpacing(height: Dimensions.h_8),
                                          TradeBitTextWidget(title: 'Low', style: AppTextStyle.normalTextStyle(FontSize.sp_12, Theme.of(context).shadowColor)),
                                          TradeBitTextWidget(title: controller.low?.toStringAsFixed(4) ?? '- -', style: AppTextStyle.themeBoldNormalTextStyle(
                                              fontSize: FontSize.sp_12,
                                              color: Theme.of(context).highlightColor
                                          )),
                                        ],
                                      ),
                                      HorizontalSpacing(width: Dimensions.w_30),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          TradeBitTextWidget(title: 'Qty', style: AppTextStyle.normalTextStyle(FontSize.sp_12, Theme.of(context).shadowColor)),
                                          TradeBitTextWidget(title: controller.qty.toString() ?? '- -', style: AppTextStyle.themeBoldNormalTextStyle(
                                              fontSize: FontSize.sp_12,
                                              color: Theme.of(context).highlightColor
                                          )),
                                          VerticalSpacing(height: Dimensions.h_8),
                                          TradeBitTextWidget(title: 'High', style: AppTextStyle.normalTextStyle(FontSize.sp_12, Theme.of(context).shadowColor)),
                                          TradeBitTextWidget(title: controller.high?.toStringAsFixed(4) ?? '- -', style: AppTextStyle.themeBoldNormalTextStyle(
                                              fontSize: FontSize.sp_12,
                                              color: Theme.of(context).highlightColor
                                          )),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            },

                          ),
                        ),
                        VerticalSpacing(height: Dimensions.h_8),
                        GetBuilder(
                          init: exchangeController,
                          id: ControllerBuilders.button,
                          builder: (controller) {
                            return TradeBitContainer(
                              decoration: BoxDecoration(
                                  color: Theme.of(context).scaffoldBackgroundColor
                              ),
                              child: Column(
                                children: [
                                  VerticalSpacing(height: Dimensions.h_5),
                                  SizedBox(
                                    height: Dimensions.h_25,
                                    child: Row(
                                      children: [
                                        HorizontalSpacing(width: Dimensions.w_10),
                                        GestureDetector(
                                          behavior: HitTestBehavior.opaque,
                                          onTap: ()  {
                                            controller.getLine();
                                          },
                                          child: TradeBitContainer(
                                            decoration: const BoxDecoration(),
                                            child: Center(
                                              child: Padding(
                                                padding:  const EdgeInsets.all(3),
                                                child: Text(
                                                  'Line',
                                                  style: AppTextStyle.themeBoldNormalTextStyle(
                                                      fontSize: FontSize.sp_13,
                                                      color: controller.isLine ? AppColor.appColor : Theme.of(context).highlightColor
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        ListView.builder(
                                            padding: EdgeInsets.zero,
                                            shrinkWrap: true,
                                            physics: const NeverScrollableScrollPhysics(),
                                            scrollDirection: Axis.horizontal,
                                            itemCount: controller.buttonsList.length,
                                            itemBuilder: (c,i) {
                                              return Padding(
                                                padding:  EdgeInsets.only(left: Dimensions.w_15,right: Dimensions.w_15),
                                                child: GestureDetector(
                                                  onTap: ()  {
                                                    controller.onIndex(i);
                                                    controller.onInterval(controller.buttonsList[i].title, controller.buttonsList[i].time);
                                                  },
                                                  child: TradeBitContainer(
                                                    decoration: const BoxDecoration(),
                                                    child: Center(
                                                      child: Padding(
                                                        padding: controller.currentIndex == i ? const EdgeInsets.only(top: 0,bottom: 0,right: 8,left: 8): const EdgeInsets.all(3),
                                                        child: Text(
                                                          controller.buttonsList[i].title,
                                                          style: AppTextStyle.themeBoldNormalTextStyle(
                                                              fontSize: FontSize.sp_15,
                                                              color: controller.currentIndex == i ? AppColor.appColor : Theme.of(context).highlightColor
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              );}),
                                      ],
                                    ),
                                  ),
                                  Divider(
                                    color: Theme.of(context).shadowColor.withOpacity(0.2),
                                  ),
                                  SizedBox(
                                      height: Dimensions.h_280,
                                      child: controller.owndata.isEmpty ?? false ?
                                      Center(
                                        child: TradeBitTextWidget(title: "No data Found", style: AppTextStyle.themeBoldNormalTextStyle(
                                            fontSize: FontSize.sp_16,
                                            color: Theme.of(context).highlightColor
                                        )),
                                      ): StreamBuilder(
                                        stream: controller.streamControllerChart.stream,
                                        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                                          if(snapshot.connectionState == ConnectionState.active && snapshot.hasData && snapshot.data.toString().contains('k') ) {
                                            controller.updateCandlesFromSnapshot(snapshot);
                                            return AbsorbPointer(
                                              absorbing: controller.chartLoading,
                                              child: Stack(
                                                children: [
                                                  KChartWidget(
                                                    mBaseHeight: Dimensions.h_280,
                                                    showNowPrice: true,
                                                    controller.owndata, ChartStyle(), ChartColors(
                                                    bgColor: Theme.of(context).scaffoldBackgroundColor,
                                                    defaultTextColor: Theme.of(context).shadowColor,
                                                    gridColor: Theme.of(context).shadowColor.withOpacity(0.3),

                                                  ), isTrendLine: false,
                                                    isLine: controller.isLine,
                                                    volHidden: false,
                                                    mainState: MainState.MA,
                                                    timeFormat: TimeFormat.YEAR_MONTH_DAY_WITH_HOUR,
                                                    verticalTextAlignment: VerticalTextAlignment.right,
                                                  ),
                                                  controller.chartLoading ? Center(
                                                    child: CupertinoActivityIndicator(
                                                      color: AppColor.appColor,
                                                      radius: Dimensions.h_10,
                                                    ),
                                                  ) : const SizedBox.shrink()
                                                ],
                                              ),
                                            );
                                          }
                                          return  Stack(
                                            children: [
                                              KChartWidget(
                                                mBaseHeight: Dimensions.h_280,
                                                showNowPrice: true,
                                                controller.owndata, ChartStyle(), ChartColors(
                                                bgColor: Theme.of(context).cardColor,
                                                defaultTextColor: Theme.of(context).shadowColor,
                                                gridColor: Theme.of(context).shadowColor.withOpacity(0.3),
                                              ),
                                                isLine: controller.isLine,
                                                volHidden: false,
                                                mainState: MainState.MA,
                                                timeFormat: TimeFormat.YEAR_MONTH_DAY_WITH_HOUR,
                                                verticalTextAlignment: VerticalTextAlignment.right,
                                                isTrendLine: false,
                                              ),
                                              controller.chartLoading ? Center(
                                                child: CupertinoActivityIndicator(
                                                  color: AppColor.appColor,
                                                  radius: Dimensions.h_10,
                                                ),
                                              ) : const SizedBox.shrink()
                                            ],
                                          );
                                        },

                                      )
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        VerticalSpacing(height: Dimensions.h_20),
                        Row(
                          children: [
                            GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () {
                                controller.showMarket();
                              },
                              child: Padding(
                                padding:  EdgeInsets.only(left: Dimensions.w_12),
                                child: TradeBitTextWidget(
                                    title: 'Market Trades',
                                    style: AppTextStyle.themeBoldNormalTextStyle(
                                        fontSize: FontSize.sp_15,
                                        color:controller.showTrades ? AppColor.appColor : Theme.of(context).highlightColor)),),
                            ),
                            // GestureDetector(
                            //   behavior: HitTestBehavior.opaque,
                            //   onTap: () {
                            //     controller.showOrder();
                            //   },
                            //   child: Padding(
                            //     padding:  EdgeInsets.only(left: Dimensions.w_8),
                            //     child: TradeBitTextWidget(
                            //         title: 'Order Book',
                            //         style: AppTextStyle.themeBoldNormalTextStyle(
                            //             fontSize: FontSize.sp_15,
                            //             color: controller.orderBook ? AppColor.appColor : Theme.of(context).highlightColor)),),
                            // ),

                          ],
                        ),
                        VerticalSpacing(height: Dimensions.h_5),
                        Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: Dimensions.w_15, top: Dimensions.h_10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      TradeBitTextWidget(
                                          title: 'Price',
                                          style: AppTextStyle.themeBoldNormalTextStyle(
                                              fontSize: FontSize.sp_14,
                                              color: Theme.of(context).highlightColor)),
                                      HorizontalSpacing(width: Dimensions.w_2),
                                      TradeBitTextWidget(
                                          title: "(${LocalStorage.getBool(GetXStorageConstants.firstTime) == true ? 'USDT' : LocalStorage.getString(GetXStorageConstants.pair).toUpperCase()})",
                                          style: AppTextStyle.themeBoldNormalTextStyle(
                                              fontSize: FontSize.sp_14,
                                              color: Theme.of(context).highlightColor)),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      TradeBitTextWidget(
                                          title: 'Volume',
                                          style: AppTextStyle.themeBoldNormalTextStyle(
                                              fontSize: FontSize.sp_14,
                                              color: Theme.of(context).highlightColor)),
                                      HorizontalSpacing(width: Dimensions.w_2),
                                      TradeBitTextWidget(
                                          title: "(${LocalStorage.getBool(GetXStorageConstants.firstTime) == true ? 'BTC' : LocalStorage.getString(GetXStorageConstants.name).toUpperCase()})",
                                          style: AppTextStyle.themeBoldNormalTextStyle(
                                              fontSize: FontSize.sp_14,
                                              color: Theme.of(context).highlightColor)),
                                    ],
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(right: Dimensions.w_10),
                                    child: TradeBitTextWidget(
                                        title: 'Time',
                                        style: AppTextStyle.themeBoldNormalTextStyle(
                                            fontSize: FontSize.sp_14,
                                            color: Theme.of(context).highlightColor)),
                                  ),
                                ],
                              ),
                            ),
                            Divider(color: Theme.of(context).shadowColor.withOpacity(0.8)),
                            SizedBox(
                              height: Dimensions.h_316,
                              child: StreamBuilder(
                                  stream: controller.streamControllerTrade.stream,
                                  builder: (context, AsyncSnapshot<dynamic> snapshot) {
                                    if(snapshot.connectionState == ConnectionState.active && snapshot.hasData && snapshot.data.toString().contains('e') ) {
                                      final data = jsonDecode(snapshot.data as String) as Map<String, dynamic>;
                                      if((data["p"].toString().isNotEmpty && data["p"]!=null)) {
                                        controller.trades.add(MarketTrade(
                                            price:  data["p"].toString(),
                                            quantity:  data["q"].toString(),
                                            date:  data["T"].toString(),
                                            type: data['m'] ?? false));

                                      }
                                      if(controller.trades.length > 10) {
                                        controller.trades.removeAt(0);
                                      }
                                      return ListView.builder(
                                        padding: const EdgeInsets.only(left: 8),
                                        itemCount: controller.trades.length,
                                        physics: const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        reverse: true,
                                        itemBuilder: (BuildContext context, int index) {
                                          int? epochTimeInSeconds = controller.trades[index].date?.toInt();
                                          DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(epochTimeInSeconds ?? 0);
                                          String formattedTime = DateFormat('HH:mm:ss').format(dateTime);
                                          return Padding(
                                            padding:  EdgeInsets.only(top:Dimensions.h_8,bottom: Dimensions.h_5),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                TradeBitTextWidget(title: double.parse(controller.trades[index].price ?? '0.0').toStringAsFixed(4), style: AppTextStyle.themeBoldNormalTextStyle(fontSize:FontSize.sp_14, color: controller.trades[index].type == true ?  AppColor.green :AppColor.redButton)),
                                                TradeBitTextWidget(title: double.parse(controller.trades[index].quantity ?? '0.0').toStringAsFixed(4), style: AppTextStyle.themeBoldNormalTextStyle(fontSize:FontSize.sp_14, color: controller.trades[index].type == true ?  AppColor.green :AppColor.redButton)),
                                                Padding(
                                                  padding:  EdgeInsets.only(right: Dimensions.w_8),
                                                  child: TradeBitTextWidget(title: formattedTime.toString(), style: AppTextStyle.themeBoldNormalTextStyle(fontSize:FontSize.sp_14, color: controller.trades[index].type == true ?  AppColor.green :AppColor.redButton)),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      );
                                    }
                                    return ListView.builder(
                                      padding: const EdgeInsets.only(left: 8),
                                      itemCount: controller.trades.length,
                                      shrinkWrap: true,
                                      itemBuilder: (BuildContext context, int index) {
                                        int? epochTimeInSeconds = controller.trades[index].date?.toInt();
                                        DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(epochTimeInSeconds ?? 0);
                                        String formattedTime = DateFormat('HH:mm:ss').format(dateTime);
                                        return Padding(
                                          padding: EdgeInsets.only(top:Dimensions.h_8,bottom: Dimensions.h_5),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              TradeBitTextWidget(title: double.parse(controller.trades[index].price ?? '0.0').toStringAsFixed(4), style: AppTextStyle.themeBoldNormalTextStyle(fontSize:FontSize.sp_14, color: controller.trades[index].type == true ?  AppColor.green :AppColor.redButton)),
                                              TradeBitTextWidget(title: double.parse(controller.trades[index].quantity ?? '0.0').toStringAsFixed(4), style: AppTextStyle.themeBoldNormalTextStyle(fontSize:FontSize.sp_14, color: controller.trades[index].type == true ?  AppColor.green :AppColor.redButton)),
                                              Padding(
                                                padding: EdgeInsets.only(right: Dimensions.w_8),
                                                child: TradeBitTextWidget(title: formattedTime.toString(), style: AppTextStyle.themeBoldNormalTextStyle(fontSize:FontSize.sp_14, color: controller.trades[index].type == true ?  AppColor.green :AppColor.redButton)),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  }),
                            ),
                          ],
                        ) ,
                        //    : SizedBox(
                        //  height: Dimensions.h_200,
                        //   child: StreamBuilder(stream: controller.streamControllerBids.stream,
                        //   builder: (BuildContext context,  snapshot) {
                        //     log(snapshot.data.toString());
                        //     if (snapshot.connectionState == ConnectionState.active && snapshot.data.toString().contains("lastUpdateId")) {
                        //       var data = json.decode(snapshot.hasData ? snapshot.data.toString() : '');
                        //       if(data.length> 0) {
                        //         var bids = data['bids'];
                        //         var asks = data['asks'];
                        //         controller.bidss?.clear();
                        //         controller.askss?.clear();
                        //         double amount = 0.0;
                        //         bids.sort((left, right) => left.price.compareTo(right.price));
                        //         bids.reversed.forEach((item) {
                        //           amount += item.vol;
                        //           item.vol = amount;
                        //           controller.bidss?.insert(0, item);
                        //         });
                        //
                        //         amount = 0.0;
                        //         asks?.sort((left, right) => left.price.compareTo(right.price));
                        //         asks?.forEach((item) {
                        //           amount += item.vol;
                        //           item.vol = amount;
                        //           asks.add(item);
                        //         });
                        //
                        //         controller.bidss?.clear();
                        //         controller.askss?.clear();
                        //         for (int i = 0; i < data['bids'].length; i++) {
                        //           controller.bidss?.add( DepthEntity(double.parse(data['bids'][i][0]), double.parse(data['bids'][i][1])));
                        //         }
                        //         for (int i = 0; i < data['asks'].length; i++) {
                        //           controller.askss?.add( DepthEntity(double.parse(data['asks'][i][0]), double.parse(data['asks'][i][1])));
                        //         }
                        //
                        //       }
                        //      return DepthChart(controller.bidss ?? [], controller.askss?? [], ChartColors());
                        //     }
                        //
                        //     return  DepthChart(controller.bidss ?? [], controller.askss?? [], ChartColors());
                        //   },
                        //                                   ),
                        // ),
                        VerticalSpacing(height: Dimensions.h_10)],
                    ),
                  ),
                );
              },
            )));
  }
}

class IntervalButton  {
  final String title;
  final int time;

  IntervalButton({required this.title, required this.time});
}


ListedResponse listedResponseFromJson(String str) => ListedResponse.fromJson(json.decode(str));

String listedResponseToJson(ListedResponse data) => json.encode(data.toJson());

class ListedResponse {
  final String? s;
  final String? c;
  final String? p;
  final String? h;
  final String? l;
  final dynamic v;
  final dynamic q;
  final String? e;

  ListedResponse({
    this.s,
    this.c,
    this.p,
    this.h,
    this.l,
    this.v,
    this.q,
    this.e,
  });

  factory ListedResponse.fromJson(Map<String, dynamic> json) => ListedResponse(
    s: json["s"],
    c: json["c"],
    p: json["P"],
    h: json["h"],
    l: json["l"],
    v: json["v"],
    q: json["q"],
    e: json["e"],
  );

  Map<String, dynamic> toJson() => {
    "s": s,
    "c": c,
    "P": p,
    "h": h,
    "l": l,
    "v": v,
    "q": q,
    "e": e,
  };
}
