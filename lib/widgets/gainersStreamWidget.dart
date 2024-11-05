import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tradebit_app/Presentation/Homepage/home_controller.dart';
import 'package:tradebit_app/Presentation/Market/market.dart';
import 'package:tradebit_app/Presentation/dashboard/dashboard.dart';
import 'package:tradebit_app/constants/apptextstyle.dart';
import 'package:tradebit_app/constants/constants.dart';
import 'package:tradebit_app/constants/fontsize.dart';
import 'package:tradebit_app/constants/images.dart';
import 'package:tradebit_app/data/datasource/local/local_storage.dart';
import 'package:tradebit_app/data/datasource/remote/models/response/gainers_response.dart';
import 'package:tradebit_app/widgets/spacing.dart';
import 'package:tradebit_app/widgets/trade_bit_container.dart';
import 'package:tradebit_app/widgets/tradebit_cache_image.dart';
import 'package:tradebit_app/widgets/tradebit_text.dart';

class GainersStream extends StatefulWidget {
  final HomeController controller;
  final List<CoreDatum> list;
  const GainersStream({super.key, required this.controller,required this.list});

  @override
  State<GainersStream> createState() => _GainersStreamState();
}

class _GainersStreamState extends State<GainersStream> {

  @override
  void initState() {
      widget.controller.connectToSocketGainers();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        VerticalSpacing(height: Dimensions.h_5),
        Expanded(
          child: StreamBuilder(
            stream: widget.controller.streamControllerGainer.stream,
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if(snapshot.connectionState == ConnectionState.active && snapshot.hasData) {
                final data = openOrderResponseFromJson(snapshot.data);
                int index = widget.list.indexWhere((element) => element.symbol == data.s);
                if (index != -1) {
                  widget.list[index].priceChange = '';
                  widget.list[index].highPrice = '';
                  widget.list[index].priceChangePercent = '';
                  widget.list[index].priceChangePercent = data.p.toString();
                  widget.list[index].priceChange = double.parse(data.p.toString()).toStringAsFixed(2);
                  widget.list[index].highPrice = data.openOrderResponseB.toString();
                }
                return ListView.builder(
                    itemBuilder: (c,i) {
                      return GestureDetector(
                        onTap: (){
                          LocalStorage.writeString(GetXStorageConstants.symbol, widget.list[i].symbol.toString());
                          LocalStorage.writeString(GetXStorageConstants.price, widget.list[i].lastPrice.toString());
                          LocalStorage.writeString(GetXStorageConstants.pair, widget.list[i].symbol.toString());
                          LocalStorage.writeString(GetXStorageConstants.name,widget.list[i].name.toString());
                          LocalStorage.writeBool(GetXStorageConstants.firstTime, false);
                          LocalStorage.writeBool(GetXStorageConstants.fromAnother, true);
                          LocalStorage.writeBool(GetXStorageConstants.listed, false);
                          pushReplacementWithSlideTransition(context, DashBoard(index: 2));
                        },
                        child: TradeBitContainer(
                          margin: EdgeInsets.only(left: Dimensions.h_5,right: Dimensions.h_5,top: Dimensions.h_1,bottom: Dimensions.h_3),
                          padding:  EdgeInsets.only(top: Dimensions.h_6,bottom: Dimensions.h_1,left: Dimensions.h_10,right: Dimensions.h_10),
                          decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  SizedBox(
                                    width: Dimensions.h_25,
                                    height: Dimensions.h_25,
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.circular(50),
                                        child: TradebitCacheImage(image: widget.list[i].image ?? '')),
                                  ),
                                  HorizontalSpacing(width: Dimensions.w_10),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      TradeBitTextWidget(title: widget.list[i].symbol ?? '', style: AppTextStyle.normalTextStyle(FontSize.sp_14,Theme.of(context).highlightColor)),
                                      TradeBitTextWidget(title: widget.list[i].name ?? '', style: AppTextStyle.normalTextStyle(FontSize.sp_11,Theme.of(context).shadowColor)),
                                    ],
                                  ),
                                ],
                              ),
                              double.parse(widget.list[i].priceChange ?? '0') <
                                  0
                                  ? Image.asset(Images.market_down,scale: 4,)
                                  : Image.asset(Images.market_up,scale: 4,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  TradeBitTextWidget(title: double.parse(widget.list[i].highPrice ?? '').toStringAsFixed(2), style: AppTextStyle.themeBoldTextStyle(fontSize:FontSize.sp_16, color: Theme.of(context).highlightColor)),
                                  TradeBitTextWidget(title: "${double.parse(widget.list[i].priceChangePercent ?? '0')}%", style:
                                  AppTextStyle.normalTextStyle(FontSize.sp_10, double.parse(widget.list[i].priceChangePercent ?? '') <
                                      0
                                      ? Colors.redAccent
                                      : const Color(0xFF00C087))),
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    },
                    itemCount: widget.list.length);
              }
              return ListView.builder(
                  itemBuilder: (c,i) {
                    return GestureDetector(
                      onTap: () {
                        LocalStorage.writeString(GetXStorageConstants.symbol, widget.list[i].symbol.toString());
                        LocalStorage.writeString(GetXStorageConstants.price, widget.list[i].lastPrice.toString());
                        LocalStorage.writeString(GetXStorageConstants.pair, widget.list[i].symbol.toString());
                        LocalStorage.writeString(GetXStorageConstants.name,widget.list[i].name.toString());
                        LocalStorage.writeBool(GetXStorageConstants.firstTime, false);
                        LocalStorage.writeBool(GetXStorageConstants.fromAnother, true);
                        LocalStorage.writeBool(GetXStorageConstants.listed, false);
                        pushReplacementWithSlideTransition(context, DashBoard(index: 2));
                        },
                      child: TradeBitContainer(
                        margin: EdgeInsets.only(left: Dimensions.h_5,right: Dimensions.h_5,top: Dimensions.h_1,bottom: Dimensions.h_3),
                        padding:  EdgeInsets.only(top: Dimensions.h_6,bottom: Dimensions.h_1,left: Dimensions.h_10,right: Dimensions.h_10),
                        decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(10)
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                SizedBox(
                                  width: Dimensions.h_25,
                                  height: Dimensions.h_25,
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child: TradebitCacheImage(image: widget.list[i].image ?? '')),
                                ),
                                HorizontalSpacing(width: Dimensions.w_10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    TradeBitTextWidget(title: widget.list[i].symbol ?? '', style: AppTextStyle.normalTextStyle(FontSize.sp_14,Theme.of(context).highlightColor)),
                                    TradeBitTextWidget(title: widget.list[i].name ?? '', style: AppTextStyle.normalTextStyle(FontSize.sp_11,Theme.of(context).shadowColor)),
                                  ],
                                ),
                              ],
                            ),
                            double.parse(widget.list[i].priceChange ?? '0') <
                                0
                                ? Image.asset(Images.market_down,scale: 4,)
                                : Image.asset(Images.market_up,scale: 4,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                TradeBitTextWidget(title: double.parse(widget.list[i].highPrice ?? '').toStringAsFixed(2), style: AppTextStyle.themeBoldTextStyle(fontSize:FontSize.sp_16, color: Theme.of(context).highlightColor)),
                                TradeBitTextWidget(title: "${double.parse(widget.list[i].priceChangePercent ?? '0')}%", style:
                                AppTextStyle.normalTextStyle(FontSize.sp_10, double.parse(widget.list[i].priceChangePercent ?? '') <
                                    0
                                    ? Colors.redAccent
                                    : const Color(0xFF00C087))),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  },
                  itemCount: widget.list.length);
            },
          ),
        ),
      ],
    );
  }

}


