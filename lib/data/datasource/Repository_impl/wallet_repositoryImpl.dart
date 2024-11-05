import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import 'package:tradebit_app/core/error/exceptions.dart';
import 'package:tradebit_app/core/error/failures.dart';
import 'package:tradebit_app/data/datasource/remote/models/request/send_token_request.dart';
import 'package:tradebit_app/data/datasource/remote/models/request/transfer_otp_request.dart';
import 'package:tradebit_app/data/datasource/remote/models/request/transfer_request.dart';
import 'package:tradebit_app/data/datasource/remote/models/request/wallet_create.dart';
import 'package:tradebit_app/data/datasource/remote/models/request/wallet_request.dart';
import 'package:tradebit_app/data/datasource/remote/models/request/withdraw_process.dart';
import 'package:tradebit_app/data/datasource/remote/models/request/withdraw_verify_request.dart';
import 'package:tradebit_app/data/datasource/remote/models/response/common_response.dart';
import 'package:tradebit_app/data/datasource/remote/models/response/currency_single.dart';
import 'package:tradebit_app/data/datasource/remote/models/response/deposit_response.dart';
import 'package:tradebit_app/data/datasource/remote/models/response/history_response.dart';
import 'package:tradebit_app/data/datasource/remote/models/response/refer_income_response.dart';
import 'package:tradebit_app/data/datasource/remote/models/response/referral_response.dart';
import 'package:tradebit_app/data/datasource/remote/models/response/stake_balance.dart';
import 'package:tradebit_app/data/datasource/remote/models/response/transfer_otp_response.dart';
import 'package:tradebit_app/data/datasource/remote/models/response/transfer_response.dart';
import 'package:tradebit_app/data/datasource/remote/models/response/walletListResponse.dart';
import 'package:tradebit_app/data/datasource/remote/models/response/wallet_process_response.dart';
import 'package:tradebit_app/data/datasource/remote/services/apis.dart';
import 'package:tradebit_app/data/datasource/remote/services/dio/rest_client.dart';
import 'package:tradebit_app/domain/Repository/wallet_repository.dart';

class WalletRepositoryImpl implements WalletRepository {
  final _restClient = Get.find<RestClient>();

  @override
  Future<Either<Failure, WalletListResponse>> wallet() async {
    try {
      final response = await _restClient.get(url: Apis.walletList);
      return Right(walletListResponseFromJson(response));
    } on ApiException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, CurrencyResponse>> walletSymbol(String symbol) async {
    try {
      final response = await _restClient.get(url: "${Apis.singleCurrency}/$symbol");
      return Right(currencyResponseFromJson(response));
    } on ApiException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, DepositResponse>> deposit() async {
    try {
      final response = await _restClient.get(url: Apis.deposit);
      return Right(depositResponseFromJson(response));
    } on ApiException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, CommonResponse>> withdraw(WithdrawRequest request) async {
    try{
      final response = await _restClient.post(url: Apis.withdraw, request: request.toJson());
      return Right(commonResponseFromJson(response));
    }on ApiException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, TransferResponse>> transfer(TransferRequest request) async {
    try {
      final response = await _restClient.post(url: Apis.transfer, request: request.toJson());
      return Right(transferResponseFromJson(response));
    }on ApiException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, CommonResponse>> transferReceiver(TransferRequest request) async {
   try {
     final response = await _restClient.post(url: Apis.transferReceive, request: request.toJson());
     return Right(commonResponseFromJson(response));
   }on ApiException catch (e) {
     return Left(ServerFailure(e.message));
   }
  }

  @override
  Future<Either<Failure, TransferOtpResponse>> transferOtp(TransferOtpRequest request) async {
    try {
      final response = await _restClient.post(url: Apis.transferSendOtp, request: request.toJson());
      return Right(transferOtpResponseFromJson(response));
    }on ApiException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, TransferOtpResponse>> transferMobile(TransferOtpRequest request) async {
    try {
      final response = await _restClient.post(url: Apis.transferSendMobile, request: request.toJson());
      return Right(transferOtpResponseFromJson(response));
    }on ApiException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, CommonResponse>> sendToken(SendTokenRequest request) async {
    try {
      final response = await _restClient.post(url: Apis.sendToken, request: request.toJson());
      return Right(commonResponseFromJson(response));
    }on ApiException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, HistoryResponse>> history(String type) async{
    try {
      final response = await _restClient.post(url: "${Apis.history}$type", request: {});
      return Right(historyResponseFromJson(response));
    } on ApiException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, WalletProcessResponse>> walletProcess(WalletProcessRequest request) async {
    try {
      final response = await _restClient.post(url: Apis.walletWithdraw, request: request.toJson());
      return Right(walletProcessResponseFromJson(response));
    } on ApiException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, CommonResponse>> walletVerify(VerifyWithdrawRequest request) async {
    try {
      final response = await _restClient.post(url: Apis.verifyWithdraw, request: request.toJson());
      return Right(commonResponseFromJson(response));
    } on ApiException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, StakeBalance>> stakeWallet() async {
    try {
      final response = await _restClient.get(url: Apis.stakingBalance);
      return Right(stakeBalanceFromJson(response));
    } on ApiException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, CommonResponse>> walletCreate(WalletCreateRequest request) async {
    try {
      final response = await _restClient.post(url: Apis.walletCreate, request: request.toJson());
      return Right(commonResponseFromJson(response));
    } on ApiException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, ReferralsResponse>> getReferral() async {
    try {
      final response = await _restClient.get(url: Apis.refferal);
      return Right(referralsResponseFromJson(response));
    } on ApiException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, ReferIncomeResponse>> getRefer() async {
    try {
      final response = await _restClient.get(url: Apis.referralIncome);
      return Right(referIncomeResponseFromJson(response));
    } on ApiException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

}