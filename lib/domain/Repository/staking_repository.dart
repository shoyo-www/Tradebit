import 'package:dartz/dartz.dart';
import 'package:tradebit_app/core/error/failures.dart';
import 'package:tradebit_app/data/datasource/remote/models/request/reddem_request.dart';
import 'package:tradebit_app/data/datasource/remote/models/request/staking_request.dart';
import 'package:tradebit_app/data/datasource/remote/models/request/unsubscribe_request.dart';
import 'package:tradebit_app/data/datasource/remote/models/response/common_response.dart';
import 'package:tradebit_app/data/datasource/remote/models/response/staking.dart';
import 'package:tradebit_app/data/datasource/remote/models/response/staking_history.dart';
import 'package:tradebit_app/data/datasource/remote/models/response/transaction_history.dart';

abstract class StakingRepository {
  Future<Either<Failure, StakingResponse>> staking();
  Future<Either<Failure, StakingHistory>> stakingHistory(int page);
  Future<Either<Failure, TransactionHistory>> transactionHistory(int page);
  Future<Either<Failure, CommonResponse>> stakingSub(StakingSubscribeRequest request);
  Future<Either<Failure, CommonResponse>> stakingUnsubscribe(StakingUnsubscribeRequest request);
  Future<Either<Failure, CommonResponse>> redeem(RedeemRequest request);
}