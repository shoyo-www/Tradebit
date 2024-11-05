import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tradebit_app/constants/constants.dart';
import 'package:tradebit_app/data/datasource/local/local_storage.dart';
import 'package:tradebit_app/data/datasource/remote/models/response/crypto_response.dart';
import 'package:tradebit_app/data/datasource/remote/services/apis.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class MarketController extends GetxController {
  bool isLoading = false;
  List<Btc> market = [];
  List<Btc> filterList = [];
  bool listed = false;
  bool search = false;
  TextEditingController searchController = TextEditingController();
  StreamController<String> streamController = StreamController.broadcast();
  WebSocketChannel? _webSocketChannel;
  StreamController<String> streamControllerSearch = StreamController.broadcast();
  WebSocketChannel? _webSocketChannelSearch;

  @override
  void onInit() {
    super.onInit();
    getMarket();
    connectToSocket();
    connectToSocketSearch();
  }

  void filterSearch(String text) {
    filterList = market
        .where((e) => e.symbol!.toUpperCase().contains(text.toUpperCase()))
        .toList();
    search = true;
    update([ControllerBuilders.marketController]);
  }

  void clearTextField() {
    search = false;
    searchController.clear();
    update([ControllerBuilders.marketController]);
  }


  connectToSocket() async {
    var subscribe = json.encode({
      'method': "SUBSCRIBE",
      'params': [
        for (var i in LocalStorage.getListTickers(GetXStorageConstants.listedTickers)) '${i.toLowerCase()}@ticker'
      ],
      'id': 3,
    });

    var subscribeMessage = json.encode({
      'method': "SUBSCRIBE",
      'params': [
        for (var i in LocalStorage.getListTickers(
            GetXStorageConstants.tickers)) '${i.toLowerCase()}@ticker'
      ],
      'id': 3,
    });

    _webSocketChannel = listed ? IOWebSocketChannel.connect(Apis.tbSocket) : IOWebSocketChannel.connect(Apis.binanceSocket);

    _webSocketChannel?.stream.listen((data) {
      streamController.add(data);
    });

    _webSocketChannel?.sink.add(listed ? subscribe : subscribeMessage);
  }

  connectToSocketSearch() async {
    var subscribe = json.encode({
      'method': "SUBSCRIBE",
      'params': [
        for (var i in LocalStorage.getListTickers(GetXStorageConstants.listedTickers))'${i.toLowerCase()}@ticker'
      ],
      'id': 3,
    });

    var subscribeMessage = json.encode({
      'method': "SUBSCRIBE",
      'params': [
        for (var i in LocalStorage.getListTickers(GetXStorageConstants.tickers)) '${i.toLowerCase()}@ticker'
      ],
      'id': 3,
    });

    _webSocketChannelSearch =
    listed ? IOWebSocketChannel.connect(Apis.tbSocket) : IOWebSocketChannel.connect(Apis.binanceSocket);

    _webSocketChannelSearch?.stream.listen((data) {
      streamControllerSearch.add(data);
    });

    _webSocketChannelSearch?.sink.add(listed ? subscribe : subscribeMessage);
  }


  getMarket() async {
    filterList.clear();
    market = [
      ...LocalStorage.getListCrypto(),
      ...LocalStorage.getListBtc(),
      ...LocalStorage.getListTbc(),
      ...LocalStorage.getListTrx(),
      ...LocalStorage.getListEth()
    ];
    filterList = market;
    for (var i in market) {
      listed = i.listed ?? false;
      update([ControllerBuilders.marketController]);
    }
    update([ControllerBuilders.marketController]);
  }
}
