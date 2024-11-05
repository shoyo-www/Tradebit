import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tradebit_app/Presentation/Market/market_controller.dart';
import 'package:tradebit_app/Presentation/dashboard/dashboard.dart';
import 'package:tradebit_app/Presentation/market/market_search.dart';
import 'package:tradebit_app/constants/appcolor.dart';
import 'package:tradebit_app/constants/apptextstyle.dart';
import 'package:tradebit_app/constants/constants.dart';
import 'package:tradebit_app/constants/fontsize.dart';
import 'package:tradebit_app/data/datasource/local/local_storage.dart';
import 'package:tradebit_app/widgets/listWidget.dart';
import 'package:tradebit_app/widgets/spacing.dart';
import 'package:tradebit_app/widgets/tradeBit_scaffold.dart';
import 'package:tradebit_app/widgets/trade_bit_container.dart';
import 'package:tradebit_app/widgets/tradebit_text.dart';
import 'package:shimmer/shimmer.dart';

class Market extends StatefulWidget {
  const Market({Key? key}) : super(key: key);

  @override
  State<Market> createState() => _MarketState();
}

class _MarketState extends State<Market> with SingleTickerProviderStateMixin{
  late TabController _tabController;

  List <String> marketFamily = ['USDT','BTC','ETH','TBC','TRX'];

 final MarketController marketController = Get.put(MarketController());

