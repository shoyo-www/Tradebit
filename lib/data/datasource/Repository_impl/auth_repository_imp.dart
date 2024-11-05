import 'package:get/get.dart';
import 'package:dartz/dartz.dart';
import 'package:tradebit_app/core/error/exceptions.dart';
import 'package:tradebit_app/core/error/failures.dart';
import 'package:tradebit_app/data/datasource/remote/models/request/basic_Email.dart';
import 'package:tradebit_app/data/datasource/remote/models/request/change_password.dart';
import 'package:tradebit_app/data/datasource/remote/models/request/email_register.dart';
import 'package:tradebit_app/data/datasource/remote/models/request/forgot_request.dart';
import 'package:tradebit_app/data/datasource/remote/models/request/google_request.dart';
import 'package:tradebit_app/data/datasource/remote/models/request/login_request.dart';
import 'package:tradebit_app/data/datasource/remote/models/request/mobile_request.dart';
import 'package:tradebit_app/data/datasource/remote/models/request/mobile_verification.dart';
import 'package:tradebit_app/data/datasource/remote/models/request/phone_forgot_request.dart';
import 'package:tradebit_app/data/datasource/remote/models/request/register_email_request.dart';
import 'package:tradebit_app/data/datasource/remote/models/request/register_mobile_request.dart';
import 'package:tradebit_app/data/datasource/remote/models/request/register_phone_request.dart';
import 'package:tradebit_app/data/datasource/remote/models/request/resend_otp.dart';
import 'package:tradebit_app/data/datasource/remote/models/request/update_profile.dart';
import 'package:tradebit_app/data/datasource/remote/models/request/validate_mobile.dart';
import 'package:tradebit_app/data/datasource/remote/models/response/common_response.dart';
import 'package:tradebit_app/data/datasource/remote/models/request/otp_rquest.dart';
import 'package:tradebit_app/data/datasource/remote/models/response/google_login_response.dart';
import 'package:tradebit_app/data/datasource/remote/models/response/login_response.dart';
import 'package:tradebit_app/data/datasource/remote/models/response/otp_email_response.dart';
import 'package:tradebit_app/data/datasource/remote/models/response/register_email_response.dart';
import 'package:tradebit_app/data/datasource/remote/models/response/register_mobile_response.dart';
import 'package:tradebit_app/data/datasource/remote/models/response/register_verify_otp.dart';
import 'package:tradebit_app/data/datasource/remote/models/response/resend_otp_response.dart';
import 'package:tradebit_app/data/datasource/remote/services/apis.dart';
import 'package:tradebit_app/data/datasource/remote/services/dio/rest_client.dart';
import 'package:tradebit_app/domain/Repository/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final _restClient = Get.find<RestClient>();

  @override
  Future<Either<Failure, LoginResponse>> login(LoginRequest loginParams) async {
    try {
      final response = await _restClient.post(
          url: Apis.login, request: loginParams.toJson());
      return Right(loginResponseFromJson(response));
    } on ApiException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, OtpEmailResponse>> otpLogin(OtpRequestMobile otpParams) async {
    try {
      final response =
          await _restClient.post(url: Apis.otp, request: otpParams.toJson());
      return right(otpEmailResponseFromJson(response));
    } on ApiException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, LoginResponse>> mobileLogin(
      MobileRequest mobileParams) async {
    try {
      final response = await _restClient.post(
          url: Apis.login, request: mobileParams.toJson());
      return Right(loginResponseFromJson(response));
    } on ApiException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, CommonResponse>> registerByMobile(
      RegisterMobileOtpRequest mobileParams) async {
    try {
      final response = await _restClient.post(
          url: Apis.emailRegister, request: mobileParams.toJson());
      return Right(commonResponseFromJson(response));
    } on ApiException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, RegisterMobileResponse>> registerMobile(
      RegisterMobileRequest mobileParams) async {
    try {
      final response = await _restClient.post(
          url: Apis.registerByMobile, request: mobileParams.toJson());
      return Right(registerMobileResponseFromJson(response));
    } on ApiException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, RegisterEmailResponse>> registerEmail(
      RegisterEmailRequest emailParams) async {
    try {
      final response = await _restClient.post(
          url: Apis.registerByEmail, request: emailParams.toJson());
      return Right(registerEmailResponseFromJson(response));
    } on ApiException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }


  @override
  Future<Either<Failure, CommonResponse>> forgotByEmail(ForgotByEmailRequest mobileParams) async {
    try {
      final response = await _restClient.post(url: Apis.forgotPassword, request: mobileParams.toJson());
      return Right(commonResponseFromJson(response));
    }on  ApiException catch (e) {
    return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, CommonResponse>> forgotByPhone(ForgotByMobile emailRequest) async {
    try {
      final response = await _restClient.post(url: Apis.forgotPassword, request: emailRequest.toJson());
      return Right(commonResponseFromJson(response));
    } on ApiException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, GoogleLoginResponse>> googleLogin(GoogleLoginrequest request) async{
    try {
      final response = await _restClient.post(url: Apis.otp, request: request.toJson());
      return Right(googleLoginResponseFromJson(response));
    }on ApiException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, GoogleLoginResponse>> googleLoginMobile(OtpRequestMobile request) async{
    try {
      final response = await _restClient.post(url: Apis.otp, request: request.toJson());
      return Right(googleLoginResponseFromJson(response));
    }on ApiException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, VerifyRegisterEmail>> verifyEmailRegister(RegisterEmailOtpRequest request) async {
    try {
      final response = await _restClient.post(url: Apis.emailRegister, request: request.toJson());
      return Right(verifyRegisterEmailFromJson(response));
    } on ApiException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, CommonResponse>> verifyMobileRegister(RegisterMobileRequest request) async {
    try {
      final response = await _restClient.post(url: Apis.emailRegister, request: request.toJson());
      return Right(commonResponseFromJson(response));
    }on ApiException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, CommonResponse>> changePassword(ChangePasswordRequest request) async {
    try {
      final response = await _restClient.post(url: Apis.changePassword, request: request.toJson());
      return Right(commonResponseFromJson(response));
    } on ApiException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, ResendOtpResponse>> resendOtp(ResendOtpRequest request) async {
    try {
      final response = await _restClient.post(url: Apis.resendOtp, request: request.toJson());
      return Right(resendOtpResponseFromJson(response));
    } on ApiException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, CommonResponse>> basicDetailsMobile(VerifyMobileRequest request) async {
    try {
      final response = await _restClient.post(url: Apis.basicDetailsMobile, request: request.toJson());
      return Right(commonResponseFromJson(response));
    } on ApiException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, CommonResponse>> validateProfile(ValidateMobileProfile request) async{
    try {
      final response = await _restClient.post(url: Apis.validateOtp, request: request.toJson());
      return Right(commonResponseFromJson(response));
    } on ApiException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, CommonResponse>> updateProfile(UpdateProfileRequest request) async {
    try {
      final response = await _restClient.post(url: Apis.updateUser, request: request.toJson());
      return Right(commonResponseFromJson(response));
    } on ApiException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, CommonResponse>> basicEmail(BasicProfileEmailCode request) async {
    try {
      final response = await _restClient.post(url: Apis.basicDetailsEmail, request: request.toJson());
      return Right(commonResponseFromJson(response));
    } on ApiException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

}
