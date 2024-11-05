import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remove_emoji_input_formatter/remove_emoji_input_formatter.dart';
import 'package:tradebit_app/Presentation/Auth/login/login.dart';
import 'package:tradebit_app/Presentation/dashboard/dashboard.dart';
import 'package:tradebit_app/Presentation/exchange/ask_bids.dart';
import 'package:tradebit_app/Presentation/exchange/chart_screen.dart';
import 'package:tradebit_app/Presentation/exchange/exhange_controller.dart';
import 'package:tradebit_app/Presentation/exchange/open_orders.dart';
import 'package:tradebit_app/Presentation/exchange/order_history.dart';
import 'package:tradebit_app/constants/appcolor.dart';
import 'package:tradebit_app/constants/apptextstyle.dart';
import 'package:tradebit_app/constants/constants.dart';
import 'package:tradebit_app/constants/fontsize.dart';
import 'package:tradebit_app/Presentation/exchange/exchange_drawer.dart';
import 'package:tradebit_app/data/datasource/local/local_storage.dart';
import 'package:tradebit_app/widgets/spacing.dart';
import 'package:tradebit_app/widgets/tradeBit_scaffold.dart';
import 'package:tradebit_app/widgets/trade_bit_container.dart';
import 'package:tradebit_app/widgets/tradebit_text.dart';
import 'package:tradebit_app/widgets/tradebit_textbutton.dart';

import '../Market/market.dart';


class Exchange extends StatefulWidget {
   const Exchange({Key? key}) : super(key: key);

  @override
  State<Exchange> createState() => ExchangeState();
}

class ExchangeState extends State<Exchange> {
   final ExchangeController _exchangeController = Get.put(ExchangeController());

   var sKey = GlobalKey<ScaffoldState>();
   List<String> types = [
     'Open Orders',
     "Order History"
   ];

