import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:tradebit_app/Presentation/Market/market.dart';
import 'package:tradebit_app/Presentation/Market/market_controller.dart';
import 'package:tradebit_app/Presentation/dashboard/dashboard.dart';
import 'package:tradebit_app/Presentation/exchange/exhange_controller.dart';
import 'package:tradebit_app/constants/appcolor.dart';
import 'package:tradebit_app/constants/apptextstyle.dart';
import 'package:tradebit_app/constants/constants.dart';
import 'package:tradebit_app/constants/fontsize.dart';
import 'package:tradebit_app/constants/images.dart';
import 'package:tradebit_app/data/datasource/local/local_storage.dart';
import 'package:tradebit_app/data/datasource/remote/models/response/crypto_response.dart';
import 'package:tradebit_app/widgets/spacing.dart';
import 'package:tradebit_app/widgets/trade_bit_container.dart';
import 'package:tradebit_app/widgets/tradebit_text.dart';

class ListWidget extends StatelessWidget {
  final bool disable;
  final MarketController? controller;
  final ExchangeController? exchangeController;
  final List<Btc> listData;
  final List<Btc>? exchangeData;

  const ListWidget({super.key, this.controller,required this.listData,this.disable = false, this.exchangeData,this.exchangeController});

  @override
  Widget build(BuildContext context) {
    var list = listData;
    var exchange = exchangeData;
    return list.isEmpty ?
    Center(
        child: SizedBox(
            height: Dimensions.h_200,
            child: Lottie.asset(Images.searchAnimation))
    ) :
    StreamBuilder(
        stream: disable ? exchangeController?.streamController.stream : controller?.streamController.stream,
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.active && snapshot.hasData) {
            final data = openOrderResponseFromJson(snapshot.data.toString());
            int index = list.indexWhere((element) => element.symbol == data.s);
            if (index != -1) {
              list[index].change = '';
              list[index].price = '';
              list[index].change = double.parse(data.p.toString()).toStringAsFixed(2);
              list[index].price = data.openOrderResponseB.toString();
            }
            return ListView.builder(
                itemBuilder: (c,i) {
                  return GestureDetector(
                    onTap: disable ? () {
                      LocalStorage.writeString(GetXStorageConstants.symbol, exchange?[i].symbol ?? '');
                      LocalStorage.writeString(GetXStorageConstants.price, exchange?[i].price ?? '');
                      LocalStorage.writeString(GetXStorageConstants.pair, exchange?[i].pairWith ?? '');
                      LocalStorage.writeString(GetXStorageConstants.name,exchange?[i].currency ?? '');
                      LocalStorage.writeString(GetXStorageConstants.change,exchange?[i].change ?? '0.0');
                      LocalStorage.writeBool(GetXStorageConstants.firstTime, false);
                      LocalStorage.writeBool(GetXStorageConstants.listed, exchange?[i].listed ?? false);
                      exchangeController?.drawer(
                          context: context,
                          list: exchange?[i].listed ?? false,
                      );
                    } : () {
                      LocalStorage.writeString(GetXStorageConstants.symbol, list[i].symbol.toString());
                      LocalStorage.writeString(GetXStorageConstants.price, list[i].price.toString());
                      LocalStorage.writeString(GetXStorageConstants.pair, list[i].pairWith.toString());
                      LocalStorage.writeString(GetXStorageConstants.name,list[i].currency.toString());
                      LocalStorage.writeBool(GetXStorageConstants.firstTime, false);
                      LocalStorage.writeBool(GetXStorageConstants.fromAnother, true);
                      LocalStorage.writeBool(GetXStorageConstants.listed, exchange?[i].listed ?? false);
                      pushReplacementWithSlideTransition(context, DashBoard(index: 2));
                    },
                    child: TradeBitContainer(
                      margin: EdgeInsets.only(left: disable ? 0 : Dimensions.h_5,right: disable ? 0 : Dimensions.h_5,top: Dimensions.h_8,bottom: Dimensions.h_3),
                      padding:  EdgeInsets.only(top: disable ? Dimensions.h_5 : Dimensions.h_12,bottom: disable ? Dimensions.h_5 :Dimensions.h_12,left: disable ? Dimensions.h_4: Dimensions.h_10,right: disable ? Dimensions.h_4 :Dimensions.h_10),
                      decoration: BoxDecoration(
                          color: disable ? AppColor.transparent : Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              SizedBox(
                                width: Dimensions.h_30,
                                height: Dimensions.h_30,
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: list[i].image?.isEmpty ?? false ? Image.asset(Images.wallet): Image.network(list[i].image ?? '')),
                              ),
                              HorizontalSpacing(width: Dimensions.w_5),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  TradeBitTextWidget(title: list[i].symbol ?? '', style: disable ? AppTextStyle.normalTextStyle(FontSize.sp_13, Theme.of(context).highlightColor): AppTextStyle.themeBoldTextStyle(fontSize:FontSize.sp_14, color: Theme.of(context).highlightColor)),
                                ],
                              ),
                            ],
                          ),
                          double.parse(list[i].change ?? '') <
                              0
                              ? Image.asset(Images.market_down,scale: 4,)
                              : Image.asset(Images.market_up,scale: 4,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              TradeBitTextWidget(title: double.parse(list[i].price ?? '').toStringAsFixed(2), style: disable ? AppTextStyle.normalTextStyle(FontSize.sp_13, Theme.of(context).highlightColor) : AppTextStyle.themeBoldTextStyle(fontSize:FontSize.sp_14, color: Theme.of(context).highlightColor)),
                              TradeBitTextWidget(title: "${double.parse(list[i].change ?? '')}%", style:
                              AppTextStyle.normalTextStyle(disable ? FontSize.sp_13 : FontSize.sp_14,
                                  double.parse(list[i].change ?? '') <
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
                itemCount: list.length);
          }
          return ListView.builder(
              itemBuilder: (c,i) {
                return GestureDetector(
                  onTap: disable ? () {
                    LocalStorage.writeString(GetXStorageConstants.symbol, exchange?[i].symbol ?? '');
                    LocalStorage.writeString(GetXStorageConstants.price, exchange?[i].price ?? '');
                    LocalStorage.writeString(GetXStorageConstants.pair, exchange?[i].pairWith ?? '');
                    LocalStorage.writeString(GetXStorageConstants.name,exchange?[i].currency ?? '');
                    LocalStorage.writeString(GetXStorageConstants.change,exchange?[i].change ?? '0.0');
                    LocalStorage.writeBool(GetXStorageConstants.firstTime, false);
                    LocalStorage.writeBool(GetXStorageConstants.listed, exchange?[i].listed ?? false);
                    exchangeController?.drawer(
                      context: context,
                      list: exchange?[i].listed ?? false,
                    );
                  } : () {
                    LocalStorage.writeString(GetXStorageConstants.symbol, list[i].symbol.toString());
                    LocalStorage.writeString(GetXStorageConstants.price, list[i].price.toString());
                    LocalStorage.writeString(GetXStorageConstants.pair, list[i].pairWith.toString());
                    LocalStorage.writeString(GetXStorageConstants.name,list[i].currency.toString());
                    LocalStorage.writeBool(GetXStorageConstants.firstTime, false);
                    LocalStorage.writeBool(GetXStorageConstants.fromAnother, true);
                    LocalStorage.writeBool(GetXStorageConstants.listed, exchange?[i].listed ?? false);
                    pushReplacementWithSlideTransition(context, DashBoard(index: 2));
                  },
                  child: TradeBitContainer(
                    margin: EdgeInsets.only(left: disable ? 0 : Dimensions.h_5,right: disable ? 0 : Dimensions.h_5,top: Dimensions.h_8,bottom: Dimensions.h_3),
                    padding:  EdgeInsets.only(top: disable ? Dimensions.h_5 : Dimensions.h_12,bottom: disable ? Dimensions.h_5 : Dimensions.h_12,left: disable ? Dimensions.h_4 : Dimensions.h_10,right: disable ? Dimensions.h_4 :Dimensions.h_10),
                    decoration: BoxDecoration(
                        color: disable ? AppColor.transparent : Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            SizedBox(
                              width: Dimensions.h_30,
                              height: Dimensions.h_30,
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: list[i].image?.isEmpty ?? false ? Image.asset(Images.wallet) : Image.network(list[i].image ?? '')),
                            ),
                            HorizontalSpacing(width: Dimensions.w_5),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                TradeBitTextWidget(title: list[i].symbol ?? '', style: disable ? AppTextStyle.normalTextStyle(FontSize.sp_13, Theme.of(context).highlightColor): AppTextStyle.themeBoldTextStyle(fontSize:FontSize.sp_14, color: Theme.of(context).highlightColor)),
                              ],
                            ),
                          ],
                        ),
                        double.parse(list[i].change ?? '') <
                            0
                            ? Image.asset(Images.market_down,scale: 4,)
                            : Image.asset(Images.market_up,scale: 4,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            TradeBitTextWidget(title: double.parse(list[i].price ?? '').toStringAsFixed(2), style: disable ? AppTextStyle.normalTextStyle(FontSize.sp_13, Theme.of(context).highlightColor) : AppTextStyle.themeBoldTextStyle(fontSize:FontSize.sp_14, color: Theme.of(context).highlightColor)),
                            TradeBitTextWidget(title: "${double.parse(list[i].change ?? '')}%", style: AppTextStyle.normalTextStyle(disable ? FontSize.sp_13 : FontSize.sp_14, double.parse(list[i].change ?? '') <
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
              itemCount: list.length);
        });
  }
}