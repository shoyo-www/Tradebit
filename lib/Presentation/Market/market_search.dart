import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:remove_emoji_input_formatter/remove_emoji_input_formatter.dart';
import 'package:tradebit_app/Presentation/Market/market.dart';
import 'package:tradebit_app/Presentation/Market/market_controller.dart';
import 'package:tradebit_app/Presentation/dashboard/dashboard.dart';
import 'package:tradebit_app/constants/apptextstyle.dart';
import 'package:tradebit_app/constants/constants.dart';
import 'package:tradebit_app/constants/fontsize.dart';
import 'package:tradebit_app/constants/images.dart';
import 'package:tradebit_app/data/datasource/local/local_storage.dart';
import 'package:tradebit_app/widgets/spacing.dart';
import 'package:tradebit_app/widgets/tradeBit_scaffold.dart';
import 'package:tradebit_app/widgets/trade_bit_container.dart';
import 'package:tradebit_app/widgets/tradebit_cache_image.dart';
import 'package:tradebit_app/widgets/tradebit_text.dart';

class MarketSearchPage extends StatefulWidget {
   const MarketSearchPage({super.key});

  @override
  State<MarketSearchPage> createState() => _MarketSearchPageState();
}

class _MarketSearchPageState extends State<MarketSearchPage> {
  final MarketController marketController = Get.put(MarketController());

