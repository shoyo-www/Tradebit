import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tradebit_app/Presentation/Homepage/home_controller.dart';
import 'package:tradebit_app/Presentation/Market/market.dart';
import 'package:tradebit_app/Presentation/dashboard/dashboard.dart';
import 'package:tradebit_app/constants/apptextstyle.dart';
import 'package:tradebit_app/constants/constants.dart';
import 'package:tradebit_app/constants/fontsize.dart';
import 'package:tradebit_app/constants/images.dart';
import 'package:tradebit_app/data/datasource/local/local_storage.dart';
import 'package:tradebit_app/widgets/spacing.dart';
import 'package:tradebit_app/widgets/trade_bit_container.dart';
import 'package:tradebit_app/widgets/tradebit_cache_image.dart';
import 'package:tradebit_app/widgets/tradebit_text.dart';

class SpotStreamWidget extends StatefulWidget {
  final HomeController controller;
  const SpotStreamWidget({super.key,required this.controller});

  @override
  State<SpotStreamWidget> createState() => _SpotStreamWidgetState();
}

class _SpotStreamWidgetState extends State<SpotStreamWidget> {
  @override
  void initState() {
      widget.controller.connectToSocket();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var cryptoList = List.from(LocalStorage.getListCrypto());
    return Expanded(
      child: StreamBuilder(
        stream: widget.controller.streamController.stream,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if(snapshot.connectionState == ConnectionState.active && snapshot.hasData) {
            final data = openOrderResponseFromJson(snapshot.data);
            int index = cryptoList.indexWhere((element) => element.symbol == data.s);
            if (index != -1) {
              cryptoList[index].change = '';
              cryptoList[index].price = '';
              cryptoList[index].change = double.parse(data.p.toString()).toStringAsFixed(2);
              cryptoList[index].price = data.openOrderResponseB.toString();
            }
            return ListView.builder(
                itemBuilder: (c,i) {
                  return GestureDetector(
                    onTap: () {
                      LocalStorage.writeString(GetXStorageConstants.symbol, cryptoList[i].symbol.toString());
                      LocalStorage.writeString(GetXStorageConstants.price, cryptoList[i].price.toString());
                      LocalStorage.writeString(GetXStorageConstants.pair, cryptoList[i].pairWith.toString());
                      LocalStorage.writeString(GetXStorageConstants.name,cryptoList[i].currency.toString());
                      LocalStorage.writeBool(GetXStorageConstants.firstTime, false);
                      LocalStorage.writeBool(GetXStorageConstants.fromAnother, true);
                      LocalStorage.writeBool(GetXStorageConstants.listed, cryptoList[i].listed);
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
                                    child: TradebitCacheImage(image: cryptoList[i].image ?? '')),
                              ),
                              HorizontalSpacing(width: Dimensions.w_5),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  TradeBitTextWidget(title: cryptoList[i].symbol ?? '', style: AppTextStyle.normalTextStyle(FontSize.sp_14,  Theme.of(context).highlightColor)),
                                  TradeBitTextWidget(title: cryptoList[i].name ?? '', style: AppTextStyle.normalTextStyle(FontSize.sp_11,Theme.of(context).shadowColor)),
                                ],
                              ),
                            ],
                          ),
                          double.parse(cryptoList[i].change ?? '') <
                              0
                              ? Image.asset(Images.market_down,scale: 4,)
                              : Image.asset(Images.market_up,scale: 4,),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              TradeBitTextWidget(title: double.parse(cryptoList[i].price ?? '').toStringAsFixed(2), style: AppTextStyle.normalTextStyle(FontSize.sp_14,Theme.of(context).highlightColor)),
                              TradeBitTextWidget(title: "${double.parse(cryptoList[i].change ?? '')}%", style:
                              AppTextStyle.normalTextStyle(FontSize.sp_14, double.parse(cryptoList[i].change ?? '') <
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
                itemCount: cryptoList.length);
          }
          return ListView.builder(
              itemBuilder: (c,i) {
                return GestureDetector(
                  onTap: () {
                    LocalStorage.writeString(GetXStorageConstants.symbol, cryptoList[i].symbol.toString());
                    LocalStorage.writeString(GetXStorageConstants.price, cryptoList[i].price.toString());
                    LocalStorage.writeString(GetXStorageConstants.pair, cryptoList[i].pairWith.toString());
                    LocalStorage.writeString(GetXStorageConstants.name,cryptoList[i].currency.toString());
                    LocalStorage.writeBool(GetXStorageConstants.firstTime, false);
                    LocalStorage.writeBool(GetXStorageConstants.fromAnother, true);
                    LocalStorage.writeBool(GetXStorageConstants.listed, cryptoList[i].listed);
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
                                  child: TradebitCacheImage(image: cryptoList[i].image ?? '')),
                            ),
                            HorizontalSpacing(width: Dimensions.w_5),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                TradeBitTextWidget(title: cryptoList[i].symbol ?? '', style: AppTextStyle.normalTextStyle(FontSize.sp_14,  Theme.of(context).highlightColor)),
                                TradeBitTextWidget(title: cryptoList[i].name ?? '', style: AppTextStyle.normalTextStyle(FontSize.sp_11,Theme.of(context).shadowColor)),
                              ],
                            ),
                          ],
                        ),
                        double.parse(cryptoList[i].change ?? '') < 0 ? Image.asset(Images.market_down,scale: 4) : Image.asset(Images.market_up,scale: 4),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            TradeBitTextWidget(title: double.parse(cryptoList[i].price ?? '').toStringAsFixed(2), style: AppTextStyle.normalTextStyle(FontSize.sp_14,Theme.of(context).highlightColor)),
                            TradeBitTextWidget(title: "${double.parse(cryptoList[i].change ?? '')}%", style:
                            AppTextStyle.normalTextStyle(FontSize.sp_14, double.parse(cryptoList[i].change ?? '') <
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
              itemCount: cryptoList.length);
        },
      ),
    );
  }
}
