import 'dart:async';
import 'dart:convert';
import 'dart:developer' as Log;
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supercharged/supercharged.dart';
import 'package:tradebit_app/Presentation/Wallet/deposit/deposit_screen.dart';
import 'package:tradebit_app/Presentation/Wallet/withdraw/withdraw_list.dart';
import 'package:tradebit_app/Presentation/dashboard/dashboard.dart';
import 'package:tradebit_app/Presentation/exchange/chart_screen.dart';
import 'package:tradebit_app/Presentation/exchange/exchange.dart';
import 'package:tradebit_app/Presentation/transfer/transfer.dart';
import 'package:tradebit_app/approutes.dart';
import 'package:tradebit_app/constants/appcolor.dart';
import 'package:tradebit_app/constants/apptextstyle.dart';
import 'package:tradebit_app/constants/constants.dart';
import 'package:tradebit_app/constants/fontsize.dart';
import 'package:tradebit_app/core/error/failures.dart';
import 'package:tradebit_app/data/datasource/Repository_impl/exchange_repository_imp.dart';
import 'package:tradebit_app/data/datasource/Repository_impl/home_repository.dart';
import 'package:tradebit_app/data/datasource/Repository_impl/wallet_repositoryImpl.dart';
import 'package:tradebit_app/data/datasource/local/local_storage.dart';
import 'package:tradebit_app/data/datasource/remote/models/request/buy_and_sell_request.dart';
import 'package:tradebit_app/data/datasource/remote/models/response/crypto_response.dart';
import 'package:tradebit_app/data/datasource/remote/models/response/open_order.dart';
import 'package:tradebit_app/data/datasource/remote/models/response/order_history.dart';
import 'package:tradebit_app/data/datasource/remote/services/apis.dart';
import 'package:tradebit_app/widgets/lib/entity/depth_entity.dart';
import 'package:tradebit_app/widgets/lib/entity/k_line_entity.dart';
import 'package:tradebit_app/widgets/lib/k_chart_widget.dart';
import 'package:tradebit_app/widgets/spacing.dart';
import 'package:tradebit_app/widgets/trade_bit_container.dart';
import 'package:tradebit_app/widgets/trade_bit_toast.dart';
import 'package:tradebit_app/widgets/tradebit_text.dart';
import 'package:tradebit_app/widgets/tradebit_textbutton.dart';
import 'package:web_socket_channel/io.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../data/datasource/remote/models/response/walletListResponse.dart';

class ExchangeController extends GetxController {
  final ExchangeRepositoryImpl _repository = ExchangeRepositoryImpl();
  final HomeRepositoryImpl _homeRepository = HomeRepositoryImpl();
  final WalletRepositoryImpl _walletRepositoryImpl = WalletRepositoryImpl();
  String selectedValue = 'Limit';
  bool switchValue = false;
  bool isBuyTapped = true;
  bool isSellTapped = false;
  String isSelected = 'Buy';
  bool loading = false;
  List <dynamic> newdata = [];
  bool orderBook = false;
  bool showTrades = true;
  bool cryptoLoading = false;
  bool shimmerLoading = false;
  bool buttonLoading = false;
  bool chartLoading = false;
  bool bidLoading = false;
  List<DepthEntity>? bidss;
  List<DepthEntity>? askss;
  List<OrderHistoryResponse>? orderHistoryList = [];
  List<Btc> cryptoList = [];
  Btc usdt = Btc();
  List<OpenOrder>? openOrderList = [];
  int selectedCategoryIndex = 0;
  int nextIndex = 0;
  bool firstTime = true;
  String? named;
  String? price;
  String? pair;
  String? changes;
  String? symbol;
  String? symbolPrice;
  List<KLineEntity> owndata = [];
  int epochtime = 1;
  double? change;
  double? showPrice;
  String intervalChart = '1m';
  double? current;
  bool buttonSelected = false;
  dynamic vol;
  dynamic qty;
  double? high;
  double? low;
   String wallet = '0.0';
  double? change24;
  List<AmountSell> othersellList = [];
  List<BuyAmount> anotherbuYlist = [];
  bool askBids = false;
  int currentIndex = 0;
  String? totalPrice;
  final List<String> tickers = [];
  final List<String> listedTickers = [];
  WebSocketChannel? channel;
  String availBal = '';
  final WalletRepositoryImpl walletRepositoryImpl = WalletRepositoryImpl();
  List<MarketTrade> trades = [];
  String? firstTimePrice;
  List<IntervalButton> buttonsList = [
    IntervalButton(title: '1m', time: 1),
    IntervalButton(title: '5m', time: 5),
    IntervalButton(title: '15m', time: 15),
    IntervalButton(title: '30m', time: 30),
    // IntervalButton(title: '1h', time: 60),
    IntervalButton(title: '1d', time: 1440),
  ];
  TextEditingController amountController = TextEditingController();
  TextEditingController marketController = TextEditingController();
  TextEditingController quantityController = TextEditingController(text: '0.0');
  TextEditingController totalController = TextEditingController(text: '0.0');
  TextEditingController stopController = TextEditingController(text: '0.0');
  int page = 1;
  bool firstTimeLoading = false;
  bool hasNextPage = true;
  bool isLoadMoreRunning = false;
  int currentPage = 1;
  bool isLine = false;
  MainState mainState = MainState.NONE;