  @override
  Widget build(BuildContext context) {
    return  WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        return false;
      },
      child: GetBuilder(
        id: ControllerBuilders.marketController,
        init: marketController,
        builder: (controller) {
          return TradeBitContainer(
            decoration: BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor),
            child: SafeArea(
              child: TradeBitScaffold(
                  body: Padding(
                    padding: EdgeInsets.only(left:Dimensions.w_15 ,right: Dimensions.w_15),
                    child: Column(
                        children : [
                          VerticalSpacing(height: Dimensions.h_20),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                  child: const Icon(Icons.arrow_back_ios)),
                              HorizontalSpacing(width: Dimensions.w_10),
                              Expanded(
                                child: SizedBox(
                                  height: Dimensions.h_40,
                                  child: CupertinoTextField(
                                    inputFormatters: [RemoveEmojiInputFormatter()],
                                    cursorColor: Theme.of(context).shadowColor,
                                    style: AppTextStyle.normalTextStyle(FontSize.sp_15, Theme.of(context).highlightColor),
                                    controller: controller.searchController,
                                    onChanged: (e) {
                                      controller.filterSearch(e);
                                    },
                                    decoration:  BoxDecoration(
                                      color: Theme.of(context).cardColor,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    placeholder: 'Search',
                                    prefix: Padding(
                                      padding: const EdgeInsets.only(left: 8.0,top: 3,bottom: 3),
                                      child: Icon(CupertinoIcons.search,color: Colors.grey.withOpacity(0.5),),
                                    ),
                                    suffix: Padding(
                                      padding: const EdgeInsets.only(right: 8.0,top: 3,bottom: 3),
                                      child: GestureDetector(
                                        onTap: () {
                                          controller.clearTextField();
                                        },
                                          child: Icon(Icons.clear,color: Colors.grey.withOpacity(0.5),)),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          VerticalSpacing(height: Dimensions.h_10),
                          controller.filterList.isEmpty && controller.search == true ? Padding(
                            padding:  EdgeInsets.only(top: Dimensions.h_40),
                            child: Column(
                              children: [
                                SizedBox(
                                  width: Dimensions.h_200,
                                    child: LottieBuilder.asset(Images.noDataFound)),
                                VerticalSpacing(height: Dimensions.h_30),
                                TradeBitTextWidget(title: 'No Data Found', style: AppTextStyle.themeBoldNormalTextStyle(
                                  fontSize: FontSize.sp_18,
                                  color: Theme.of(context).highlightColor
                                ))
                              ],
                            ),
                          ): Expanded(
                            child: StreamBuilder(
                              stream: controller.streamControllerSearch.stream,
                              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                                print(snapshot.data.toString());
                                if(snapshot.hasData && snapshot.connectionState == ConnectionState.active) {
                                  final data = openOrderResponseFromJson(snapshot.data);
                                  int index;
                                  if(controller.search == true) {
                                    index = controller.filterList.indexWhere((element) => element.symbol == data.s);
                                  }else {
                                    index = controller.market.indexWhere((element) => element.symbol == data.s);
                                  }
                                  if (index != -1) {
                                    controller.search ? controller.filterList[index].change = '' : controller.market[index].change = '';
                                    controller.search ? controller.filterList[index].price = '' : controller.market[index].price = '';
                                    controller.search ? controller.filterList[index].change = data.p.toString()
                                    : controller.market[index].change = data.p.toString();
                                    controller.search ? controller.filterList[index].price = data.openOrderResponseB.toString() :
                                    controller.market[index].price = data.openOrderResponseB.toString();
                                  }
                                  ListView.builder(
                                      padding: EdgeInsets.zero,
                                      itemBuilder: (c,i) {
                                        return GestureDetector(
                                          onTap: () {
                                            LocalStorage.writeString(GetXStorageConstants.symbol, controller.search ? controller.filterList[i].symbol.toString() : controller.market[i].symbol.toString());
                                            LocalStorage.writeString(GetXStorageConstants.price, controller.search ? controller.filterList[i].price.toString() : controller.market[i].price.toString());
                                            LocalStorage.writeString(GetXStorageConstants.pair, controller.search ? controller.filterList[i].pairWith.toString() : controller.market[i].pairWith.toString());
                                            LocalStorage.writeString(GetXStorageConstants.name, controller.search ? controller.filterList[i].currency.toString() : controller.market[i].currency.toString());
                                            LocalStorage.writeString(GetXStorageConstants.change,controller.search ? controller.filterList[i].change.toString() : controller.market[i].change.toString());
                                            LocalStorage.writeBool(GetXStorageConstants.firstTime, false);
                                            LocalStorage.writeBool(GetXStorageConstants.fromAnother, true);
                                            LocalStorage.writeBool(GetXStorageConstants.listed, controller.search ? controller.filterList[i].listed ?? false : controller.market[i].listed ?? false);
                                            pushReplacementWithSlideTransition(context, DashBoard(index: 2));
                                          },
                                          child: TradeBitContainer(
                                            margin: EdgeInsets.only(top: Dimensions.h_8,bottom: Dimensions.h_3),
                                            padding:  EdgeInsets.only(top: Dimensions.h_12,bottom: Dimensions.h_12,left: Dimensions.h_10,right: Dimensions.h_10),
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
                                                      width: Dimensions.h_30,
                                                      height: Dimensions.h_30,
                                                      child: ClipRRect(
                                                        borderRadius: BorderRadius.circular(50),
                                                        child: TradebitCacheImage(image: controller.search ? controller.filterList[i].image?? '' : controller.market[i].image ?? ''),
                                                      ),
                                                    ),
                                                    HorizontalSpacing(width: Dimensions.w_5),
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      children: <Widget>[
                                                        TradeBitTextWidget(title: controller.search ? controller.filterList[i].symbol ?? '': controller.market[i].symbol ?? '', style: AppTextStyle.themeBoldTextStyle(fontSize:FontSize.sp_14, color: Theme.of(context).highlightColor)),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                double.parse(controller.search ? controller.filterList[i].change ?? '' : controller.market[i].change ?? '') <
                                                    0
                                                    ? Image.asset(Images.market_down,scale: 4,)
                                                    : Image.asset(Images.market_up,scale: 4,),
                                                Column(
                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                  crossAxisAlignment: CrossAxisAlignment.end,
                                                  children: [
                                                    TradeBitTextWidget(title: double.parse( controller.search ? controller.filterList[i].price ?? '': controller.market[i].price ?? '').toStringAsFixed(2), style: AppTextStyle.themeBoldTextStyle(fontSize:FontSize.sp_14, color: Theme.of(context).highlightColor)),
                                                    TradeBitTextWidget(title: "${double.parse(controller.search ? controller.filterList[i].change ?? '' : controller.market[i].change ?? '')}%", style:
                                                    AppTextStyle.normalTextStyle(FontSize.sp_14, double.parse(controller.search ? controller.filterList[i].change ?? '' : controller.market[i].change ?? '') <
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
                                      itemCount: controller.search ? controller.filterList.length : controller.market.length);
                                }
                                return ListView.builder(
                                    padding: EdgeInsets.zero,
                                    itemBuilder: (c,i) {
                                      return GestureDetector(
                                        onTap: () {
                                          LocalStorage.writeString(GetXStorageConstants.symbol, controller.search ? controller.filterList[i].symbol.toString() : controller.market[i].symbol.toString());
                                          LocalStorage.writeString(GetXStorageConstants.price, controller.search ? controller.filterList[i].price.toString() : controller.market[i].price.toString());
                                          LocalStorage.writeString(GetXStorageConstants.pair, controller.search ? controller.filterList[i].pairWith.toString() : controller.market[i].pairWith.toString());
                                          LocalStorage.writeString(GetXStorageConstants.name, controller.search ? controller.filterList[i].currency.toString() : controller.market[i].currency.toString());
                                          LocalStorage.writeString(GetXStorageConstants.change,controller.search ? controller.filterList[i].change.toString() : controller.market[i].change.toString());
                                          LocalStorage.writeBool(GetXStorageConstants.firstTime, false);
                                          LocalStorage.writeBool(GetXStorageConstants.fromAnother, true);
                                          LocalStorage.writeBool(GetXStorageConstants.listed, controller.search ? controller.filterList[i].listed ?? false : controller.market[i].listed ?? false);
                                          pushReplacementWithSlideTransition(context, DashBoard(index: 2));
                                        },
                                        child: TradeBitContainer(
                                          margin: EdgeInsets.only(top: Dimensions.h_8,bottom: Dimensions.h_3),
                                          padding:  EdgeInsets.only(top: Dimensions.h_12,bottom: Dimensions.h_12,left: Dimensions.h_10,right: Dimensions.h_10),
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
                                                    width: Dimensions.h_30,
                                                    height: Dimensions.h_30,
                                                    child: ClipRRect(
                                                      borderRadius: BorderRadius.circular(50),
                                                      child: TradebitCacheImage(image: controller.search ? controller.filterList[i].image?? '' : controller.market[i].image ?? ''),
                                                    ),
                                                  ),
                                                  HorizontalSpacing(width: Dimensions.w_5),
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: <Widget>[
                                                      TradeBitTextWidget(title: controller.search ? controller.filterList[i].symbol ?? '': controller.market[i].symbol ?? '', style: AppTextStyle.themeBoldTextStyle(fontSize:FontSize.sp_14, color: Theme.of(context).highlightColor)),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              double.parse(controller.search ? controller.filterList[i].change ?? '' : controller.market[i].change ?? '') <
                                                  0
                                                  ? Image.asset(Images.market_down,scale: 4,)
                                                  : Image.asset(Images.market_up,scale: 4,),
                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                children: [
                                                  TradeBitTextWidget(title: controller.search ? controller.filterList[i].price ?? '0.0': controller.market[i].price ?? '0.0', style: AppTextStyle.themeBoldTextStyle(fontSize:FontSize.sp_14, color: Theme.of(context).highlightColor)),
                                                  TradeBitTextWidget(title: "${controller.search ? controller.filterList[i].change ?? '0.0' : controller.market[i].change ?? '0.0'}%", style:
                                                  AppTextStyle.normalTextStyle(FontSize.sp_14, double.parse(controller.search ? controller.filterList[i].change ?? '0.0' : controller.market[i].change ?? '0.0') <
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
                                    itemCount: controller.search ? controller.filterList.length : controller.market.length);
                              },

                            ),
                          )
                        ]
                    ),
                  )
              ),
            ),
          );
        },
      ),
    );
  }
}
