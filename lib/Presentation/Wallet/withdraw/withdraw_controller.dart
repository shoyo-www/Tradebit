import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tradebit_app/Presentation/Wallet/wallet.dart';
import 'package:tradebit_app/approutes.dart';
import 'package:tradebit_app/constants/apptextstyle.dart';
import 'package:tradebit_app/constants/constants.dart';
import 'package:tradebit_app/constants/fontsize.dart';
import 'package:tradebit_app/core/error/failures.dart';
import 'package:tradebit_app/data/datasource/Repository_impl/wallet_repositoryImpl.dart';
import 'package:tradebit_app/data/datasource/remote/models/request/transfer_otp_request.dart';
import 'package:tradebit_app/data/datasource/remote/models/request/wallet_request.dart';
import 'package:tradebit_app/data/datasource/remote/models/request/withdraw_process.dart';
import 'package:tradebit_app/data/datasource/remote/models/request/withdraw_verify_request.dart';
import 'package:tradebit_app/data/datasource/remote/models/response/walletListResponse.dart';
import 'package:tradebit_app/widgets/spacing.dart';
import 'package:tradebit_app/widgets/trade_bit_toast.dart';
import 'package:tradebit_app/widgets/tradebit_text.dart';

class WithDrawController extends GetxController {
  TextEditingController address = TextEditingController();
  TextEditingController amount = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController mobile = TextEditingController();
  TextEditingController google = TextEditingController();
  bool loading = false;
  bool buttonLoading = false;
  bool emailLoading = false;
  bool mobileLoading = false;
  String? token = 'Select Network';
  final WalletRepositoryImpl _walletRepositoryImpl = WalletRepositoryImpl();
  bool isTimerEnabled = false;
  bool isTimerMobileEnabled = false;
  int endTime = 0;
  int mobileEnd = 0;
  String? userEmail;
  String? userMobile;
  String? sendToken;

  void startTimer() {
    endTime = DateTime.now().millisecondsSinceEpoch + 120000;
  }

  void startTimerMobile() {
    mobileEnd = DateTime.now().millisecondsSinceEpoch + 120000;
  }

  getBack() {
    mobile.clear();
    google.clear();
    email.clear();
    Get.back();
    update([ControllerBuilders.withdrawController]);
  }
  withDraw (BuildContext context,String currency) async {
    loading = true;
   final request = WithdrawRequest(
     tokenType: sendToken,
     amount: amount.text,
     currency: currency,
     toAddress: address.text,
   );
    var data = await _walletRepositoryImpl.withdraw(request);
    data.fold((l) {
      if (l is ServerFailure) {
        loading = false;
        update([ControllerBuilders.withdrawController]);
        ToastUtils.showCustomToast(context, l.message ?? '', false);
      }
    }, (r) {
      String code = r.statusCode ?? '';
      String message = r.message ?? '';
      if (code == '1') {
        loading = false;
        amount.clear();
        address.clear();
        Get.toNamed(AppRoutes.verifyWithdraw,arguments: {
          'currency' : currency
        });
        update([ControllerBuilders.withdrawController]);
        ToastUtils.showCustomToast(context, message, true);
      }
      else {
        loading = false;
        update([ControllerBuilders.withdrawController]);
        ToastUtils.showCustomToast(context, message, false);
      }
    });
  }
  onGetCode(BuildContext context) async{
    emailLoading = true;
    update([ControllerBuilders.withdrawController]);
    var request = TransferOtpRequest(
        type: 'email'
    );
    var data = await _walletRepositoryImpl.transferOtp(request);
    data.fold((l) {
      if (l is ServerFailure) {
        emailLoading = false;
        update([ControllerBuilders.withdrawController]);
        ToastUtils.showCustomToast(context, l.message ?? '', false);
      }
    }, (r) {
      String message = r.message ?? '';
      String code = r.statusCode ?? '';
      if (code == '1') {
        isTimerEnabled = true;
        startTimer();
        userEmail = r.data?.email ?? '';
        userMobile = r.data?.mobile ?? '';
        emailLoading = false;
        update([ControllerBuilders.withdrawController]);
        ToastUtils.showCustomToast(context, message, true);
      }
      else {
        emailLoading = false;
        update([ControllerBuilders.withdrawController]);
        ToastUtils.showCustomToast(context, message, false);
      }
    });
  }

  onMobileGetCode(BuildContext context) async{
    mobileLoading = true;
    update([ControllerBuilders.withdrawController]);
    var request = TransferOtpRequest(
        type: 'mobile'
    );
    var data = await _walletRepositoryImpl.transferMobile(request);
    data.fold((l) {
      if (l is ServerFailure) {
        mobileLoading = false;
        update([ControllerBuilders.withdrawController]);
        ToastUtils.showCustomToast(context, l.message ?? '', false);
      }
    }, (r) {
      String message = r.message ?? '';
      String code = r.statusCode ?? '';
      if (code == '1') {
        userEmail = r.data?.email ?? '';
        userMobile = r.data?.mobile ?? '';
        mobileLoading = false;
        isTimerMobileEnabled = true;
        startTimerMobile();
        update([ControllerBuilders.withdrawController]);
        ToastUtils.showCustomToast(context, message, true);
      }
      else {
        mobileLoading = false;
        update([ControllerBuilders.withdrawController]);
        ToastUtils.showCustomToast(context, message, false);
      }
    });
  }