  @override
  void onInit() async {
  super.onInit();
  bidsAndAsks(Get.context!);
  connect();
  getChartData();
  connectChart();
  connectToSocketNew();
  getMarketTrades();
  connectMarketTrade();
  LocalStorage.getBool(GetXStorageConstants.userLogin) == true ? null : getWallet(Get.context!);
  LocalStorage.getBool(GetXStorageConstants.userLogin) == true ? null : orderHistory(Get.context!);
  LocalStorage.getBool(GetXStorageConstants.userLogin) == true ? null : openOrder(Get.context!);
  }

getLine() {
    isLine =! isLine;
    selectedCategoryIndex = 0;
    update([ControllerBuilders.button]);
}



indicator() {
    mainState = MainState.MA;
    update([ControllerBuilders.button]);
}

showMarket() {
    showTrades = true;
    orderBook = false;
    update([ControllerBuilders.exchangeController]);
}

  showOrder() {
    showTrades = false;
    orderBook = true;
    update([ControllerBuilders.exchangeController]);
  }
  addPrice(String newPrice,String amount) {
    amountController.text = double.parse(newPrice).toStringAsFixed(2);
    quantityController.text = double.parse(amount).toStringAsFixed(5);
    double amountC = double.tryParse(amountController.text) ?? 0.0;
    double quantity = double.tryParse(quantityController.text) ?? 0.0;
    double total = amountC * quantity;
    String formattedTotal = total.toStringAsFixed(2);
    totalController.text = formattedTotal;
    totalPrice = totalController.text;
    update([ControllerBuilders.exchangeController]);
  }


  StreamController<String> streamController = StreamController.broadcast();
  StreamController<String> streamControllerMarket = StreamController.broadcast();
  StreamController<String> streamControllerBids = StreamController.broadcast();
  StreamController<String> streamControllerChart = StreamController.broadcast();
  StreamController<String> streamControllerTrade = StreamController.broadcast();


  WebSocketChannel? _webSocketChannel;
  WebSocketChannel? _marketChannel;
  WebSocketChannel? _bidsChannel;
  WebSocketChannel? _chartChannel;
  WebSocketChannel? _tradeChannel;

  void connectToSocketNew() {
    _marketChannel?.sink.close();
    var jsonString = json.encode({
      'method': "SUBSCRIBE",
      'params': ['${LocalStorage.getString(GetXStorageConstants.symbol).toLowerCase()}@ticker'],
      'id': 1,
    });

    var marketString = json.encode({
      'method': "SUBSCRIBE",
      'params': ['${LocalStorage.getBool(GetXStorageConstants.firstTime) ? 'btcusdt' : LocalStorage.getString(GetXStorageConstants.symbol).toLowerCase()}@ticker'],
      'id': 1,
    });

    WebSocketChannel channel = LocalStorage.getBool(GetXStorageConstants.listed) == true ? IOWebSocketChannel.connect(Apis.tbSocket) : IOWebSocketChannel.connect(Apis.binanceSocket);
    _marketChannel = channel;
    _marketChannel?.stream.listen((data) {
      streamControllerMarket.add(data);
    }, onError: (e) {
      print(e.toString());
    });

    LocalStorage.getBool(GetXStorageConstants.listed) == true ? _marketChannel?.sink.add(jsonString) : _marketChannel?.sink.add(marketString);
  }

  void connectToMarketSocketNew() {
    var subscribeMessage = json.encode({
      'method': "SUBSCRIBE",
      'params': LocalStorage.getListTickers(GetXStorageConstants.tickers).map((ticker) => '${ticker.toLowerCase()}@ticker').toList(),
      'id': 1,
    });

    _webSocketChannel = LocalStorage.getBool(GetXStorageConstants.listed) == true ? IOWebSocketChannel.connect(Apis.tbSocket):IOWebSocketChannel.connect(Apis.binanceSocket);

    _webSocketChannel?.stream.listen((data) {
      streamController.add(data);
    });

    _webSocketChannel?.sink.add(subscribeMessage);
  }


