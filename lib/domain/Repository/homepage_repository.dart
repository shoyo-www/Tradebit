import 'package:dartz/dartz.dart';
import 'package:tradebit_app/core/error/failures.dart';
import 'package:tradebit_app/data/datasource/remote/models/request/frees_request.dart';
import 'package:tradebit_app/data/datasource/remote/models/request/logout_request.dart';
import 'package:tradebit_app/data/datasource/remote/models/response/activity_response.dart';
import 'package:tradebit_app/data/datasource/remote/models/response/banner_response.dart';
import 'package:tradebit_app/data/datasource/remote/models/response/common_response.dart';
import 'package:tradebit_app/data/datasource/remote/models/response/crypto_response.dart';
import 'package:tradebit_app/data/datasource/remote/models/response/gainers_response.dart';
import 'package:tradebit_app/data/datasource/remote/models/response/notification_response.dart';
import 'package:tradebit_app/data/datasource/remote/models/response/profile_response.dart';

abstract class HomeRepository {
  Future<Either<Failure, BannerResponse>> banner();
  Future<Either<Failure, CryptoResponse>> crypto();
  Future<Either<Failure, GainerResponse>> gainers();
  Future<Either<Failure, CommonResponse>> logoutFromSingle(LogoutRequest logoutRequest);
  Future<Either<Failure, CommonResponse>> logoutFromAll(LogoutRequest logoutRequest);
  Future<Either<Failure, CommonResponse>> fees(FeesRequest feesRequest);
  Future<Either<Failure, NotificationResponse>> notification(int page);
  Future<Either<Failure, ProfileResponse>> profile();
  Future<Either<Failure, ActivityResponse>> getActivity(int page);
}