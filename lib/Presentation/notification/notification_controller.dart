import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tradebit_app/approutes.dart';
import 'package:tradebit_app/constants/constants.dart';
import 'package:tradebit_app/core/error/failures.dart';
import 'package:tradebit_app/data/datasource/Repository_impl/home_repository.dart';
import 'package:tradebit_app/data/datasource/remote/models/response/notification_response.dart';
import 'package:tradebit_app/widgets/trade_bit_toast.dart';

class NotificationController extends GetxController {
  bool isLoading = false;
  List<NotificationList> notificationList = [];
  final HomeRepositoryImpl _homeRepository = HomeRepositoryImpl();
  bool markRead = false;
  int pageNumber = 1;

  @override
  onInit() {
    super.onInit();
    getNotifications(Get.context!);
  }

  getNotifications(BuildContext context) async {
    isLoading = true;
    update([ControllerBuilders.notificationController]);
    var data = await _homeRepository.notification( pageNumber);
    data.fold((l) {
      if (l is ServerFailure) {
        if(l.message == 'Unauthenticated') {
          Get.offAllNamed(AppRoutes.loginScreen);
        }
        isLoading = false;
        update([ControllerBuilders.notificationController]);
        ToastUtils.showCustomToast(context, l.message?? '', false);
      }
    }, (r) {
      String code = r.statusCode?? '';
      String message = r.message?? '';
      if (code == '1') {
        if (pageNumber == 1) {
          notificationList.clear();
        }
        notificationList.addAll(r.data?.notifications?.data?? []);
        isLoading = false;
        update([ControllerBuilders.notificationController]);
        if (r.data?.notifications?.nextPageUrl!= null) {
          pageNumber++;
        } else {}
      } else {
        isLoading = false;
        ToastUtils.showCustomToast(context, message, false);
        update([ControllerBuilders.notificationController]);
      }
    });
    update([ControllerBuilders.notificationController]);
  }

  loadMoreNotifications(BuildContext context) async {
    if (pageNumber > 1) {
      getNotifications(context);
    }
  }

  markAllRead() {
    isLoading = true;
    Timer(const Duration(seconds: 1), () {
      markRead = true;
      isLoading = false;
      update([ControllerBuilders.notificationController]);
    });
    update([ControllerBuilders.notificationController]);
  }

  removeAllList() {
    isLoading = true;
    Timer(const Duration(seconds: 2), () {
      notificationList.clear();
      isLoading = false;
      update([ControllerBuilders.notificationController]);
    });
    update([ControllerBuilders.notificationController]);
  }
}