  cancelOrderDailog(BuildContext context, ExchangeController controller,int id) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
            child: AlertDialog(
              insetPadding: EdgeInsets.only(left: Dimensions.w_10,right: Dimensions.w_10),
              contentPadding: EdgeInsets.zero,
              content: TradeBitContainer(
                padding: EdgeInsets.only(
                  top: Dimensions.h_15,
                  bottom: Dimensions.h_10,
                  left: Dimensions.w_15,
                  right: Dimensions.w_15,
                ),
                margin: EdgeInsets.zero,
                decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(Dimensions.h_15)),
                child: GetBuilder(
                  init: controller,
                  id: ControllerBuilders.exchangeController,
                  builder: (controller) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TradeBitTextWidget(
                            title: 'Cancel ',
                            style: AppTextStyle
                                .themeBoldNormalTextStyle(
                                fontSize: FontSize.sp_16,
                                color: Theme.of(context).highlightColor)),
                        VerticalSpacing(height: Dimensions.h_10),
                        TradeBitTextWidget(
                            title: 'are your sure you want to cancel ?',
                            style: AppTextStyle
                                .normalTextStyle(
                                FontSize.sp_14,
                                Theme.of(context).shadowColor)),
                        VerticalSpacing(height: Dimensions.h_20),
                        Row(
                          children: [
                            Expanded(child: TradeBitTextButton(loading: controller.buttonLoading,borderRadius: BorderRadius.circular(Dimensions.h_5),height: Dimensions.h_30,margin: EdgeInsets.zero,labelName: 'Yes', onTap: () {
                              controller.buttonLoading ? null :  controller.cancelOrder(context, id);
                            },color: AppColor.appColor)),
                            HorizontalSpacing(width: Dimensions.w_10),
                            Expanded(child: TradeBitTextButton(borderRadius: BorderRadius.circular(Dimensions.h_5),height: Dimensions.h_30,margin: EdgeInsets.zero,labelName: 'NO', onTap: () {
                              Navigator.of(context).pop();
                            },color:Theme.of(context).scaffoldBackgroundColor)),
                          ],
                        ),
                        VerticalSpacing(height: Dimensions.h_10),
                      ],
                    );
                  },
                ),
              ),
            ),
          );
        });
    update([ControllerBuilders.homeController]);
  }

  cancelOrder(BuildContext context,int id) async {
    buttonLoading = true;
    update([ControllerBuilders.exchangeController]);

    var data = await _repository.cancelOrder(id);
    data.fold((l) {
      if (l is ServerFailure) {
        buttonLoading = false;
        update([ControllerBuilders.exchangeController]);
      }
    }, (r) async {
      String code = r.statusCode ?? '';
      String message = r.message ?? '';
      if (code == '1') {
        ToastUtils.showCustomToast(context, message, true);
        openOrder(Get.context!);
        await orderHistory(context);
        getWallet(Get.context!);
        buttonLoading = false;
        Navigator.pop(Get.context!);
        update([ControllerBuilders.exchangeController]);
      }
      else {
        ToastUtils.showCustomToast(context, message, false);
        buttonLoading = false;
        update([ControllerBuilders.exchangeController]);
      }
    });
    buttonLoading = false;
    update([ControllerBuilders.exchangeController]);
  }

  getWallet(BuildContext context) async {
    loading = true;
    var data = await _walletRepositoryImpl.wallet();
    data.fold((l) {
      if (l is ServerFailure) {
        if(LocalStorage.getBool(GetXStorageConstants.userLogin) == true) {
          if(l.message == 'Unauthenticated') {
            LocalStorage.writeBool(GetXStorageConstants.userLogin, true);
            Get.offAllNamed(AppRoutes.loginScreen);
          }
        }
        loading = false;
        ToastUtils.showCustomToast(context, l.message ?? '', false);
        update([ControllerBuilders.exchangeController]);
      }
    }, (r) {
      String code = r.statusCode ?? '';
      String message = r.message ?? '';
      if (code == '1') {
        for(var i in r.data ?? []) {
          if(LocalStorage.getBool(GetXStorageConstants.firstTime)== true ? "BTC" == i.symbol : LocalStorage.getString(GetXStorageConstants.name) == i.symbol) {
            wallet =  i.quantity;
            update([ControllerBuilders.exchangeController]);
          }
          if(LocalStorage.getBool(GetXStorageConstants.firstTime)==true ? 'USDT' == i.symbol : LocalStorage.getString(GetXStorageConstants.pair) == i.symbol) {
            symbolPrice = i.quantity;
            update([ControllerBuilders.exchangeController]);
          }
        }
        loading = false;
        update([ControllerBuilders.exchangeController]);
      } else {
        loading = false;
        ToastUtils.showCustomToast(context, message, false);
      }
    });
    update([ControllerBuilders.exchangeController]);
  }


  connect() async {
    _bidsChannel?.sink.close();
    var jsonString = json.encode({
      'method': "SUBSCRIBE",
      'params': ['${LocalStorage.getString(GetXStorageConstants.symbol).toLowerCase()}@depth'],
      'id': 3,
    });

    var marketString = json.encode({
      'method': "SUBSCRIBE",
      'params': ['${LocalStorage.getBool(GetXStorageConstants.firstTime) ? 'btcusdt' : LocalStorage.getString(GetXStorageConstants.symbol).toLowerCase()}@depth20'],
      'id': 3,
    });

    WebSocketChannel channel = LocalStorage.getBool(GetXStorageConstants.listed) == true ? IOWebSocketChannel.connect(Apis.tbSocket) : IOWebSocketChannel.connect(Apis.binanceSocket);
    _bidsChannel = channel;

    _bidsChannel?.stream.listen((data) {
          streamControllerBids.add(data);
        },
        onError: (e) {
          print(e.toString());
        },

    );

    LocalStorage.getBool(GetXStorageConstants.listed) == true ? _bidsChannel?.sink.add(jsonString) : _bidsChannel?.sink.add(marketString);
  }

  onComplete(String text ) {
      double amount = double.tryParse(text) ?? 0.0;
      double quantity = double.tryParse(amountController.text) ?? 0.0;
      double total = amount * quantity;
      String formattedTotal = total.toStringAsFixed(2);
      totalController.text = formattedTotal;
      totalPrice = totalController.text;
      update([ControllerBuilders.exchangeController]);
    }

  onIndex(int index) {
    currentIndex = index;
    update([ControllerBuilders.exchangeController]);
  }


  onInterval(String title,int time) async {
    intervalChart = title;
    epochtime = time;
    await getChartData();
    connectChart();
    update([ControllerBuilders.button]);
  }

  getIndex(int i) {
    selectedCategoryIndex = i;
    update([ControllerBuilders.exchangeController]);
  }

  onBuyTapped() {
    isBuyTapped = true;
    isSellTapped = false;
    isSelected = 'Buy';
    update([ControllerBuilders.exchangeController]);
  }

  onSellTapped() {
    isBuyTapped = false;
    isSellTapped = true;
    isSelected = 'Sell';
    update([ControllerBuilders.exchangeController]);
  }

  onDropDownHit(String value) {
    selectedValue = value;
    update([ControllerBuilders.exchangeController]);
  }

  void showPopupMenu(BuildContext context) async {
    await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(MediaQuery.sizeOf(context).width, Dimensions.h_80, 0, 0),
      items: [
         PopupMenuItem(
          value: 1,
          child: TradeBitTextWidget(title: 'Deposit', style: AppTextStyle.normalTextStyle(FontSize.sp_12, Theme.of(context).highlightColor)),
        ),
         PopupMenuItem(
          value: 2,
          child: TradeBitTextWidget(title: 'Withdraw', style: AppTextStyle.normalTextStyle(FontSize.sp_12, Theme.of(context).highlightColor)),
        ),
         PopupMenuItem(
          value: 3,
          child: TradeBitTextWidget(title: 'Transfer', style: AppTextStyle.normalTextStyle(FontSize.sp_12, Theme.of(context).highlightColor)),
        ),
      ],
      elevation: 0
    ).then((value){
      if(value == 1) {
        LocalStorage.writeBool(GetXStorageConstants.fromExchange, true);
        LocalStorage.writeBool(GetXStorageConstants.stakingDeposit, false);
        LocalStorage.writeBool(GetXStorageConstants.depositFromHome, false);
       LocalStorage.getBool(GetXStorageConstants.userLogin) == true ?
       Get.offAllNamed(AppRoutes.loginScreen)
      :  pushReplacementWithSlideTransition(context, const DepositScreen());
      }
      else if(value == 2) {
        LocalStorage.writeBool(GetXStorageConstants.fromExchange, true);
        LocalStorage.writeBool(GetXStorageConstants.withdrawFromHome, false);
        LocalStorage.getBool(GetXStorageConstants.userLogin) == true ? Get.offAllNamed(AppRoutes.loginScreen):
        pushReplacementWithSlideTransition(context, const WithdrawList());
      }
      else if(value == 3) {
        LocalStorage.writeBool(GetXStorageConstants.fromExchange, true);
        LocalStorage.getBool(GetXStorageConstants.userLogin) == true ? Get.offAllNamed(AppRoutes.loginScreen):
        pushReplacementWithSlideTransition(context, const Transfer());
      }
    });
  }

  drawer({
    required BuildContext context, required bool list}) async {
    amountController.text = double.parse(LocalStorage.getString(GetXStorageConstants.price)).toStringAsFixed(2);
    quantityController.text = '0.0';
    totalController.text = '0.0';
    totalPrice = '0.0';
    bidsAndAsks(context);
    getWallet(context);
    connect();
    connectToSocketNew();
    getMarketTrades();
    connectMarketTrade();
    getChartData();
    connectChart();
    Navigator.pop(context);
    update([ControllerBuilders.exchangeController]);
  }

  Future<void> connectMarketTrade() async {
    _tradeChannel?.sink.close();
    var jsonString = json.encode({
      'method': "SUBSCRIBE",
      'params': ["${LocalStorage.getString(GetXStorageConstants.symbol).toLowerCase()}@trade"],
      'id': 3,
    });

    var marketString = json.encode({
      'method': "SUBSCRIBE",
      'params': ["${LocalStorage.getBool(GetXStorageConstants.firstTime) == true ? "btcusdt" : LocalStorage.getString(GetXStorageConstants.symbol).toLowerCase()}@trade"],
      'id': 3,
    });

    WebSocketChannel channel = LocalStorage.getBool(GetXStorageConstants.listed) == true ? IOWebSocketChannel.connect(Apis.tbSocket) : IOWebSocketChannel.connect(Apis.binanceSocket);
    _tradeChannel = channel;
    _tradeChannel?.stream.listen((data) {
      streamControllerTrade.add(data);
    }, onError: (e) {
      print(e.toString());
    });

    LocalStorage.getBool(GetXStorageConstants.listed) == true ? _tradeChannel?.sink.add(jsonString) : _tradeChannel?.sink.add(marketString);

  }


   connectChart() async {
    _chartChannel?.sink.close();

    var marketString = json.encode({
      'method': "SUBSCRIBE",
      'params': ["${LocalStorage.getBool(GetXStorageConstants.firstTime) == true
          ? "btcusdt" : LocalStorage.getString(GetXStorageConstants.symbol).toLowerCase()}${LocalStorage.getBool(GetXStorageConstants.listed) == true ? "@kline" : "@kline${"_$intervalChart"}" }"],
      'id': 3,
    });

    WebSocketChannel channel = LocalStorage.getBool(GetXStorageConstants.listed) == true ? IOWebSocketChannel.connect(Apis.tbSocket) : IOWebSocketChannel.connect(Apis.binanceSocket);
    _chartChannel = channel;
    _chartChannel?.stream.listen((data) {
      streamControllerChart.add(data);
    }, onError: (e) {
      print(e.toString());
    });
    _chartChannel?.sink.add(marketString);
  }

  bool hasMoreData = true;
  bool hasMoreDataOrder = true;
  bool isLoadingMore = false;
  bool isLoadingMoreORder = false;

   int orderPage = 1 ;

  orderHistory(BuildContext context) async {
    if (currentPage == 1) {
      shimmer = true;
      update([ControllerBuilders.exchangeController]);
    }
    shimmer = true;
    var data = await _repository.orderHistory(currentPage);
    data.fold((l) {
      if (l is ServerFailure) {
        shimmer = false;
        update([ControllerBuilders.exchangeController]);
      }
    }, (r) {
      String code = r.statusCode?? '';
      if (code == '1') {
        shimmer = false;
        if (currentPage == 1) {
          orderHistoryList?.clear();
        }
        orderHistoryList?.addAll(r.data?.data?? []);
        update([ControllerBuilders.exchangeController]);
        if ((r.data?.data?.length ?? 0) < 10) {
          hasMoreData = false;
        }
      } else {
        shimmer = false;
        update([ControllerBuilders.exchangeController]);
      }
    });
    update([ControllerBuilders.exchangeController]);
  }

  bool shimmer = false;
  bool loadMoreData = false;
  bool loadMoreDataOrder = false;

  loadMore(BuildContext context) async {
    if (loadMoreData || !hasMoreData) return;
    loadMoreData = true;
    update([ControllerBuilders.exchangeController]);
    await orderHistory(context);
    currentPage++;
    loadMoreData = false;
    update([ControllerBuilders.exchangeController]);
  }

  loadMoreOrder(BuildContext context) async {
    if (loadMoreDataOrder || !hasMoreDataOrder) return;
    loadMoreDataOrder = true;
    update([ControllerBuilders.exchangeController]);
    await openOrder(context);
    orderPage ++ ;
    loadMoreDataOrder = false;
    update([ControllerBuilders.exchangeController]);
  }

  openOrder(BuildContext context) async {
    if (orderPage == 1) {
      shimmerLoading = true;
      update([ControllerBuilders.exchangeController]);
    }
    var data = await _repository.openOrders(orderPage);
    data.fold((l) {
      if (l is ServerFailure) {
        if(LocalStorage.getBool(GetXStorageConstants.userLogin) == true) {
          if(l.message == 'Unauthenticated') {
            LocalStorage.writeBool(GetXStorageConstants.userLogin, true);
            Get.offAllNamed(AppRoutes.loginScreen);
          }
        }
        shimmerLoading = false;
        update([ControllerBuilders.exchangeController]);
      }
    }, (r) {
      String code = r.statusCode ?? '';
      if (code == '1') {
        if (orderPage == 1) {
          openOrderList?.clear();
        }
        openOrderList?.addAll(r.data.data?? []);
        shimmerLoading = false;
        update([ControllerBuilders.exchangeController]);
        if ((r.data.data.length ?? 0) < 10) {
          hasMoreDataOrder = false;
        }
      } else {
        shimmerLoading = false;
        update([ControllerBuilders.exchangeController]);
      }
    });
    update([ControllerBuilders.exchangeController]);
  }

  buyAndSell(BuildContext context,String price) async {
    if(quantityController.text.isEmpty || quantityController.text == '0.0') {
      ToastUtils.showCustomToast(context, 'please enter amount', false);
      return;
    }
    double enteredAmount = double.parse(isBuyTapped ? totalController.text : amountController.text);
    double availableAmount = double.parse(isSellTapped ? wallet : symbolPrice ?? '0.0');
    if (enteredAmount > availableAmount) {
      ToastUtils.showCustomToast(context, 'Not enough balance', false);
      return;
    }
    buttonLoading = true;
    update([ControllerBuilders.exchangeController]);
    final request = BuyAndSellRequest(
        atPrice: selectedValue == 'Market' ? marketController.text.toDouble() :amountController.text.toDouble(),
        currency: LocalStorage.getBool(GetXStorageConstants.firstTime) == true ? cryptoList[0].currency : LocalStorage.getString(GetXStorageConstants.name),
        orderType: isSelected.toLowerCase(),
        quantity: quantityController.text.toDouble(),
        stopPrice: stopController.text.toDouble() ?? 0,
        total: double.parse(totalPrice ?? '0'),
        type: selectedValue == 'Stop Limit' ? 'stop_limit' : selectedValue.toLowerCase(),
        withCurrency:  LocalStorage.getBool(GetXStorageConstants.firstTime) == true ? cryptoList[0].pairWith : LocalStorage.getString(GetXStorageConstants.pair)
    );
    var data = await _repository.buyAndSell(request);
    data.fold((l) {
      if (l is ServerFailure) {
        if(LocalStorage.getBool(GetXStorageConstants.userLogin) == true) {
          if(l.message == 'Unauthenticated') {
            LocalStorage.writeBool(GetXStorageConstants.userLogin, true);
            Get.offAllNamed(AppRoutes.loginScreen);
          }
        }
        buttonLoading = false;
        ToastUtils.showCustomToast(context, l.message ?? '', false);
        update([ControllerBuilders.exchangeController]);
      }
    }, (r) async {
      String code = r.statusCode ?? '';
      String message = r.message ?? '';
      if (code == '1') {
        ToastUtils.showCustomToast(context, message, true);
        buttonLoading = false;
        amountController.text = price;
        quantityController.text = '0.0';
        totalController.text = '0.0';
        await openOrder(context);
        await orderHistory(context);
        getWallet(context);
        update([ControllerBuilders.exchangeController]);
      }
      else {
        ToastUtils.showCustomToast(context, message, false);
        buttonLoading = false;
        update([ControllerBuilders.exchangeController]);
      }
    });
    buttonLoading = false;
    update([ControllerBuilders.exchangeController]);
  }

  Future<void> bidsAndAsks(BuildContext context) async {
    bidLoading = true;
    var data = await _repository.bidsAndAsks(
        LocalStorage.getBool(GetXStorageConstants.firstTime) == true ? "BTC" :
        LocalStorage.getString(GetXStorageConstants.name).toUpperCase() ?? '',
        LocalStorage.getBool(GetXStorageConstants.firstTime) ? 'USDT' :
        LocalStorage.getString(GetXStorageConstants.pair).toUpperCase() ?? '');

    data.fold(
          (l) {
        if(l is ServerFailure) {
          bidLoading = false;
          ToastUtils.showCustomToast(context, l.message ?? '', false);
          update([ControllerBuilders.exchangeController]);
        }

      },
          (r) async {
        String code = r.statusCode ?? '';
        if (code == '1') {
          othersellList.clear();
          bidss ??= [];
          askss ??= [];

          for (var i in r.data?.asks ?? []) {
            othersellList.add(AmountSell(number: '', price: i[0], value: i[1], percent: ''));
            askss!.add(DepthEntity(double.parse(i[0]), double.parse(i[1])));
          }

          anotherbuYlist.clear();
          for (var i in r.data?.bids ?? []) {
            anotherbuYlist.add(BuyAmount(number: '', price: i[0], value: i[1], percent: ''));
            bidss!.add(DepthEntity(double.parse(i[0]), double.parse(i[1])));
          }

          Log.log('askssss${askss.toString()}');
          Log.log('bidsss${bidss.toString()}');
          String highestBid = r.data?.bids?[0][0] ?? '';
          String lowestAsk = r.data?.asks?[0][0] ?? '';
          double newBid = (double.parse(highestBid) + double.parse(lowestAsk)) / 2;
          LocalStorage.writeString(GetXStorageConstants.bidsPrice, newBid.toString().isNotEmpty ? newBid.toString() : '0.0');
          bidLoading = false;
          update([ControllerBuilders.exchangeController]);
        } else {
          bidLoading = false;
          update([ControllerBuilders.exchangeController]);
        }
      },
    );

    update([ControllerBuilders.exchangeController]);
  }




  getMarketTrades() async {
    var url = LocalStorage.getString(GetXStorageConstants.symbol) == 'MCOINUSDT' ? Uri.parse('https://node.tradebit.io/orders/trade-book?currency=MCOIN&with_currency=USDT'):Uri.parse('${Apis.nodeUrl}/list-crypto/trade-history/${LocalStorage.getBool(GetXStorageConstants.firstTime) == true ? 'BTCUSDT' : LocalStorage.getString(GetXStorageConstants.symbol)}?limit=50');
    print('================>$url');
    var res = await http.get(url);
    if (res.statusCode == 200) {
      var data = jsonDecode(res.body);
      Log.log(data.toString());
      if(trades.isNotEmpty) {
        trades.clear();
      }
      for (var i in data['data'] ?? []) {
        trades.add(MarketTrade(
            price: i['p'].toString(),
            date: i['T'].toString(),
            quantity: i['q'].toString(),
            type: i['m']));
        update([ControllerBuilders.exchangeController]);
      }
    }
    else {
      print(res.statusCode);
    }
  }


  void updateCandlesFromSnapshot(AsyncSnapshot<Object?> snapshot) {
    if (owndata.isNotEmpty) {
      if (snapshot.data != null) {
        final data = jsonDecode(snapshot.data as String) as Map<String, dynamic>;
        if (data.containsKey("k") && data["k"] != null) {
          final kData = data["k"] as Map<String, dynamic>;

          if (kData.containsKey("t") && kData["t"] != null) {
            final tValue = kData["t"];
              if (tValue - owndata[owndata.length - 1].time >= epochtime * 60000) {
                owndata.add(KLineEntity.fromCustom(
                  time: tValue,
                  close: double.parse(kData["c"].toString()),
                  high: double.parse(kData["h"].toString()),
                  low: double.parse(kData["l"].toString()),
                  open: LocalStorage.getBool(GetXStorageConstants.listed) == true ? owndata[owndata.length - 1].close : double.parse(kData["o"].toString()),
                  vol: double.parse(kData["v"].toString()),
                ));
              } else {
               LocalStorage.getBool(GetXStorageConstants.listed) == false ?  owndata[owndata.length - 1].open =
                    double.parse(kData["o"].toString()) : null;
                owndata[owndata.length - 1].close =
                    double.parse(kData["c"].toString());
                owndata[owndata.length - 1].high =
                    double.parse(kData["h"].toString());
                owndata[owndata.length - 1].low =
                    double.parse(kData["l"].toString());
                owndata[owndata.length - 1].vol =
                    double.parse(kData["v"].toString());
              }
            }
          }
          DataUtil.calculate(owndata);
        }
      }
    }



  getChartData() async {
    chartLoading = true;
    var url = Uri.parse("${Apis.chart}${LocalStorage.getBool(GetXStorageConstants.firstTime) == true ? 'BTCUSDT' : LocalStorage.getString(GetXStorageConstants.symbol).toUpperCase()}&interval=$intervalChart");
    print(url);
    var data = await http.get(url);
    try {
      if(data.statusCode == 200) {
        owndata.clear();
        var res = jsonDecode(data.body);
        int j = 0;
        var prev;
        for(var i in res['data']) {
          if(LocalStorage.getBool(GetXStorageConstants.listed) == true) {
            if( j >0) {
              vol = double.parse(i['ohlc']['v'].toString());
              qty =
              LocalStorage.getBool(GetXStorageConstants.listed) == true ? double
                  .parse(i['ohlc']['o'].toString()) : i['ohlc']['o'].toDouble();
              low =
              LocalStorage.getBool(GetXStorageConstants.listed) == true ? double
                  .parse(i['ohlc']['l'].toString()) : i['ohlc']['l'].toDouble();
              high =
              LocalStorage.getBool(GetXStorageConstants.listed) == true ? double
                  .parse(i['ohlc']['h'].toString()) : i['ohlc']['h'].toDouble();
              owndata.add(KLineEntity.fromCustom(
                  high: LocalStorage.getBool(GetXStorageConstants.listed) == true
                      ? double.parse(i['ohlc']['h'].toString())
                      : i['ohlc']['h'].toDouble(),
                  low: LocalStorage.getBool(GetXStorageConstants.listed) == true
                      ? double.parse(i['ohlc']['l'].toString())
                      : i['ohlc']['l'].toDouble(),
                  open: LocalStorage.getBool(GetXStorageConstants.listed) == true
                      ? prev : i['ohlc']['o'].toDouble(),
                  close: LocalStorage.getBool(GetXStorageConstants.listed) == true
                      ? double.parse(i['ohlc']['c'].toString())
                      : i['ohlc']['c'].toDouble(),
                  time: i['start_time'].toInt(),
                  vol: double.parse(i['ohlc']['v'].toString())
              ));
            }
            else{
              vol = double.parse(i['ohlc']['v'].toString());
              qty = LocalStorage.getBool(GetXStorageConstants.listed) == true ? double
                  .parse(i['ohlc']['o'].toString()) : i['ohlc']['o'].toDouble();
              low = LocalStorage.getBool(GetXStorageConstants.listed) == true ? double
                  .parse(i['ohlc']['l'].toString()) : i['ohlc']['l'].toDouble();
              high = LocalStorage.getBool(GetXStorageConstants.listed) == true ? double
                  .parse(i['ohlc']['h'].toString()) : i['ohlc']['h'].toDouble();
              owndata.add(KLineEntity.fromCustom(
                  high: LocalStorage.getBool(GetXStorageConstants.listed) == true
                      ? double.parse(i['ohlc']['h'].toString())
                      : i['ohlc']['h'].toDouble(),
                  low: LocalStorage.getBool(GetXStorageConstants.listed) == true
                      ? double.parse(i['ohlc']['l'].toString())
                      : i['ohlc']['l'].toDouble(),
                  open: LocalStorage.getBool(GetXStorageConstants.listed) == true
                      ? double.parse(i['ohlc']['o'].toString())
                      : i['ohlc']['o'].toDouble(),
                  close: LocalStorage.getBool(GetXStorageConstants.listed) == true
                      ? double.parse(i['ohlc']['c'].toString())
                      : i['ohlc']['c'].toDouble(),
                  time: i['start_time'].toInt(),
                  vol: double.parse(i['ohlc']['v'].toString())
              ));

            }
            prev = double.parse(i['ohlc']['c'].toString());

          }
          else {
            vol = double.parse(i['ohlc']['v'].toString());
            qty = i['ohlc']['o'].toDouble();
            low = i['ohlc']['l'].toDouble();
            high = i['ohlc']['h'].toDouble();
            owndata.add(KLineEntity.fromCustom(
                high:  i['ohlc']['h'].toDouble(),
                low: i['ohlc']['l'].toDouble(),
                open:  i['ohlc']['o'].toDouble(),
                close:i['ohlc']['c'].toDouble(),
                time: i['start_time'].toInt(),
                vol: double.parse(i['ohlc']['v'].toString())));
          }
          j++;
        }
        await DataUtil.calculate(owndata);
        chartLoading = false;
        update([ControllerBuilders.button]);
      } else{
        chartLoading = false;
        update([ControllerBuilders.button]);
      }
    }  catch (e) {
      print("=================================>${e.toString()}");
    }

  }
  }

