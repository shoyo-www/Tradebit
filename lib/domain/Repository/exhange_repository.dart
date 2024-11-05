import 'package:dartz/dartz.dart';
import 'package:tradebit_app/core/error/failures.dart';
import 'package:tradebit_app/data/datasource/remote/models/request/buy_and_sell_request.dart';
import 'package:tradebit_app/data/datasource/remote/models/response/bids_ask_response.dart';
import 'package:tradebit_app/data/datasource/remote/models/response/chart_response.dart';
import 'package:tradebit_app/data/datasource/remote/models/response/common_response.dart';
import 'package:tradebit_app/data/datasource/remote/models/response/open_order.dart';
import 'package:tradebit_app/data/datasource/remote/models/response/order_history.dart';

abstract class ExchangeRepository {
  Future<Either<Failure, CommonResponse>> buyAndSell(BuyAndSellRequest request);
  Future<Either<Failure, BidsAndAsksResponse>> bidsAndAsks(String currency,String pair);
  Future<Either<Failure, OrderHistory>> orderHistory(int page);
  Future<Either<Failure, OpenOrderResponse>> openOrders(int page);
  Future<Either<Failure, CommonResponse>> cancelOrder(int id);
  Future<Either<Failure, ChartResponse>> chart(String symbol,String chartInterval);
}