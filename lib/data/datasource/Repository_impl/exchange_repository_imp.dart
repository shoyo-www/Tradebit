import 'dart:ffi';

import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import 'package:tradebit_app/constants/constants.dart';
import 'package:tradebit_app/core/error/exceptions.dart';
import 'package:tradebit_app/core/error/failures.dart';
import 'package:tradebit_app/data/datasource/local/local_storage.dart';
import 'package:tradebit_app/data/datasource/remote/models/request/buy_and_sell_request.dart';
import 'package:tradebit_app/data/datasource/remote/models/response/bids_ask_response.dart';
import 'package:tradebit_app/data/datasource/remote/models/response/chart_response.dart';
import 'package:tradebit_app/data/datasource/remote/models/response/common_response.dart';
import 'package:tradebit_app/data/datasource/remote/models/response/order_history.dart';
import 'package:tradebit_app/data/datasource/remote/services/apis.dart';
import 'package:tradebit_app/data/datasource/remote/services/dio/rest_client.dart';
import 'package:tradebit_app/domain/Repository/exhange_repository.dart';

import '../remote/models/response/open_order.dart';

class ExchangeRepositoryImpl implements ExchangeRepository {
  final _restClient = Get.find<RestClient>();
  @override
  Future<Either<Failure, CommonResponse>> buyAndSell(BuyAndSellRequest request) async {
   try {
     final response = await _restClient.post(url: Apis.buyAndSell, request: request.toJson());
     return Right(commonResponseFromJson(response));
   } on ApiException catch (e) {
     return Left(ServerFailure(e.message));
   }

  }

  @override
  Future<Either<Failure, BidsAndAsksResponse>> bidsAndAsks(String currency,String pair) async {
    try {
      final response = await _restClient.get(url: LocalStorage.getBool(GetXStorageConstants.listed) == true ? "${Apis.bidsAndAsks}$currency&with_currency=$pair" :
      'https://node.tradebit.io/list-crypto/market-data/$currency$pair?limit=20');
      return Right(bidsAndAsksResponseFromJson(response));
    } on ApiException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, OrderHistory>> orderHistory(int page) async {
    try {
      final response = await _restClient.get(url: "${Apis.orderHistory}$page&per_page=10");
      return Right(orderHistoryFromJson(response));
    } on ApiException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, OpenOrderResponse>> openOrders(int page) async{
    try {
      final response = await _restClient.get(url: "${Apis.openOrders}$page&per_page=10");
      return Right(openOrderResponseFromJson(response));
    } on ApiException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, ChartResponse>> chart(String symbol,String chartInterval) async{
    try {
      final response = await _restClient.get(url: "${Apis.chart}$symbol&interval=$chartInterval");
      return Right(chartResponseFromJson(response));
    } on ApiException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, CommonResponse>> cancelOrder(int id) async {
    try {
      final response = await _restClient.post(url: "${Apis.cancelOrder}$id", request: {});
      return Right(commonResponseFromJson(response));
    } on ApiException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}