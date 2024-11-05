import 'package:dartz/dartz.dart';
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

abstract class WalletRepository {
  Future<Either<Failure, WalletListResponse>> wallet();
  Future<Either<Failure, StakeBalance>> stakeWallet();
  Future<Either<Failure, CurrencyResponse>> walletSymbol(String symbol);
  Future<Either<Failure, DepositResponse>> deposit();
  Future<Either<Failure, HistoryResponse>> history(String type);
  Future<Either<Failure, CommonResponse>> withdraw(WithdrawRequest request);
  Future<Either<Failure, TransferResponse>> transfer(TransferRequest request);
  Future<Either<Failure, CommonResponse>> transferReceiver(TransferRequest request);
  Future<Either<Failure, TransferOtpResponse>> transferOtp(TransferOtpRequest request);
  Future<Either<Failure, TransferOtpResponse>> transferMobile(TransferOtpRequest request);
  Future<Either<Failure, CommonResponse>> sendToken(SendTokenRequest request);
  Future<Either<Failure, WalletProcessResponse>> walletProcess(WalletProcessRequest request);
  Future<Either<Failure, CommonResponse>> walletVerify(VerifyWithdrawRequest request);
  Future<Either<Failure, CommonResponse>> walletCreate(WalletCreateRequest request);
  Future<Either<Failure, ReferralsResponse>> getReferral();
  Future<Either<Failure, ReferIncomeResponse>> getRefer();
}