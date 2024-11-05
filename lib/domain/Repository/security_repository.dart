import 'package:dartz/dartz.dart';
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

abstract class SecurityRepository {
  Future<Either<Failure, SecurityResponse>> security();
  Future<Either<Failure, GoogleFa>> googleFa();
  Future<Either<Failure, BindEmailResponse>> bindEmailMobile();
  Future<Either<Failure, CommonResponse>> googleFaOtp(GoogleRequest request);
  Future<Either<Failure, CommonResponse>> bindEmail(BindEmailRequest request);
  Future<Either<Failure, CommonResponse>> bindMobile(BindMobileRequest request);
  Future<Either<Failure, CommonResponse>> bindEmailOtp(BindEmailOtpRequest request);
  Future<Either<Failure, CommonResponse>> bindMobileOtp(BindMobileOtpRequest request);
  Future<Either<Failure, CommonResponse>> unBindEmailOtp(UnBindEmailRequest request);
  Future<Either<Failure, CommonResponse>> unGoogle2Fa(UnBindEmailRequest request);
  Future<Either<Failure, CommonResponse>> unBindMobile(UnBindEmailRequest request);
  Future<Either<Failure, ChangeNumberResponse>> changeMobile(ChangeNumberRequest request);
  Future<Either<Failure, CommonResponse>> confirmChangeMobile(ConfirmNumberRequest request);
}