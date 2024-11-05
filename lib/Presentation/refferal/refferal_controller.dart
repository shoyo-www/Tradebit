import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tradebit_app/constants/constants.dart';
import 'package:tradebit_app/core/error/failures.dart';
import 'package:tradebit_app/data/datasource/Repository_impl/wallet_repositoryImpl.dart';
import 'package:tradebit_app/data/datasource/local/local_storage.dart';
import 'package:tradebit_app/data/datasource/remote/models/response/refer_income_response.dart';
import 'package:tradebit_app/data/datasource/remote/models/response/referral_response.dart';
import 'package:tradebit_app/widgets/trade_bit_toast.dart';

class RefferalController extends GetxController {

  bool refferals = true;
  bool commission = false;
  bool isLoading = false;
  bool income = false;
  List<ReferralData> referral = [];
  List<ReferData> referIncome = [];
  WalletRepositoryImpl walletRepositoryImpl = WalletRepositoryImpl();

  onReferral() {
    refferals = true;
    commission = false;
    update([ControllerBuilders.refferalController]);
  }

  onCommission() {
    refferals = false;
    commission = true;
    update([ControllerBuilders.refferalController]);
  }

  onCopyClipBoard(BuildContext context,String text) {
    Clipboard.setData(ClipboardData(text: text)).then((_) {
      ToastUtils.showCustomToast(context, 'Copied successfully', true);
    });
  }

  onShareButton() async {
    await Share.share(
      'Here use my Referral to get Rewards https://tradebit.io/signup?referral=${LocalStorage.getString(GetXStorageConstants.userid)}',
    );
  }

  getReferral(BuildContext context) async{
    isLoading = true;
    update([ControllerBuilders.refferalController]);
    var data = await walletRepositoryImpl.getReferral();
    data.fold((l) {
      if (l is ServerFailure) {
        isLoading = false;
        ToastUtils.showCustomToast(context, l.message ?? '', false);
        update([ControllerBuilders.refferalController]);
      }
    }, (r) {
      String code = r.statusCode ?? '';
      String message = r.message ?? '';
      if (code == '1') {
        referral.clear();
        referral.addAll(r.data ?? [] );
        isLoading = false;
        update([ControllerBuilders.refferalController]);
      } else {
        isLoading = false;
        update([ControllerBuilders.refferalController]);
        ToastUtils.showCustomToast(context, message, false);
      }
    });
    update([ControllerBuilders.refferalController]);
  }

  getReferIncome(BuildContext context) async{
    income = true;
    update([ControllerBuilders.refferalController]);
    var data = await walletRepositoryImpl.getRefer();
    data.fold((l) {
      if (l is ServerFailure) {
        income = false;
        ToastUtils.showCustomToast(context, l.message ?? '', false);
        update([ControllerBuilders.refferalController]);
      }
    }, (r) {
      String code = r.statusCode ?? '';
      String message = r.message ?? '';
      if (code == '1') {
        referIncome.clear();
        referIncome.addAll(r.data?.data ?? [] );
        income = false;
        update([ControllerBuilders.refferalController]);
      } else {
        income = false;
        update([ControllerBuilders.refferalController]);
        ToastUtils.showCustomToast(context, message, false);
      }
    });
    update([ControllerBuilders.refferalController]);
  }

}