class MarketTrade {
  final String? price;
  final String? quantity;
  final String? date;
  final bool? type;

  MarketTrade({ this.price,  this.quantity,  this.date,this.type});
}



class DataUtil {
  static calculate(List<KLineEntity> dataList,
      [List<int> maDayList = const [5, 10, 20], int n = 20, k = 2]) {
    calcMA(dataList, maDayList);
    calcBOLL(dataList, n, k);
    calcVolumeMA(dataList);
    calcKDJ(dataList);
    calcMACD(dataList);
    calcRSI(dataList);
    calcWR(dataList);
    calcCCI(dataList);
  }


  static calcMA(List<KLineEntity> dataList, List<int> maDayList) {
    List<double> ma = List<double>.filled(maDayList.length, 0);

    if (dataList.isNotEmpty) {
      for (int i = 0; i < dataList.length; i++) {
        KLineEntity entity = dataList[i];
        final closePrice = entity.close;
        entity.maValueList = List<double>.filled(maDayList.length, 0);

        for (int j = 0; j < maDayList.length; j++) {
          ma[j] += closePrice;
          if (i == maDayList[j] - 1) {
            entity.maValueList?[j] = ma[j] / maDayList[j];
          } else if (i >= maDayList[j]) {
            ma[j] -= dataList[i - maDayList[j]].close;
            entity.maValueList?[j] = ma[j] / maDayList[j];
          } else {
            entity.maValueList?[j] = 0;
          }
        }
      }
    }
  }

