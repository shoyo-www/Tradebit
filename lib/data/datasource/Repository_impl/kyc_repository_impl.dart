import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import 'package:tradebit_app/core/error/exceptions.dart';
import 'package:tradebit_app/core/error/failures.dart';
import 'package:tradebit_app/data/datasource/remote/models/request/generate_addhar.dart';
import 'package:tradebit_app/data/datasource/remote/models/response/kyc_otp_response.dart';
import 'package:tradebit_app/data/datasource/remote/services/apis.dart';
import 'package:tradebit_app/data/datasource/remote/services/dio/rest_client.dart';
import 'package:tradebit_app/domain/Repository/kyc_repository.dart';

class KycRepositoryImpl implements KycRepository {
  final _restClient = Get.find<RestClient>();

  @override
  Future<Either<Failure, KycOtpResponse>> generateKycOtp(GenerateKycOtpRequest request) async {
    try {
      final response = await _restClient.post(url: Apis.generateKycOtp, request: request.toJson());
      return Right(kycOtpResponseFromJson(response));
    } on ApiException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

}