   @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        get();
      }
    });

   }

   get() async {
     LocalStorage.getBool(GetXStorageConstants.firstTime) == false ? _exchangeController.connectMarketTrade() : null;
     LocalStorage.getBool(GetXStorageConstants.firstTime) == false ? _exchangeController.getChartData() : null;
     LocalStorage.getBool(GetXStorageConstants.firstTime) == false ? _exchangeController.connectChart() : null ;
     _exchangeController.amountController.text = double.parse(LocalStorage.getBool(GetXStorageConstants.firstTime) == true ? LocalStorage.getListCrypto()[0].price ?? '0.0' : LocalStorage.getString(GetXStorageConstants.price)).toStringAsFixed(2);
     _exchangeController.marketController.text = '0.0';
     LocalStorage.getBool(GetXStorageConstants.firstTime) == false ?  _exchangeController.bidsAndAsks(context) : null;
     LocalStorage.getBool(GetXStorageConstants.firstTime) == false ? _exchangeController.connect() : null;
     LocalStorage.getBool(GetXStorageConstants.firstTime) == false ? _exchangeController.connectToSocketNew() : null;
     LocalStorage.getBool(GetXStorageConstants.firstTime) == false ? _exchangeController.getMarketTrades() : null;
     LocalStorage.getBool(GetXStorageConstants.userLogin) == true ? null : _exchangeController.getWallet(Get.context!);
     LocalStorage.getBool(GetXStorageConstants.userLogin) == true ? null : _exchangeController.orderHistory(Get.context!);
     LocalStorage.getBool(GetXStorageConstants.userLogin) == true ? null : _exchangeController.openOrder(Get.context!);
   }

  @override
  Widget build(BuildContext context) {
    return  GetBuilder(
      id: ControllerBuilders.exchangeController,
      init: _exchangeController,
      builder: (controller) {
        return TradeBitContainer(
          decoration: BoxDecoration(color: Theme.of(context).cardColor),
          child: SafeArea(
            child: TradeBitScaffold(
              key: sKey,
              backgroundColor: Theme.of(context).cardColor,
              drawer: ExchangeDrawer(controller: _exchangeController),
              body: GestureDetector(
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                child: Padding(
                  padding: EdgeInsets.only(left: Dimensions.w_8,right: Dimensions.w_8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      VerticalSpacing(height: Dimensions.h_20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                                  Builder(
                                    builder: (BuildContext context) {
                                      return GestureDetector(
                                          onTap: () {
                                            Scaffold.of(context).openDrawer();
                                          },
                                          child: const Icon(Icons.menu));
                                    },
                                  ),
                              HorizontalSpacing(width: Dimensions.w_5),
                              TradeBitTextWidget(title: LocalStorage.getBool(GetXStorageConstants.firstTime) == true ? 'BTCUSDT' : LocalStorage.getString(GetXStorageConstants.symbol) ?? "- - -", style: AppTextStyle.normalTextStyle(
                                FontSize.sp_20,Theme.of(context).highlightColor,
                              )),
                              HorizontalSpacing(width: Dimensions.w_5),
                              StreamBuilder(
                                stream: controller.streamControllerMarket.stream,
                                builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                                  if(snapshot.connectionState == ConnectionState.active && snapshot.hasData && snapshot.data.toString().contains('e')) {
                                    final data = openOrderResponseFromJson(snapshot.data);
                                    final data2 = listedResponseFromJson(snapshot.data);
                                    controller.change24 = double.parse(LocalStorage.getBool(GetXStorageConstants.listed)== true ? data2.p ?? '0.0' :data.p ?? '0.0');
                                    return  TradeBitTextWidget(title: "${controller.change24?.toStringAsFixed(2) ?? (LocalStorage.getBool(GetXStorageConstants.firstTime) == true ? controller.usdt.change ?? '0.0' : LocalStorage.getString(GetXStorageConstants.change).isNotEmpty ? LocalStorage.getString(GetXStorageConstants.change) : '0.0')}%", style: AppTextStyle.themeBoldNormalTextStyle(
                                        fontSize: FontSize.sp_15,
                                        color:  double.parse(controller.change24.toString() ?? '') <
                                            0
                                            ? Colors.redAccent
                                            : const Color(0xFF00C087)
                                    ));
                                  }
                                  return TradeBitTextWidget(title: "${double.parse( LocalStorage.getBool(GetXStorageConstants.firstTime) == true ? controller.usdt.change ?? '0.0' : LocalStorage.getString(GetXStorageConstants.change).isNotEmpty ? LocalStorage.getString(GetXStorageConstants.change) : '0.0').toStringAsFixed(2)}%", style: AppTextStyle.themeBoldNormalTextStyle(
                                      fontSize: FontSize.sp_15,
                                      color: LocalStorage.getBool(GetXStorageConstants.firstTime) == true ? (controller.usdt.change?.startsWith('-') ?? false ? AppColor.redButton : const Color(0xFF00C087))
                                          : ((LocalStorage.getString(GetXStorageConstants.change)).startsWith('-') ? AppColor.redButton : const Color(0xFF00C087))
                                  ));
                                },

                              ),
                            ],
                          ),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  pushWithSlideTransition(context, ChartScreen(exchangeController: controller));

                                },
                                  child: const Icon(Icons.candlestick_chart_rounded)),
                              HorizontalSpacing(width: Dimensions.w_6),
                              GestureDetector(
                                onTap: () {
                                  controller.showPopupMenu(context);
                                },
                                  child: const Icon(Icons.more_horiz)),
                            ],
                          )
                        ],
                      ),
                      VerticalSpacing(height: Dimensions.h_10),
                      Row(
                        children: [
                          TradeBitContainer(
                            height: controller.selectedValue == "Stop Limit" ? Dimensions.h_350 : Dimensions.h_330,
                            width: MediaQuery.of(context).size.width / 2,
                            child:  Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                            controller.onBuyTapped();
                                        },
                                        child: TradeBitContainer(
                                          height: Dimensions.h_25,
                                          decoration:  BoxDecoration(
                                            borderRadius: const BorderRadius.only(
                                             topLeft: Radius.circular(6),
                                             bottomLeft: Radius.circular(6)
                                            ),
                                            color: controller.isBuyTapped ? AppColor.green : Theme.of(context).scaffoldBackgroundColor,
                                          ),
                                          child: Center(child: TradeBitTextWidget(title: 'Buy', style: AppTextStyle.normalTextStyle(
                                              FontSize.sp_15,controller.isBuyTapped ? AppColor.white : Theme.of(context).shadowColor
                                          ))),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                         controller.onSellTapped();
                                         },
                                        child: TradeBitContainer(
                                          height: Dimensions.h_25,
                                          decoration:  BoxDecoration(
                                            borderRadius: const BorderRadius.only(
                                                topRight: Radius.circular(6),
                                                bottomRight: Radius.circular(6)
                                            ),
                                            color: controller.isSellTapped ? AppColor.redButton : Theme.of(context).scaffoldBackgroundColor,
                                          ),
                                          child: Center(child: TradeBitTextWidget(title: 'Sell', style: AppTextStyle.normalTextStyle(
                                              FontSize.sp_15 , controller.isSellTapped ? AppColor.white : Theme.of(context).shadowColor
                                          ))),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                VerticalSpacing(height: Dimensions.h_10),
                                TradeBitContainer(
                                  height: Dimensions.h_25,
                                  padding: EdgeInsets.only(left: Dimensions.w_10,right: Dimensions.w_10),
                                  decoration:  BoxDecoration(
                                      color: Theme.of(context).scaffoldBackgroundColor,
                                      border: Border.all(color: Theme.of(context).shadowColor.withOpacity(0.2)),
                                      borderRadius: BorderRadius.circular(4)
                                  ),
                                  width: double.infinity,
                                  child: DropdownButton<String>(
                                    style: AppTextStyle.normalTextStyle(FontSize.sp_12, Theme.of(context).highlightColor),
                                    iconSize: 20,
                                    itemHeight: 50,
                                    focusColor: AppColor.blue,
                                    padding: EdgeInsets.zero,
                                    elevation: 0,
                                    borderRadius: BorderRadius.circular(10),
                                    underline: const SizedBox(),
                                    isExpanded: true,
                                    dropdownColor: Theme.of(context).scaffoldBackgroundColor,
                                    value: controller.selectedValue,
                                    items:  [
                                      DropdownMenuItem(
                                        value: 'Limit',
                                        child: TradeBitTextWidget(title: 'Limit',style: AppTextStyle.normalTextStyle(FontSize.sp_12, Theme.of(context).highlightColor),),
                                      ),
                                      DropdownMenuItem(
                                        value: 'Market',
                                        child: TradeBitTextWidget(title: 'Market',style: AppTextStyle.normalTextStyle(FontSize.sp_12, Theme.of(context).highlightColor),),
                                      ),
                                      DropdownMenuItem(
                                        value: 'Stop Limit',
                                        child: TradeBitTextWidget(title: 'Stop Limit',style: AppTextStyle.normalTextStyle(FontSize.sp_12, Theme.of(context).highlightColor),),
                                      ),
                                    ],
                                    onChanged: (String? newValue) {
                                      controller.onDropDownHit(newValue ?? '');
                                    },
                                  ),
                                ),
                                VerticalSpacing(height: Dimensions.h_10),
                                Visibility(
                                  visible: controller.selectedValue == "Limit",
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 2.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            TradeBitTextWidget(title: 'Price', style: AppTextStyle.normalTextStyle(
                                                FontSize.sp_12,
                                                Theme.of(context).shadowColor
                                            )),
                                            TradeBitTextWidget(title: LocalStorage.getBool(GetXStorageConstants.firstTime) == true ? "USDT" : LocalStorage.getString(GetXStorageConstants.pair) ?? '--', style: AppTextStyle.normalTextStyle(
                                                FontSize.sp_12,
                                                Theme.of(context).shadowColor
                                            )),
                                          ],
                                        ),
                                      ),
                                      VerticalSpacing(height: Dimensions.h_4),
                                      NumberTextField(controller: controller.amountController,
                                        onChanged: (e) {
                                          controller.onComplete(e);
                                        },),
                                      VerticalSpacing(height: Dimensions.h_10),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 2.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            TradeBitTextWidget(title: 'Amount', style: AppTextStyle.normalTextStyle(
                                                FontSize.sp_12,
                                                Theme.of(context).shadowColor
                                            )),
                                            TradeBitTextWidget(title: LocalStorage.getBool(GetXStorageConstants.firstTime) == true ? "BTC" : LocalStorage.getString(GetXStorageConstants.name) ?? '--', style: AppTextStyle.normalTextStyle(
                                                FontSize.sp_12,
                                                Theme.of(context).shadowColor
                                            )),
                                          ],
                                        ),
                                      ),
                                      VerticalSpacing(height: Dimensions.h_4),
                                      NumberTextField(controller: controller.quantityController,
                                        onChanged: (e) {
                                        controller.onComplete(e);
                                        },
                                       ),
                                      VerticalSpacing(height: Dimensions.h_5),
                                      VerticalSpacing(height: Dimensions.h_6),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 2.0),
                                        child: TradeBitTextWidget(title: 'Total', style: AppTextStyle.normalTextStyle(
                                            FontSize.sp_12,
                                            Theme.of(context).shadowColor
                                        )),
                                      ),
                                      VerticalSpacing(height: Dimensions.h_4),
                                      TradeBitContainer(
                                        margin: EdgeInsets.zero,
                                        decoration:  BoxDecoration(
                                            borderRadius: BorderRadius.circular(6),
                                            color: Theme.of(context).scaffoldBackgroundColor,
                                            border: Border.all(color: Theme.of(context).shadowColor.withOpacity(0.2))
                                        ),
                                        height: Dimensions.h_32,
                                        width: double.infinity,
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: TextField(
                                                style: AppTextStyle.normalTextStyle(FontSize.sp_14, Theme.of(context).highlightColor),
                                                cursorColor: Colors.grey,
                                                enabled: false,
                                                decoration: const InputDecoration(
                                                  enabledBorder: InputBorder.none,
                                                  contentPadding: EdgeInsets.only(bottom: 10,left: 8),
                                                  focusedBorder: InputBorder.none,
                                                  filled: true,
                                                  fillColor: Colors.transparent,
                                                  hintStyle: TextStyle(color: Colors.white),
                                                  border: InputBorder.none
                                                ),
                                                controller: controller.totalController,
                                                keyboardType: TextInputType.number,
                                                textAlign: TextAlign.start,
                                                onChanged: (value) {
                                                  setState(() {
                                                  });
                                                },
                                              ),
                                            ),
                                            TradeBitTextWidget(title: LocalStorage.getBool(GetXStorageConstants.firstTime) == true ? "USDT" : LocalStorage.getString(GetXStorageConstants.pair) ?? '--', style: AppTextStyle.normalTextStyle(FontSize.sp_12,Theme.of(context).highlightColor)),
                                            HorizontalSpacing(width: Dimensions.w_5)
                                          ],
                                        ),
                                      ),
                                      VerticalSpacing(height: Dimensions.h_10),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          TradeBitTextWidget(title: 'Available', style: AppTextStyle.normalTextStyle(FontSize.sp_12, Theme.of(context).shadowColor)),
                                          TradeBitTextWidget(title: controller.isBuyTapped ? "${double.parse(controller.symbolPrice ?? '0.0').toStringAsFixed(2)}  ${LocalStorage.getBool(GetXStorageConstants.firstTime) == true ? "USDT": LocalStorage.getString(GetXStorageConstants.pair)}" : "${double.parse(controller.wallet ?? '0.0').toStringAsFixed(2)}  ${LocalStorage.getBool(GetXStorageConstants.firstTime) == true ? "BTC": LocalStorage.getString(GetXStorageConstants.name).toUpperCase()}", style: AppTextStyle.normalTextStyle(FontSize.sp_11, AppColor.appColor)),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Visibility(
                                    visible: controller.selectedValue == 'Market',
                                    child:  Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        TradeBitTextWidget(title: 'Amount', style: AppTextStyle.normalTextStyle(
                                            FontSize.sp_12,
                                            Theme.of(context).shadowColor
                                        )),
                                        VerticalSpacing(height: Dimensions.h_5),
                                        NumberTextField(controller: controller.marketController),
                                        VerticalSpacing(height: Dimensions.h_10),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            TradeBitTextWidget(title: 'Available', style: AppTextStyle.normalTextStyle(FontSize.sp_12, Theme.of(context).shadowColor)),
                                            TradeBitTextWidget(title:  controller.isBuyTapped ? double.parse(controller.symbolPrice ?? '0.0').toStringAsFixed(2) : double.parse(controller.wallet ?? '0.0').toStringAsFixed(2) ,style: AppTextStyle.normalTextStyle(FontSize.sp_11, AppColor.appColor)),
                                          ],
                                        ),
                                      ],
                                    )),
                                Visibility(
                                  visible: controller.selectedValue == "Stop Limit",
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 2.0),
                                        child: TradeBitTextWidget(title: 'Stop', style: AppTextStyle.normalTextStyle(
                                            FontSize.sp_12,
                                            Theme.of(context).shadowColor
                                        )),
                                      ),
                                      VerticalSpacing(height: Dimensions.h_4),
                                      NumberTextField(controller: controller.stopController,
                                      ),
                                      VerticalSpacing(height: Dimensions.h_6),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 2.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            TradeBitTextWidget(title: 'Price', style: AppTextStyle.normalTextStyle(
                                                FontSize.sp_12,
                                                Theme.of(context).shadowColor
                                            )),
                                            TradeBitTextWidget(title: LocalStorage.getBool(GetXStorageConstants.firstTime) == true ? "BTC" : LocalStorage.getString(GetXStorageConstants.pair) ?? '--', style: AppTextStyle.normalTextStyle(
                                                FontSize.sp_12,
                                                Theme.of(context).shadowColor
                                            )),
                                          ],
                                        ),
                                      ),
                                      VerticalSpacing(height: Dimensions.h_4),
                                      NumberTextField(controller: controller.amountController,
                                        onChanged: (e) {
                                          controller.onComplete(e);
                                        },
                                      ),
                                      VerticalSpacing(height: Dimensions.h_5),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 2.0),
                                        child: TradeBitTextWidget(title: 'Amount', style: AppTextStyle.normalTextStyle(
                                            FontSize.sp_12,
                                            Theme.of(context).shadowColor
                                        )),
                                      ),
                                      VerticalSpacing(height: Dimensions.h_4),
                                      NumberTextField(controller: controller.quantityController,
                                        onChanged: (e) {
                                          controller.onComplete(e);
                                          },
                                        onEditingComplete: () {
                                        },),
                                      VerticalSpacing(height: Dimensions.h_8),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 2.0),
                                        child: TradeBitTextWidget(title: 'Total', style: AppTextStyle.normalTextStyle(
                                            FontSize.sp_12,
                                            Theme.of(context).shadowColor
                                        )),
                                      ),
                                      VerticalSpacing(height: Dimensions.h_4),
                                      TradeBitContainer(
                                        margin: EdgeInsets.zero,
                                        decoration:  BoxDecoration(
                                            borderRadius: BorderRadius.circular(6),
                                            color: Theme.of(context).scaffoldBackgroundColor,
                                            border: Border.all(color: Theme.of(context).shadowColor.withOpacity(0.2))
                                        ),
                                        height: Dimensions.h_30,
                                        width: double.infinity,
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: TextField(
                                                style: AppTextStyle.normalTextStyle(FontSize.sp_14, Theme.of(context).highlightColor),
                                                cursorColor: Colors.grey,
                                                decoration: const InputDecoration(
                                                  enabledBorder: UnderlineInputBorder(
                                                      borderSide: BorderSide(color: Colors.transparent)),
                                                  contentPadding: EdgeInsets.only(bottom: 10,left: 8),
                                                  focusedBorder: UnderlineInputBorder(
                                                      borderSide: BorderSide(color: Colors.transparent)),
                                                  filled: true,
                                                  fillColor: Colors.transparent,
                                                  hintStyle: TextStyle(color: Colors.white),
                                                  border: UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Colors.transparent
                                                      )
                                                  ),
                                                ),
                                                controller: controller.totalController,
                                                keyboardType: TextInputType.number,
                                                textAlign: TextAlign.start,
                                                onChanged: (value) {},
                                              ),
                                            ),
                                            TradeBitTextWidget(title: controller.firstTime ? "BTC" : controller.named ?? '--', style: AppTextStyle.normalTextStyle(FontSize.sp_12,Theme.of(context).highlightColor)),
                                            HorizontalSpacing(width: Dimensions.w_5)
                                          ],
                                        ),
                                      ),
                                      VerticalSpacing(height: Dimensions.h_4),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          TradeBitTextWidget(title: 'Available', style: AppTextStyle.normalTextStyle(FontSize.sp_12, Theme.of(context).shadowColor)),
                                          TradeBitTextWidget(title:  controller.isBuyTapped ? double.parse(controller.symbolPrice ?? '0.0').toStringAsFixed(2) : double.parse(controller.wallet ?? '0.0').toStringAsFixed(2) ,style: AppTextStyle.normalTextStyle(FontSize.sp_11, AppColor.appColor)),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                controller.selectedValue == "Stop Limit" ? VerticalSpacing(height: Dimensions.h_8) : VerticalSpacing(height: Dimensions.h_20),
                                LocalStorage.getBool(GetXStorageConstants.userLogin) == true ?
                                TradeBitTextButton(
                                  borderRadius: BorderRadius.circular(6),
                                  margin: EdgeInsets.zero,height: Dimensions.h_35,
                                    labelName: 'Login', onTap: (){
                                  pushReplacementWithSlideTransition(context,  const Login());
                                })
                                    : TradeBuyTextButton(
                                  onTap: () {
                                    controller.buttonLoading ? null : controller.buyAndSell(context,double.parse(LocalStorage.getBool(GetXStorageConstants.firstTime) == true ? _exchangeController.price.toString() : LocalStorage.getString(GetXStorageConstants.price)).toStringAsFixed(2));
                                } ,
                                  loading: controller.buttonLoading,margin: EdgeInsets.zero,height: Dimensions.h_35, isSelected: controller.isSelected,),
                              ],
                            ),
                          ),
                          TradeBitContainer(
                            padding: EdgeInsets.only(left: Dimensions.w_8,right: Dimensions.w_4),
                            height: Dimensions.h_370,
                            decoration: const BoxDecoration(
                            ),
                            width: MediaQuery.of(context).size.width / 2.2,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        TradeBitTextWidget(title: 'Amount', style: AppTextStyle.normalTextStyle(FontSize.sp_10, Theme.of(context).highlightColor)),
                                        TradeBitTextWidget(title: "(${LocalStorage.getBool(GetXStorageConstants.firstTime) == true ? 'BTC'  : LocalStorage.getString(GetXStorageConstants.name).toUpperCase() ?? '--'})", style: AppTextStyle.normalTextStyle(FontSize.sp_12, Theme.of(context).canvasColor)),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        TradeBitTextWidget(title: 'Price', style: AppTextStyle.normalTextStyle(FontSize.sp_10, Theme.of(context).highlightColor)),
                                        TradeBitTextWidget(title: "(${LocalStorage.getBool(GetXStorageConstants.firstTime) == true ? 'USDT' : LocalStorage.getString(GetXStorageConstants.pair).toUpperCase() ?? '--'})", style: AppTextStyle.normalTextStyle(FontSize.sp_12, Theme.of(context).canvasColor)),
                                      ],
                                    ),
                                  ],
                                ),
                                VerticalSpacing(height: Dimensions.h_8),
                                AskAndBids(exchangeController: controller),
                              ],
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: Dimensions.h_30,
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: types.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    controller.getIndex(index);
                                  },
                                  child: TradeBitContainer(
                                    padding: const EdgeInsets.only(bottom: 5,),
                                    margin: const EdgeInsets.only(left: 10, right: 1),
                                    decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                            color: controller.selectedCategoryIndex == index ? AppColor.appColor : AppColor.transparent,
                                            width: 1.5
                                          )
                                        ),
                                        color: AppColor.transparent),
                                    child: Center(
                                      child: Text(
                                          types[index],
                                          style: AppTextStyle.themeBoldNormalTextStyle(
                                              fontSize: controller.selectedCategoryIndex == index ? FontSize.sp_15 : FontSize.sp_13,
                                              color: controller.selectedCategoryIndex == index ?  Theme.of(context).highlightColor : Theme.of(context).shadowColor
                                          )
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                      Expanded(
                        child: TradeBitContainer(
                          width: Dimensions.deviceWidth,
                          decoration: const BoxDecoration(),
                          child: Column(
                            children: [
                              callPage(controller.selectedCategoryIndex, controller)
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )),
          ));
        },
    );
  }
}