  static void calcBOLL(List<KLineEntity> dataList, int n, int k) {
    _calcBOLLMA(n, dataList);
    for (int i = 0; i < dataList.length; i++) {
      KLineEntity entity = dataList[i];
      if (i >= n) {
        double md = 0;
        for (int j = i - n + 1; j <= i; j++) {
          double c = dataList[j].close;
          double m = entity.BOLLMA!;
          double value = c - m;
          md += value * value;
        }
        md = md / (n - 1);
        md = sqrt(md);
        entity.mb = entity.BOLLMA!;
        entity.up = entity.mb! + k * md;
        entity.dn = entity.mb! - k * md;
      }
    }
  }

  static void _calcBOLLMA(int day, List<KLineEntity> dataList) {
    double ma = 0;
    for (int i = 0; i < dataList.length; i++) {
      KLineEntity entity = dataList[i];
      ma += entity.close;
      if (i == day - 1) {
        entity.BOLLMA = ma / day;
      } else if (i >= day) {
        ma -= dataList[i - day].close;
        entity.BOLLMA = ma / day;
      } else {
        entity.BOLLMA = null;
      }
    }
  }

  static void calcMACD(List<KLineEntity> dataList) {
    double ema12 = 0;
    double ema26 = 0;
    double dif = 0;
    double dea = 0;
    double macd = 0;

    for (int i = 0; i < dataList.length; i++) {
      KLineEntity entity = dataList[i];
      final closePrice = entity.close;
      if (i == 0) {
        ema12 = closePrice;
        ema26 = closePrice;
      } else {
        ema12 = ema12 * 11 / 13 + closePrice * 2 / 13;
        ema26 = ema26 * 25 / 27 + closePrice * 2 / 27;
      }
      dif = ema12 - ema26;
      dea = dea * 8 / 10 + dif * 2 / 10;
      macd = (dif - dea) * 2;
      entity.dif = dif;
      entity.dea = dea;
      entity.macd = macd;
    }
  }