  void showCupertinoSheet(BuildContext context,List <CurrencyNetwork>? network) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          actions: buildSheetActions(context,network),
          cancelButton: CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
            },
            child:  TradeBitTextWidget(title: 'Cancel', style: AppTextStyle.themeBoldNormalTextStyle(
              fontSize: FontSize.sp_16,
              color: Theme.of(context).highlightColor
            )),
          ),
        );
      },
    );
    update([ControllerBuilders.withdrawController]);
  }
  List<Widget> buildSheetActions(BuildContext context,List <CurrencyNetwork>? network) {
    return network!.map((item) {
      return CupertinoActionSheetAction(
        onPressed: () {
       String? network = item.tokenType;
       sendToken = item.tokenType;
       token = getSelf(network ?? '');
       update([ControllerBuilders.withdrawController]);
          Get.back();
        },
        child: Row(
          children: [
            HorizontalSpacing(width: Dimensions.w_15),
            TradeBitTextWidget(title: getSelf(item.tokenType ?? '') ?? '', style: AppTextStyle.normalTextStyle(FontSize.sp_15, Theme.of(context).highlightColor))
          ],
        ),
      );
    }).toList();
  }

  getSelf(String token) {
    if(token == 'SELF') {
      return 'MCOIN20';
    } else if(token == "ETH") {
      return 'ERC20';
    } else if(token == "TRX") {
      return 'TRC20';
    }
    return token;
  }

  walletWithdraw(BuildContext context,String currency,String showBal) async {
    double enteredAmount = double.parse(amount.text);
    double availableAmount = double.parse(showBal ?? '0.0');
    if(address.text.isEmpty || amount.text.isEmpty) {
      ToastUtils.showCustomToast(context, 'please fill details', false);
      return;
    }
    if (enteredAmount > availableAmount) {
      ToastUtils.showCustomToast(context, 'Not enough balance', false);
      return;
    }
    buttonLoading = true;
    update([ControllerBuilders.withdrawController]);
    final request = WalletProcessRequest(
        tokenType: sendToken ?? '',
        amount: amount.text,
        toAddress: address.text,
        currency: currency
    );
    var data = await _walletRepositoryImpl.walletProcess(request);
    data.fold((l) {
      if (l is ServerFailure) {
        buttonLoading = false;
        update([ControllerBuilders.withdrawController]);
        ToastUtils.showCustomToast(context, l.message ?? '', false);
      }
    }, (r) {
      String code = r.statusCode ?? '';
      String message = r.message ?? '';
      if (code == '1') {
        amount.clear();
        address.clear();
        buttonLoading = false;
        Get.toNamed(AppRoutes.verifyWithdraw,arguments: {
          'currency' : currency
        });
        update([ControllerBuilders.withdrawController]);
        ToastUtils.showCustomToast(context, message, true);
      }
      else {
        buttonLoading = false;
        update([ControllerBuilders.withdrawController]);
        ToastUtils.showCustomToast(context, message, false);
      }
    });
    update([ControllerBuilders.withdrawController]);
  }

  verifyWithdraw(BuildContext context,String currency) async {
    buttonLoading = true;
    update([ControllerBuilders.withdrawController]);
    final request = VerifyWithdrawRequest(
      currency: currency,
      amount: amount.text,
      googleVcode: google.text,
      emailVcode: email.text,
      mobileVcode: mobile.text,
      toAddress: address.text,
      tokenType: sendToken ?? '',
    );
    var data = await _walletRepositoryImpl.walletVerify(request);
    data.fold((l) {
      if (l is ServerFailure) {
        buttonLoading = false;
        update([ControllerBuilders.withdrawController]);
        ToastUtils.showCustomToast(context, l.message ?? '', false);
      }
    }, (r) {
      String code = r.statusCode ?? '';
      String message = r.message ?? '';
      if (code == '1') {
        mobile.clear();
        email.clear();
        google.clear();
        amount.clear();
        address.clear();
        token = 'Select Network';
        buttonLoading = false;
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> const Wallet()));
        update([ControllerBuilders.withdrawController]);
        ToastUtils.showCustomToast(context, message, true);
      }
      else {
        buttonLoading = false;
        update([ControllerBuilders.withdrawController]);
        ToastUtils.showCustomToast(context, message, false);
      }
    });
    update([ControllerBuilders.withdrawController]);
  }
}