  @override
  void initState()  {
      marketController.connectToSocket();
    _tabController = TabController(length: marketFamily.length,vsync: this);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return  GetBuilder(
      init: marketController,
      id: ControllerBuilders.marketController,
      builder: (controller) {
        return TradeBitScaffold(
          body: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TradeBitContainer(
                    height: Dimensions.h_10,
                    decoration:  BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor
                    ),
                  ),
                  TradeBitContainer(
                    padding: EdgeInsets.only(top: Dimensions.h_40,left: Dimensions.w_20,right: Dimensions.w_20),
                    height: Dimensions.h_80,
                    width: double.infinity,
                    decoration:  BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor
                    ),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TradeBitTextWidget(
                            title: 'Market',
                            style: AppTextStyle.themeBoldTextStyle(
                              color: AppColor.white,
                              fontSize: FontSize.sp_26
                            ),
                          ),
                          GestureDetector(
                              onTap: () {
                                LocalStorage.writeBool(GetXStorageConstants.searchFromHome, false);
                                pushWithSlideTransition(
                                    context, const MarketSearchPage());
                              },
                              child: const Icon(CupertinoIcons.search,color: AppColor.white)),
                        ],
                      ),
                    ),
                  ),
                  // VerticalSpacing(height: Dimensions.h_30),
                  Padding(
                    padding:  EdgeInsets.only(left: Dimensions.w_5, right: Dimensions.w_5),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        children: [
                          TabBar(
                            tabAlignment: TabAlignment.start,
                            overlayColor:MaterialStateProperty.all<Color>(AppColor.transparent),
                            labelPadding:  EdgeInsets.only(left: Dimensions.w_23,right: Dimensions.w_23),
                            isScrollable: true,
                            physics: const NeverScrollableScrollPhysics(),
                            controller: _tabController,
                            indicator: const BoxDecoration(
                             border: Border(
                               bottom: BorderSide(
                                 color: AppColor.appColor,
                                 width: 2
                               )
                             )
                            ),

                            labelColor: AppColor.appColor,
                            unselectedLabelColor: Theme.of(context).highlightColor,
                            unselectedLabelStyle: AppTextStyle.themeBoldNormalTextStyle(
                              fontSize: FontSize.sp_15,color: Theme.of(context).highlightColor
                            ),
                            labelStyle: AppTextStyle.themeBoldNormalTextStyle(
                                fontSize: FontSize.sp_14,color: Theme.of(context).highlightColor
                            ),
                            tabs: <Widget>[
                              for (int i = 0; i < marketFamily.length; i++)
                                Tab(
                                  child: Text(
                                    marketFamily[i].toString(),
                                    style: AppTextStyle.themeBoldNormalTextStyle(
                                      fontSize: FontSize.sp_14,
                                      color: Theme.of(context).highlightColor
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  VerticalSpacing(height: Dimensions.h_2),
                  Expanded(
                    child: Container(
                      margin:  EdgeInsets.only(left: Dimensions.h_10,right: Dimensions.h_10,bottom: Dimensions.h_10),
                      child: TabBarView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        controller: _tabController,
                        children: <Widget>[
                      controller.isLoading ? Shimmer.fromColors(
                      baseColor: Theme.of(context).cardColor,
                        highlightColor: Theme.of(context).scaffoldBackgroundColor,
                        child: ListView.builder(
                          itemCount: 8,
                            itemBuilder: (c,i) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                color: Theme.of(context).cardColor,
                                padding: EdgeInsets.only(top: Dimensions.h_10,bottom: Dimensions.h_10),
                                child: Row(
                                  children: [
                                    TradeBitContainer(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Theme.of(context).scaffoldBackgroundColor,
                                      ),
                                      width: Dimensions.h_20,
                                      height: Dimensions.h_20,
                                    ),
                                    HorizontalSpacing(width: Dimensions.w_10),
                                    Expanded(
                                      child: TradeBitContainer(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(Dimensions.h_4),
                                          color: Theme.of(context).scaffoldBackgroundColor,
                                        ),
                                        height: Dimensions.h_20,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                            })
                    ): ListWidget(controller: controller, listData: LocalStorage.getListCrypto()),
                          controller.isLoading ? Shimmer.fromColors(
                              baseColor: Theme.of(context).cardColor,
                              highlightColor: Theme.of(context).scaffoldBackgroundColor,
                              child: ListView.builder(
                                  itemCount: 8,
                                  itemBuilder: (c,i) {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
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
                          ): ListWidget(controller: controller, listData: LocalStorage.getListBtc()),
                          controller.isLoading ? Shimmer.fromColors(
                              baseColor: Theme.of(context).cardColor,
                              highlightColor: Theme.of(context).scaffoldBackgroundColor,
                              child: ListView.builder(
                                  itemCount: 8,
                                  itemBuilder: (c,i) {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
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
                          ):  ListWidget(controller: controller, listData: LocalStorage.getListEth()),
                          controller.isLoading ? Shimmer.fromColors(
                              baseColor: Theme.of(context).cardColor,
                              highlightColor: Theme.of(context).scaffoldBackgroundColor,
                              child: ListView.builder(
                                  itemCount: 8,
                                  itemBuilder: (c,i) {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
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
                          ): ListWidget(controller: controller, listData: LocalStorage.getListTbc()),
                          controller.isLoading ?
                          Shimmer.fromColors(
                              baseColor: Theme.of(context).cardColor,
                              highlightColor: Theme.of(context).scaffoldBackgroundColor,
                              child: ListView.builder(
                                  itemCount: 8,
                                  itemBuilder: (c,i) {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          TradeBitContainer(
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Theme.of(context).cardColor,
                                            ),
                                            width: Dimensions.h_50,
                                            height: Dimensions.h_50,
                                          ),
                                          HorizontalSpacing(width: Dimensions.w_10),
                                          Expanded(
                                            child: TradeBitContainer(
                                              padding: EdgeInsets.only(top: Dimensions.h_10,bottom: Dimensions.h_10),
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
                              : ListWidget(controller: controller, listData: LocalStorage.getListTrx()),

                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ));
        },

    );
  }

}


OpenOrderResponse openOrderResponseFromJson(String str) => OpenOrderResponse.fromJson(json.decode(str));

class OpenOrderResponse {
  final String? openOrderResponseE;
  final int? e;
  final String? s;
  final String? openOrderResponseP;
  final String? p;
  final String? w;
  final String? x;
  final String? openOrderResponseC;
  final dynamic q;
  final String? openOrderResponseB;
  final String? b;
  final String? openOrderResponseA;
  final String? a;
  final String? openOrderResponseO;
  final String? h;
  final String? openOrderResponseL;
  final dynamic v;
  final dynamic openOrderResponseQ;
  final int? o;
  final int? c;
  final int? f;
  final int? l;
  final int? n;

  OpenOrderResponse({
    this.openOrderResponseE,
    this.e,
    this.s,
    this.openOrderResponseP,
    this.p,
    this.w,
    this.x,
    this.openOrderResponseC,
    this.q,
    this.openOrderResponseB,
    this.b,
    this.openOrderResponseA,
    this.a,
    this.openOrderResponseO,
    this.h,
    this.openOrderResponseL,
    this.v,
    this.openOrderResponseQ,
    this.o,
    this.c,
    this.f,
    this.l,
    this.n,
  });

  factory OpenOrderResponse.fromJson(Map<String, dynamic> json) => OpenOrderResponse(
    openOrderResponseE: json["e"],
    e: json["E"],
    s: json["s"],
    openOrderResponseP: json["p"],
    p: json["P"],
    w: json["w"],
    x: json["x"],
    openOrderResponseC: json["c"],
    q: json["Q"],
    openOrderResponseB: json["b"],
    b: json["B"],
    openOrderResponseA: json["a"],
    a: json["A"],
    openOrderResponseO: json["o"],
    h: json["h"],
    openOrderResponseL: json["l"],
    v: json["v"],
    openOrderResponseQ: json["q"],
    o: json["O"],
    c: json["C"],
    f: json["F"],
    l: json["L"],
    n: json["n"],
  );
}