  static void calcVolumeMA(List<KLineEntity> dataList) {
    double volumeMa5 = 0;
    double volumeMa10 = 0;

    for (int i = 0; i < dataList.length; i++) {
      KLineEntity entry = dataList[i];

      volumeMa5 += entry.vol;
      volumeMa10 += entry.vol;

      if (i == 4) {
        entry.MA5Volume = (volumeMa5 / 5);
      } else if (i > 4) {
        volumeMa5 -= dataList[i - 5].vol;
        entry.MA5Volume = volumeMa5 / 5;
      } else {
        entry.MA5Volume = 0;
      }

      if (i == 9) {
        entry.MA10Volume = volumeMa10 / 10;
      } else if (i > 9) {
        volumeMa10 -= dataList[i - 10].vol;
        entry.MA10Volume = volumeMa10 / 10;
      } else {
        entry.MA10Volume = 0;
      }
    }
  }

  static void calcRSI(List<KLineEntity> dataList) {
    double? rsi;
    double rsiABSEma = 0;
    double rsiMaxEma = 0;
    for (int i = 0; i < dataList.length; i++) {
      KLineEntity entity = dataList[i];
      final double closePrice = entity.close;
      if (i == 0) {
        rsi = 0;
        rsiABSEma = 0;
        rsiMaxEma = 0;
      } else {
        double rMax = max(0, closePrice - dataList[i - 1].close.toDouble());
        double rAbs = (closePrice - dataList[i - 1].close.toDouble()).abs();

        rsiMaxEma = (rMax + (14 - 1) * rsiMaxEma) / 14;
        rsiABSEma = (rAbs + (14 - 1) * rsiABSEma) / 14;
        rsi = (rsiMaxEma / rsiABSEma) * 100;
      }
      if (i < 13) rsi = null;
      if (rsi != null && rsi.isNaN) rsi = null;
      entity.rsi = rsi;
    }
  }

