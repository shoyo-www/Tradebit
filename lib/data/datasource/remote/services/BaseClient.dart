import 'package:tradebit_app/data/datasource/remote/services/dio/dio.dart';

class BaseNetworkClient {
  get getNetworkClient => WebUtil.createDio();
}
