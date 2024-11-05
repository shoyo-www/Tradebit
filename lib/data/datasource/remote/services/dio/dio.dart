import 'dart:io';

import 'package:dio/dio.dart';
import 'package:tradebit_app/data/datasource/remote/services/dio/logging.dart';

class WebUtil {
  static Dio createDio() {
    var dio = Dio();
    dio.options.connectTimeout = const Duration(seconds: 60); /// in milliseconds
    dio.options.receiveTimeout = const Duration(seconds: 60); /// in milliseconds
    dio.interceptors.add(Logging());
    dio.options.followRedirects = true;
    dio.options.responseType = ResponseType.plain;
    return dio;
  }
}

class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}