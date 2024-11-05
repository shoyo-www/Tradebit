import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import 'package:tradebit_app/core/error/exceptions.dart';
import 'package:tradebit_app/core/error/failures.dart';
import 'package:tradebit_app/data/datasource/remote/models/request/bind_email_request.dart';
import 'package:tradebit_app/data/datasource/remote/models/request/change_number_request.dart';
import 'package:tradebit_app/data/datasource/remote/models/request/confirm_change_number.dart';
import 'package:tradebit_app/data/datasource/remote/models/request/email_otp.dart';
import 'package:tradebit_app/data/datasource/remote/models/request/google_FA_request.dart';
import 'package:tradebit_app/data/datasource/remote/models/request/unbind_email_request.dart';
import 'package:tradebit_app/data/datasource/remote/models/response/bind_email.dart';
import 'package:tradebit_app/data/datasource/remote/models/response/change_number_response.dart';
import 'package:tradebit_app/data/datasource/remote/models/response/common_response.dart';
import 'package:tradebit_app/data/datasource/remote/models/response/google_fa.dart';
import 'package:tradebit_app/data/datasource/remote/models/response/security_response.dart';
import 'package:tradebit_app/data/datasource/remote/services/apis.dart';
import 'package:tradebit_app/data/datasource/remote/services/dio/rest_client.dart';
import 'package:tradebit_app/domain/Repository/security_repository.dart';

class SecurityRepositoryImpl extends SecurityRepository {
  final _restClient = Get.find<RestClient>();

  @override
  Future<Either<Failure, SecurityResponse>> security() async {
    try {
      final response = await _restClient.get(url: Apis.getVerification2FAList);
      return Right(securityResponseFromJson(response));
    } on ApiException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, GoogleFa>> googleFa() async {
    try {
      final response = await _restClient.get(url: Apis.google2fa);
      return Right(googleFaFromJson(response));
    } on ApiException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, BindEmailResponse>> bindEmailMobile() async {
    try {
      final response = await _restClient.get(url: Apis.bindEmailAndPhone);
      return Right(bindEmailResponseFromJson(response));
    } on ApiException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, CommonResponse>> googleFaOtp(GoogleRequest request) async {
    try {
      final response = await _restClient.post(url: Apis.google2FaVerify, request: request.toJson());
      return Right(commonResponseFromJson(response));
    } on ApiException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, CommonResponse>> bindEmail(BindEmailRequest request) async {
    try {
      final response = await _restClient.post(url: Apis.bindEmail, request: request.toJson());
      return Right(commonResponseFromJson(response));
    } on ApiException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, CommonResponse>> bindMobile(BindMobileRequest request) async {
    try {
      final response = await _restClient.post(url: Apis.bindMobile, request: request.toJson());
      return Right(commonResponseFromJson(response));
    } on ApiException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, CommonResponse>> bindEmailOtp(BindEmailOtpRequest request) async {
    try {
      final response = await _restClient.post(url: Apis.bindEmailOtp, request: request.toJson());
      return Right(commonResponseFromJson(response));
    } on ApiException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, CommonResponse>> bindMobileOtp(BindMobileOtpRequest request) async {
    try {
      final response = await _restClient.post(url: Apis.bindMobileOtp, request: request.toJson());
      return Right(commonResponseFromJson(response));
    } on ApiException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, CommonResponse>> unBindEmailOtp(UnBindEmailRequest request) async {
    try {
      final response = await _restClient.post(url: Apis.unBindEmail, request: request.toJson());
      return Right(commonResponseFromJson(response));
    } on ApiException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, CommonResponse>> unGoogle2Fa(UnBindEmailRequest request) async {
    try {
      final response = await _restClient.post(url: Apis.unBindGoogle2fa, request: request.toJson());
      return Right(commonResponseFromJson(response));
    } on ApiException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, CommonResponse>> unBindMobile(UnBindEmailRequest request) async {
    try {
      final response = await _restClient.post(url: Apis.unBindMobile, request: request.toJson());
      return Right(commonResponseFromJson(response));
    } on ApiException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, ChangeNumberResponse>> changeMobile(ChangeNumberRequest request) async {
    try {
      final response = await _restClient.post(url: Apis.basicDetailsMobile, request: request.toJson());
      return Right(changeNumberResponseFromJson(response));
    } on ApiException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, CommonResponse>> confirmChangeMobile(ConfirmNumberRequest request) async {
    try {
      final response = await _restClient.post(url: Apis.changeNumber, request: request.toJson());
      return Right(commonResponseFromJson(response));
    } on ApiException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}