Widget callPage(int index,ExchangeController controller) {
  switch (index) {
    case 0:
      return  Expanded(child: OpenOrder(controller: controller));

    case 1:
      return  Expanded(child: OrderHistory(controller: controller));

    default:
      return  OpenOrder(controller: controller);
  }
}

class NumberTextField extends StatefulWidget {
  final TextEditingController controller;
  final void Function(String)? onChanged;
  final void Function()? onEditingComplete;
  const NumberTextField({super.key,required this.controller,this.onChanged,this.onEditingComplete});

  @override
  NumberTextFieldState createState() => NumberTextFieldState();
}

class NumberTextFieldState extends State<NumberTextField> {
  @override
  Widget build(BuildContext context) {
    return TradeBitContainer(
      decoration:  BoxDecoration(
        border: Border.all(color: Theme.of(context).shadowColor.withOpacity(0.2)),
        borderRadius: BorderRadius.circular(6),
        color: Theme.of(context).scaffoldBackgroundColor
      ),
      height: Dimensions.h_30,
      width: double.infinity,
      child: Center(
        child: TextFormField(
          cursorColor: Colors.grey,
          inputFormatters: [RemoveEmojiInputFormatter()],
          style: AppTextStyle.normalTextStyle(FontSize.sp_14, Theme.of(context).highlightColor),
          decoration:  InputDecoration(
            enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent)),
            contentPadding: const EdgeInsets.only(bottom: 15,left: 8),
            focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent)),
            filled: true,
            fillColor: Colors.transparent,
            hintStyle: TextStyle(color: Theme.of(context).shadowColor),
            border: const UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.transparent)
            ),
          ),
          controller: widget.controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          textAlign: TextAlign.start,
          onChanged: widget.onChanged ?? (value) {},
          onEditingComplete: widget.onEditingComplete,
        ),
      ),
    );
  }

}

class BuyAmount {
  String number,value,price,percent;

  BuyAmount({
    required this.number,
    required this.price,
    required this.value,
    required this.percent
  });

}

class AmountSell {
  String number,value,price,percent;

  AmountSell({required this.number, required this.price, required this.value, required this.percent});
}


