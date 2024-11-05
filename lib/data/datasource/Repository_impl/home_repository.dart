import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import 'package:tradebit_app/core/error/exceptions.dart';
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
import 'package:tradebit_app/data/datasource/remote/services/apis.dart';
import 'package:tradebit_app/data/datasource/remote/services/dio/rest_client.dart';
import 'package:tradebit_app/domain/Repository/homepage_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  final _restClient = Get.find<RestClient>();

  @override
  Future<Either<Failure, BannerResponse>> banner() async {
    try {
      final response = await _restClient.get(url: Apis.bannerApi);
      return Right(bannerResponseFromJson(response));
    } on ApiException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, CryptoResponse>> crypto() async {
    try {
      final response = await _restClient.get(url: Apis.cryptoApi);
      return Right(cryptoResponseFromJson(response));
    } on ApiException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, GainerResponse>> gainers() async {
    try {
      final response = await _restClient.get(url: Apis.gainers);
      return Right(gainerResponseFromJson(response));
    } on ApiException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, CommonResponse>> logoutFromSingle(
      LogoutRequest logoutRequest) async {
    try {
      final r = await _restClient.delete(url: Apis.logoutFromSingle, request: {});
      return Right(commonResponseFromJson(r));
    } on ApiException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, CommonResponse>> logoutFromAll(LogoutRequest logoutRequest) async {
    try {
      final response = await _restClient.delete(url: Apis.logoutFromAll, request: logoutRequest.toJson());
      return Right(commonResponseFromJson(response));
    } on ApiException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, CommonResponse>> fees(FeesRequest feesRequest) async{
    try {
      final response = await _restClient.post(url: Apis.fees, request: feesRequest.toJson());
      return Right(commonResponseFromJson(response));
    } on ApiException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, NotificationResponse>> notification(int page) async {
   try{
     final response = await _restClient.get(url: "${Apis.notification}$page");
     return Right(notificationResponseFromJson(response));
   }on ApiException catch (e) {
     return Left(ServerFailure(e.message));
   }
  }

  @override
  Future<Either<Failure, ProfileResponse>> profile() async {
    try{
      final response = await _restClient.get(url: Apis.profileGet);
      return Right(profileResponseFromJson(response));
    }on ApiException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, ActivityResponse>> getActivity(int page) async {
    try{
      final response = await _restClient.get(url: "${Apis.getActivity}$page");
      return Right(activityResponseFromJson(response));
    }on ApiException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

}