import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import 'package:tradebit_app/core/error/exceptions.dart';
import 'package:tradebit_app/core/error/failures.dart';
import 'package:tradebit_app/data/datasource/remote/models/request/reddem_request.dart';
import 'package:tradebit_app/data/datasource/remote/models/request/staking_request.dart';
import 'package:tradebit_app/data/datasource/remote/models/request/unsubscribe_request.dart';
import 'package:tradebit_app/data/datasource/remote/models/response/common_response.dart';
import 'package:tradebit_app/data/datasource/remote/models/response/staking.dart';
import 'package:tradebit_app/data/datasource/remote/models/response/staking_history.dart';
import 'package:tradebit_app/data/datasource/remote/models/response/transaction_history.dart';
import 'package:tradebit_app/data/datasource/remote/services/apis.dart';
import 'package:tradebit_app/data/datasource/remote/services/dio/rest_client.dart';
import 'package:tradebit_app/domain/Repository/staking_repository.dart';

class StakingRepositoryImpl implements StakingRepository {
  final _restClient = Get.find<RestClient>();

  @override
  Future<Either<Failure, StakingResponse>> staking() async {
    try {
      final response = await _restClient.get(url: Apis.staking);
      return Right(stakingResponseFromJson(response));
    } on ApiException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, CommonResponse>> stakingSub(StakingSubscribeRequest request) async{
    try {
      final response = await _restClient.post(
          url: Apis.stakingSubscribe, request: request.toJson());
      return Right(commonResponseFromJson(response));
    } on ApiException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, StakingHistory>> stakingHistory(int page) async{
    try {
      final response = await _restClient.get(url: "${Apis.stakingHistory}$page");
      return Right(stakingHistoryFromJson(response));
    } on ApiException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, TransactionHistory>> transactionHistory(int page) async{
    try {
      final response = await _restClient.get(url: "${Apis.stakingTransactions}$page");
      return Right(transactionHistoryFromJson(response));
    } on ApiException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, CommonResponse>> stakingUnsubscribe(StakingUnsubscribeRequest request) async{
    try {
      final response = await _restClient.post(url: Apis.stakingUnsubscribe, request: request.toJson());
      return Right(commonResponseFromJson(response));
    } on ApiException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, CommonResponse>> redeem(RedeemRequest request) async {
    try {
      final response = await _restClient.post(url: Apis.redeem, request: request.toJson());
      return Right(commonResponseFromJson(response));
    } on ApiException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}