  static void calcKDJ(List<KLineEntity> dataList) {
    var preK = 50.0;
    var preD = 50.0;
    final tmp = dataList.first;
    tmp.k = preK;
    tmp.d = preD;
    tmp.j = 50.0;
    for (int i = 1; i < dataList.length; i++) {
      final entity = dataList[i];
      final n = max(0, i - 8);
      var low = entity.low;
      var high = entity.high;
      for (int j = n; j < i; j++) {
        final t = dataList[j];
        if (t.low < low) {
          low = t.low;
        }
        if (t.high > high) {
          high = t.high;
        }
      }
      final cur = entity.close;
      var rsv = (cur - low) * 100.0 / (high - low);
      rsv = rsv.isNaN ? 0 : rsv;
      final k = (2 * preK + rsv) / 3.0;
      final d = (2 * preD + k) / 3.0;
      final j = 3 * k - 2 * d;
      preK = k;
      preD = d;
      entity.k = k;
      entity.d = d;
      entity.j = j;
    }
  }

  static void calcWR(List<KLineEntity> dataList) {
    double r;
    for (int i = 0; i < dataList.length; i++) {
      KLineEntity entity = dataList[i];
      int startIndex = i - 14;
      if (startIndex < 0) {
        startIndex = 0;
      }
      double max14 = double.minPositive;
      double min14 = double.maxFinite;
      for (int index = startIndex; index <= i; index++) {
        max14 = max(max14, dataList[index].high);
        min14 = min(min14, dataList[index].low);
      }
      if (i < 13) {
        entity.r = -10;
      } else {
        r = -100 * (max14 - dataList[i].close) / (max14 - min14);
        if (r.isNaN) {
          entity.r = null;
        } else {
          entity.r = r;
        }
      }
    }
  }

  static void calcCCI(List<KLineEntity> dataList) {
    final size = dataList.length;
    final count = 14;
    for (int i = 0; i < size; i++) {
      final kline = dataList[i];
      final tp = (kline.high + kline.low + kline.close) / 3;
      final start = max(0, i - count + 1);
      var amount = 0.0;
      var len = 0;
      for (int n = start; n <= i; n++) {
        amount += (dataList[n].high + dataList[n].low + dataList[n].close) / 3;
        len++;
      }
      final ma = amount / len;
      amount = 0.0;
      for (int n = start; n <= i; n++) {
        amount +=
            (ma - (dataList[n].high + dataList[n].low + dataList[n].close) / 3)
                .abs();
      }
      final md = amount / len;
      kline.cci = ((tp - ma) / 0.015 / md);
      if (kline.cci!.isNaN) {
        kline.cci = 0.0;
      }
    }
  }
}

