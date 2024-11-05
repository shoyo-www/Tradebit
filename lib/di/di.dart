import 'package:get/get.dart';
import 'package:tradebit_app/Presentation/getx/internet_controller.dart';
import 'package:tradebit_app/data/datasource/remote/services/dio/rest_client.dart';

class InitialBinding extends Bindings {

  @override
  void dependencies() {
    Get.put(RestClient(), permanent: true);
    Get.put(ConnectivityController(),permanent: true);
  }
}