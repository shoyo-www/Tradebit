import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:tradebit_app/constants/constants.dart';
import 'package:tradebit_app/core/error/exceptions.dart';
import 'package:tradebit_app/core/error/exceptions.dart' as Dio;
import 'package:tradebit_app/data/datasource/remote/services/BaseClient.dart';
import 'package:tradebit_app/data/datasource/remote/services/BaseService.dart';

class RestClient implements BaseService {

  var dioInstance = BaseNetworkClient();

  @override
  Future get({required String url, Map<String, dynamic>? params}) async {
    try {
      final response = await dioInstance
          .getNetworkClient
          .get(url, queryParameters: params);
      return response.data;
    } catch (e) {
      if (e is DioError) {
        if (e.error is LogoutException) {
          throw LogoutException(e.error.toString());
        } else if(e.response?.statusCode == 401) {
          throw LogoutException(e.error.toString());
        }
        else if(e.response?.statusCode == 500 ) {
          throw Dio.DioException('Something went wrong');
        } else if(e.response?.statusCode == 503) {
          throw Dio.DioException('Something went wrong');
        } else if( e.type == DioExceptionType.unknown) {
          throw Dio.DioException('Something went wrong');
        } else if(e.type == DioExceptionType.connectionError) {
          throw Dio.DioException('Something went wrong');
        }  else if(e.response?.statusCode == 404) {
          throw Dio.DioException('Something went wrong');
        } else if(e.response?.statusCode == null) {
          throw Dio.DioException('Something went wrong');
        } else {
          Map<String, dynamic> errorResponse = jsonDecode(e.response?.data ?? {});
          if(errorResponse.containsKey('message')) {
            final String message = errorResponse['message'];
            throw Dio.DioException(message);
          }
          throw Dio.DioException(e.message.toString());
        }
      }
      if (kDebugMode) {
        print(e);
      }
      throw Dio.DioException(Constants.someThingWentWrong);
    }
  }


  @override
  Future post(
      {required String url, required Map<String, dynamic> request,Map<String, dynamic>? params}) async {
    try {
      final response = await dioInstance.getNetworkClient.post(
          url,
          data: request,
          queryParameters: params
      );
      return response.data;
    } catch (e) {
      {if (e is DioError) {
          if (e.error is LogoutException) {
            throw LogoutException(e.error.toString());
          }
          else if(e.response?.statusCode == 500 ) {
            throw Dio.DioException('Something went wrong');
          } else if(e.response?.statusCode == 401) {
            throw LogoutException(e.error.toString());
          } else if(e.response?.statusCode == 503) {
            throw Dio.DioException('Something went wrong');
          }  else if( e.type == DioExceptionType.unknown) {
            throw Dio.DioException('Something went wrong');
          } else if(e.type == DioExceptionType.connectionError) {
            throw Dio.DioException('Something went wrong');
          }  else if(e.response?.statusCode == 404) {
            throw Dio.DioException('Something went wrong');
          } else if(e.response?.statusCode == null) {
            throw Dio.DioException('Something went wrong');
          }else {
            Map<String, dynamic> errorResponse = jsonDecode(e.response?.data);
            final String message = errorResponse['message'] == null  ? 'Something went Wrong' : errorResponse['message'];
            throw Dio.DioException(message);
          }
        }
        if (kDebugMode) {
          print(e.toString());
        }
      throw Dio.DioException(Constants.someThingWentWrong);
      }
    }
  }

  @override
  Future put(
      {required String url, required Map<String, dynamic> request}) async {
    try {
      final response = await dioInstance
          .getNetworkClient
          .put(url, data: request);
      return response.data;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      throw Dio.DioException(Constants.someThingWentWrong);
    }
  }

  @override
  Future delete(
      {required String url, required Map<String, dynamic> request}) async {
    try {
      final response = await dioInstance
          .getNetworkClient
          .delete(url, data: request);
      return response.data;
    } catch(e){
      if (kDebugMode) {
        print(e);
      }
    }
    throw Dio.DioException(Constants.someThingWentWrong);
  }

}