class LosersStream extends StatefulWidget {
  final HomeController controller;
  final List<CoreDatum> list;
  const LosersStream({super.key, required this.controller,required this.list});

  @override
  State<LosersStream> createState() => _LosersStreamState();
}

class _LosersStreamState extends State<LosersStream> {

  @override
  void initState() {
    widget.controller.connectToSocketLosers();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        VerticalSpacing(height: Dimensions.h_5),
        Expanded(
          child: StreamBuilder(
            stream: widget.controller.streamControllerLooser.stream,
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if(snapshot.connectionState == ConnectionState.active && snapshot.hasData) {
                final data = openOrderResponseFromJson(snapshot.data);
                int index = widget.list.indexWhere((element) => element.symbol == data.s);
                if (index != -1) {
                  widget.list[index].priceChange = '';
                  widget.list[index].highPrice = '';
                  widget.list[index].priceChangePercent = '';
                  widget.list[index].priceChangePercent = data.p.toString();
                  widget.list[index].priceChange = double.parse(data.p.toString()).toStringAsFixed(2);
                  widget.list[index].highPrice = data.openOrderResponseB.toString();
                }
                return ListView.builder(
                    itemBuilder: (c,i) {
                      return GestureDetector(
                        onTap: (){
                          LocalStorage.writeString(GetXStorageConstants.symbol, widget.list[i].symbol.toString());
                          LocalStorage.writeString(GetXStorageConstants.price, widget.list[i].lastPrice.toString());
                          LocalStorage.writeString(GetXStorageConstants.pair, widget.list[i].symbol.toString());
                          LocalStorage.writeString(GetXStorageConstants.name,widget.list[i].name.toString());
                          LocalStorage.writeBool(GetXStorageConstants.firstTime, false);
                          LocalStorage.writeBool(GetXStorageConstants.fromAnother, true);
                          LocalStorage.writeBool(GetXStorageConstants.listed, false);
                          pushReplacementWithSlideTransition(context, DashBoard(index: 2));
                        },
                        child: TradeBitContainer(
                          margin: EdgeInsets.only(left: Dimensions.h_5,right: Dimensions.h_5,top: Dimensions.h_1,bottom: Dimensions.h_3),
                          padding:  EdgeInsets.only(top: Dimensions.h_6,bottom: Dimensions.h_1,left: Dimensions.h_10,right: Dimensions.h_10),
                          decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  SizedBox(
                                    width: Dimensions.h_25,
                                    height: Dimensions.h_25,
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.circular(50),
                                        child: TradebitCacheImage(image: widget.list[i].image ?? '')),
                                  ),
                                  HorizontalSpacing(width: Dimensions.w_10),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      TradeBitTextWidget(title: widget.list[i].symbol ?? '', style: AppTextStyle.normalTextStyle(FontSize.sp_14,Theme.of(context).highlightColor)),
                                      TradeBitTextWidget(title: widget.list[i].name ?? '', style: AppTextStyle.normalTextStyle(FontSize.sp_11,Theme.of(context).shadowColor)),
                                    ],
                                  ),
                                ],
                              ),
                              double.parse(widget.list[i].priceChange ?? '0') <
                                  0
                                  ? Image.asset(Images.market_down,scale: 4,)
                                  : Image.asset(Images.market_up,scale: 4,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  TradeBitTextWidget(title: double.parse(widget.list[i].highPrice ?? '').toStringAsFixed(2), style: AppTextStyle.themeBoldTextStyle(fontSize:FontSize.sp_16, color: Theme.of(context).highlightColor)),
                                  TradeBitTextWidget(title: "${double.parse(widget.list[i].priceChangePercent ?? '0')}%", style:
                                  AppTextStyle.normalTextStyle(FontSize.sp_10, double.parse(widget.list[i].priceChangePercent ?? '') <
                                      0
                                      ? Colors.redAccent
                                      : const Color(0xFF00C087))),
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    },
                    itemCount: widget.list.length);
              }
              return ListView.builder(
                  itemBuilder: (c,i) {
                    return GestureDetector(
                      onTap: () {
                        LocalStorage.writeString(GetXStorageConstants.symbol, widget.list[i].symbol.toString());
                        LocalStorage.writeString(GetXStorageConstants.price, widget.list[i].lastPrice.toString());
                        LocalStorage.writeString(GetXStorageConstants.pair, widget.list[i].symbol.toString());
                        LocalStorage.writeString(GetXStorageConstants.name,widget.list[i].name.toString());
                        LocalStorage.writeBool(GetXStorageConstants.firstTime, false);
                        LocalStorage.writeBool(GetXStorageConstants.fromAnother, true);
                        LocalStorage.writeBool(GetXStorageConstants.listed, false);
                        pushReplacementWithSlideTransition(context, DashBoard(index: 2));
                      },
                      child: TradeBitContainer(
                        margin: EdgeInsets.only(left: Dimensions.h_5,right: Dimensions.h_5,top: Dimensions.h_1,bottom: Dimensions.h_3),
                        padding:  EdgeInsets.only(top: Dimensions.h_6,bottom: Dimensions.h_1,left: Dimensions.h_10,right: Dimensions.h_10),
                        decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(10)
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                SizedBox(
                                  width: Dimensions.h_25,
                                  height: Dimensions.h_25,
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child: TradebitCacheImage(image: widget.list[i].image ?? '')),
                                ),
                                HorizontalSpacing(width: Dimensions.w_10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    TradeBitTextWidget(title: widget.list[i].symbol ?? '', style: AppTextStyle.normalTextStyle(FontSize.sp_14,Theme.of(context).highlightColor)),
                                    TradeBitTextWidget(title: widget.list[i].name ?? '', style: AppTextStyle.normalTextStyle(FontSize.sp_11,Theme.of(context).shadowColor)),
                                  ],
                                ),
                              ],
                            ),
                            double.parse(widget.list[i].priceChange ?? '0') <
                                0
                                ? Image.asset(Images.market_down,scale: 4,)
                                : Image.asset(Images.market_up,scale: 4,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                TradeBitTextWidget(title: double.parse(widget.list[i].highPrice ?? '').toStringAsFixed(2), style: AppTextStyle.themeBoldTextStyle(fontSize:FontSize.sp_16, color: Theme.of(context).highlightColor)),
                                TradeBitTextWidget(title: "${double.parse(widget.list[i].priceChangePercent ?? '0')}%", style:
                                AppTextStyle.normalTextStyle(FontSize.sp_10, double.parse(widget.list[i].priceChangePercent ?? '') <
                                    0
                                    ? Colors.redAccent
                                    : const Color(0xFF00C087))),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  },
                  itemCount: widget.list.length);
            },
          ),
        ),
      ],
    );
  }

}