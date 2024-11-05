import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tradebit_app/Presentation/exchange/exchange.dart';
import 'package:tradebit_app/Presentation/exchange/exhange_controller.dart';
import 'package:tradebit_app/constants/appcolor.dart';
import 'package:tradebit_app/constants/apptextstyle.dart';
import 'package:tradebit_app/constants/constants.dart';
import 'package:tradebit_app/constants/fontsize.dart';
import 'package:tradebit_app/constants/images.dart';
import 'package:tradebit_app/data/datasource/local/local_storage.dart';
import 'package:tradebit_app/widgets/spacing.dart';
import 'package:tradebit_app/widgets/trade_bit_container.dart';
import 'package:tradebit_app/widgets/tradebit_text.dart';

class AskAndBids extends StatelessWidget {
  final ExchangeController exchangeController;
   AskAndBids({super.key,required this.exchangeController});

  int firsttimeordervol = 0;

  @override
  Widget build(BuildContext context) {
    double mediaQuery = MediaQuery.of(context).size.width / 2.2;
    return GetBuilder(
      init: exchangeController,
      id: ControllerBuilders.exchangeController,
      builder: (controller) {
        return
          controller.bidLoading ?
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: Dimensions.h_135,
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  primary: false,
                  reverse: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 8,
                  itemBuilder: (BuildContext ctx, int i) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TradeBitTextWidget(
                          title : '----',
                          style: AppTextStyle.normalTextStyle(
                              FontSize.sp_12, Theme.of(context).highlightColor
                          ),
                        ),
                        TradeBitTextWidget(title:'----', style: AppTextStyle.themeBoldNormalTextStyle(
                            fontSize: FontSize.sp_12,
                            color: AppColor.redButton
                        )),

                      ],);
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: Dimensions.w_6),
                child: Row(
                  children: [
                    TradeBitTextWidget(
                      title: '----',
                      style: AppTextStyle.themeBoldNormalTextStyle(
                        fontSize: FontSize.sp_20,
                        color: AppColor.green,
                      ),
                    ),
                  ],
                ),
              ),
              VerticalSpacing(height: Dimensions.h_4),
              SizedBox(
                height: Dimensions.h_135,
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  primary: false,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount:8,
                  itemBuilder: (BuildContext ctx, int i) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TradeBitTextWidget(
                          title : '----',
                          style: AppTextStyle.normalTextStyle(
                              FontSize.sp_12, Theme.of(context).highlightColor
                          ),
                        ),
                        TradeBitTextWidget(title:'----', style: AppTextStyle.themeBoldNormalTextStyle(
                            fontSize: FontSize.sp_12,
                            color: AppColor.green
                        )),

                      ],);;
                  },
                ),
              ),
            ],
          ) :
        StreamBuilder(
            stream: controller.streamControllerBids.stream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active && snapshot.data.toString().contains("lastUpdateId")) {
                firsttimeordervol = 1;
                controller.bidLoading = true;
                var item = json.decode(snapshot.hasData ? snapshot.data.toString() : '');
                String highestBid = item['bids'][0][0];
                String lowestAsk = item['asks'].last[0];
                double newBid = (double.parse(highestBid) + double.parse(lowestAsk)) / 2;
                Color bidColor = double.parse(LocalStorage.getString(GetXStorageConstants.bidsPrice)) > newBid ? AppColor.green : AppColor.redButton;
                Icon icons = Icon(
                  double.parse(LocalStorage.getString(GetXStorageConstants.bidsPrice)) > newBid
                      ? Icons.arrow_upward_sharp
                      : Icons.arrow_downward,
                  color: bidColor,
                );
                LocalStorage.writeString(GetXStorageConstants.bidsPrice, newBid.toString());
                List<double> buys = [];
                List<double> asks = [];
                double largeValue = 0.0;

                if (item.length > 0) {
                  controller.anotherbuYlist.clear();
                  controller.othersellList.clear();
                  for (int i = 0; i < item['bids'].length; i++) {
                    controller.anotherbuYlist.add(BuyAmount(
                      price: double.parse(item['bids'][i][0].toString()).toString(),
                      value: double.parse(item['bids'][i][1].toString()).toString(),
                      number: '',
                      percent: '',
                    ));
                    controller.othersellList.add(AmountSell(
                      price: double.parse(item['asks'][i][0].toString()).toString(),
                      value: double.parse(item['asks'][i][1].toString()).toString(),
                      number: '',
                      percent: '',
                    ));

                    buys.add(double.parse(item['bids'][i][1]));
                    asks.add(double.parse(item['asks'][i][1]));
                    largeValue = buys.reduce(max) > asks.reduce(max) ? buys.reduce(max) : asks.reduce(max);
                  }
                  controller.bidLoading = false;
                }
                return Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: Dimensions.h_135,
                          width: mediaQuery,
                          child: controller.othersellList.isNotEmpty ? ListView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            primary: false,
                            reverse: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: controller.othersellList.length,
                            itemBuilder: (BuildContext ctx, int i) {
                              return _amountSell(mediaQuery, controller.othersellList[i], controller, i,context);
                            },
                          ) : const Text("--"),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: Dimensions.w_6),
                          child: Row(
                            children: [
                              TradeBitTextWidget(
                                title: newBid.toStringAsFixed(4),
                                style: AppTextStyle.themeBoldNormalTextStyle(
                                  fontSize: FontSize.sp_20,
                                  color: bidColor,
                                ),
                              ),
                             Padding(
                               padding:  EdgeInsets.only(top: Dimensions.h_3),
                               child: icons,
                             )
                            ],
                          ),
                        ),
                        VerticalSpacing(height: Dimensions.h_4),
                        SizedBox(
                          height: Dimensions.h_135,
                          width: mediaQuery,
                          child: ListView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            primary: false,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: controller.anotherbuYlist.length,
                            itemBuilder: (BuildContext ctx, int i) {
                              return _buyAmount(mediaQuery, controller.anotherbuYlist[i], controller, i,context);
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              }
              return controller.anotherbuYlist.isNotEmpty && controller.othersellList.isNotEmpty ? Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                          height: Dimensions.h_135,
                          width: mediaQuery,
                          child: ListView.builder(
                            shrinkWrap: true,
                            primary: false,
                            reverse: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: controller.othersellList.length,
                            itemBuilder: (BuildContext ctx, int i) {
                              return _amountSell(mediaQuery, controller.othersellList[i],controller,i,context);
                            },
                          )
                      ),
                      VerticalSpacing(height: Dimensions.h_5),
                      controller.loading ? const SizedBox.shrink() : Padding(
                        padding:  EdgeInsets.only(left: Dimensions.w_10),
                        child: Row(
                          children: [
                            TradeBitTextWidget(title: double.parse(controller.price ?? (LocalStorage.getBool(GetXStorageConstants.firstTime) == true ? controller.usdt.price ?? '0.0': LocalStorage.getString(GetXStorageConstants.price))).toStringAsFixed(4), style: AppTextStyle.themeBoldNormalTextStyle(
                            fontSize: FontSize.sp_20,
                            color: AppColor.green
                            )),
                            const Icon(Icons.arrow_upward_sharp,color: AppColor.green)
                          ],
                        ),
                      ),
                      SizedBox(
                          height: Dimensions.h_135,
                          width: mediaQuery,
                          child:ListView.builder(
                            shrinkWrap: true,
                            primary: false,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: controller.anotherbuYlist.length ,
                            itemBuilder: (BuildContext ctx, int i) {
                              return _buyAmount(mediaQuery, controller.anotherbuYlist[i],controller,i,context);
                            },
                          )
                      ),
                      const SizedBox(width: 5),

                    ],
                  ),
                ],
              ) : Expanded(child: Lottie.asset(Images.noDataFound));
            }
        );
      },

    );
  }

  Widget _amountSell(double width, AmountSell item,ExchangeController controller,int i,BuildContext c) {
    final Size = MediaQuery.of(c).size;
    return Stack(
      children: [
        // Align(
        //   alignment: Alignment.centerRight,
        //   child: Container(
        //     color: AppColor.redButton.withOpacity(0.2),
        //     width: width / (i / 2) + Random().nextInt(1),
        //     height: Dimensions.h_20,
        //   ),
        // ),
        Padding(
          padding:  EdgeInsets.only(right:00,bottom: 0,left:Size.width*0.022),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              controller.addPrice(item.price.toString(),item.value.toString());
              HapticFeedback.vibrate();
              print('working');
            },
            child: SizedBox(
              width: width,
              height: Dimensions.h_20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TradeBitTextWidget(
                    title : double.parse(item.value.toString()).toStringAsFixed(4),
                    style: AppTextStyle.normalTextStyle(
                        FontSize.sp_12, Theme.of(c).highlightColor
                    ),
                  ),
                  TradeBitTextWidget(title: item.price.toString(), style: AppTextStyle.themeBoldNormalTextStyle(
                      fontSize: FontSize.sp_12,
                      color: AppColor.redButton
                  )),

                ],),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buyAmount(double width, BuyAmount item,ExchangeController controller, int i,BuildContext c) {
    final Size = MediaQuery.of(c).size;
    return Stack(
      children: <Widget>[
        // Align(
        //   alignment: Alignment.centerRight,
        //   child: Container(
        //     color: AppColor.green.withOpacity(0.2),
        //     width: width  / (i/2) + Random().nextInt(1),
        //     height: Dimensions.h_20,
        //   ),
        // ),
        Padding(
          padding: EdgeInsets.only(right:00,bottom: 0.0,left:Size.width * 0.022 ),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
            controller.addPrice(item.price.toString(),item.value.toString());
            HapticFeedback.vibrate();
            },
            child: SizedBox(
              width: width,
              height: Dimensions.h_20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TradeBitTextWidget(title: double.parse(item.value.toString()).toStringAsFixed(4), style: AppTextStyle.normalTextStyle(FontSize.sp_12, Theme.of(c).highlightColor)),
                  TradeBitTextWidget(title: item.price.toString(),
                      style: AppTextStyle.themeBoldNormalTextStyle(
                          fontSize: FontSize.sp_12,
                          color: AppColor.green
                      )),
                ],),
            ),
          ),
        ),

      ],
    );
  }
}
