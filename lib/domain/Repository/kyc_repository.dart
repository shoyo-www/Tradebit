
import 'package:dartz/dartz.dart';
import 'package:tradebit_app/core/error/failures.dart';
import 'package:tradebit_app/data/datasource/remote/models/request/generate_addhar.dart';
import 'package:tradebit_app/data/datasource/remote/models/response/kyc_otp_response.dart';

abstract class KycRepository {
  Future<Either<Failure,KycOtpResponse>> generateKycOtp(GenerateKycOtpRequest request);
}