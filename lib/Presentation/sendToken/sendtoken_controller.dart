import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tradebit_app/Presentation/Wallet/wallet_controller.dart';
import 'package:tradebit_app/constants/appcolor.dart';
import 'package:tradebit_app/constants/apptextstyle.dart';
import 'package:tradebit_app/constants/constants.dart';
import 'package:tradebit_app/constants/fontsize.dart';
import 'package:tradebit_app/core/error/failures.dart';
import 'package:tradebit_app/data/datasource/Repository_impl/wallet_repositoryImpl.dart';
import 'package:tradebit_app/data/datasource/remote/models/request/send_token_request.dart';
import 'package:tradebit_app/widgets/spacing.dart';
import 'package:tradebit_app/widgets/trade_bit_container.dart';
import 'package:tradebit_app/widgets/trade_bit_toast.dart';
import 'package:tradebit_app/widgets/tradebit_text.dart';

import '../../data/datasource/remote/models/response/walletListResponse.dart';

class SendTokenController extends GetxController {
  String from = 'Fiat and Spot';
  String to = 'Funding';
  String? image;
  bool loading = false;
  bool button = false;
  String? symbol;
  String? spotAmount;
  String? fundAmount;
  String? showBal;
  bool firstTime = true;
  final List<Datum>? walletList = [];
  final TextEditingController amountController = TextEditingController();
  final WalletRepositoryImpl _walletRepositoryImpl = WalletRepositoryImpl();


  getCrypto(BuildContext context) async {
    loading = true;
    var data = await _walletRepositoryImpl.wallet();
    data.fold((l) {
      if (l is ServerFailure) {
        loading = false;
        ToastUtils.showCustomToast(context, l.message ?? '', false);
      }
    }, (r) {
      String code = r.statusCode ?? '';
      String message = r.message ?? '';
      if (code == '1') {
        walletList?.clear();
        walletList?.addAll(r.data ?? []);
        image = r.data?[0].image ?? '';
        symbol = r.data?[0].symbol ?? '';
        spotAmount = r.data?[0].quantity ?? '';
        fundAmount = r.data?[0].fundQuantity ?? '';
        loading = false;
        update([ControllerBuilders.sendTokenController]);
      } else {
        loading = false;
        ToastUtils.showCustomToast(context, message, false);
      }
    });
    update([ControllerBuilders.sendTokenController]);
  }

   onButtonClick() {
    if(from == 'Fait and Spot') {
      from = 'Funding';
      to = 'Fait and Spot';
      showBal = spotAmount;
      update([ControllerBuilders.sendTokenController]);
    }else {
      from = 'Fait and Spot';
      to = 'Funding';
      showBal = fundAmount;
      update([ControllerBuilders.sendTokenController]);
    }
    firstTime = false;
   }

  onSendToken(BuildContext context) async {
    double enteredAmount = double.parse(amountController.text);
    double availableAmount = double.parse(firstTime ? spotAmount ?? '0.0' : (from == 'Fait and Spot' ? spotAmount : fundAmount ?? '0.0').toString());
    if (enteredAmount > availableAmount) {
      ToastUtils.showCustomToast(context, 'Not enough balance', false);
      return;
    }
    button = true;
    update([ControllerBuilders.sendTokenController]);
    var request = SendTokenRequest(
        amount: amountController.text,
        currency: symbol ?? '',
        fromWallet: from == 'Fait and Spot' ? 'spot' : from == 'Funding' ? 'fund' : 'spot',
        toWallet: to == 'Funding' ? 'fund' : to == 'Fait and Spot' ? 'spot' : 'fund',
    );
    var data = await _walletRepositoryImpl.sendToken(request);
    data.fold((l) {
      if (l is ServerFailure) {
        button = false;
        update([ControllerBuilders.sendTokenController]);
        ToastUtils.showCustomToast(context, l.message ?? '', false);
      }
    }, (r) {
      String message = r.message ?? '';
      String code = r.statusCode ?? '';
      if (code == '1') {
        button = false;
        amountController.clear();
        getCrypto(context);
        update([ControllerBuilders.sendTokenController]);
        ToastUtils.showCustomToast(context, message, true);
      }
      else {
        button = false;
        update([ControllerBuilders.sendTokenController]);
        ToastUtils.showCustomToast(context, message, false);
      }
    });
    update([ControllerBuilders.sendTokenController]);
  }

  void showCupertinoSheet(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 0.6,
          child: CupertinoActionSheet(
            actions: _buildSheetActions(context),
            cancelButton: CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
              },
              child:  TradeBitTextWidget(title: 'Cancel', style: AppTextStyle.normalTextStyle(FontSize.sp_18, Theme.of(context).highlightColor)),
            ),
          ),
        );
      },
    );
  }

  List<Widget> _buildSheetActions(BuildContext context) {
    return walletList!.map((item) {
      return CupertinoActionSheetAction(
        onPressed: () {
          image = item.image ?? '';
          symbol = item.symbol ?? '';
          spotAmount = item.quantity ?? '';
          fundAmount = item.fundQuantity ?? '';
          Get.back();
          update([ControllerBuilders.sendTokenController]);
        },
        child: Row(
          children: [
            SizedBox(
                height: Dimensions.h_30,
                width: Dimensions.h_30,
                child: Image.network(item.image ?? '')),
            HorizontalSpacing(width: Dimensions.w_15),
            TradeBitTextWidget(title: item.symbol ?? '', style: AppTextStyle.normalTextStyle(FontSize.sp_15, Theme.of(context).highlightColor))
          ],
        ),
      );
    }).toList();
  }

  showSheet (BuildContext context) {
    return showModalBottomSheet
      (backgroundColor: Colors.transparent,
        context: context,
        isScrollControlled: true,
        elevation: 0,
        isDismissible: true,
        builder: (BuildContext context) {
          return DraggableScrollableSheet(
              initialChildSize: 0.20,
              maxChildSize: 0.20,
              minChildSize: 0.20,
              expand: true,
              builder: (context, scrollController) {
                return TradeBitContainer(
                  decoration:  BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30)
                      )
                  ),
                  child: Stack(
                    children: [
                      Padding(
                        padding:  EdgeInsets.only(left: Dimensions.w_15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            VerticalSpacing(height: Dimensions.h_20),
                            TradeBitTextWidget(title: 'Select any', style: AppTextStyle.themeBoldNormalTextStyle(
                              fontSize: FontSize.sp_15,
                              color: Theme.of(context).shadowColor
                            )),
                            VerticalSpacing(height: Dimensions.h_20),
                            GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: (){
                                  onButtonClick();
                                  Navigator.pop(context);
                                },
                                child: TradeBitContainer(
                                  width: double.infinity,
                                    child: TradeBitTextWidget(title: 'Fiat and Spot', style: AppTextStyle.normalTextStyle(16, Theme.of(context).highlightColor)))),
                            VerticalSpacing(height: Dimensions.h_5),
                            Divider(color: Theme.of(context).shadowColor.withOpacity(0.5)),
                            VerticalSpacing(height: Dimensions.h_5),
                            GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () {
                                onButtonClick();
                                update([ControllerBuilders.sendTokenController]);
                                Navigator.pop(context);
                                },
                                child: TradeBitContainer(
                                  width: double.infinity,
                                    child: TradeBitTextWidget(title: 'Funding', style: AppTextStyle.normalTextStyle(16, Theme.of(context).highlightColor)))),
                          ],
                        ),
                      ),
                      Positioned(
                          right: 15,
                          top: 25,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            }
                            ,child: TradeBitContainer(
                            decoration: BoxDecoration(
                                color: Theme.of(context).shadowColor.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(30)
                            ),
                            height: Dimensions.h_22,
                            width: Dimensions.h_22,
                            child: const Center(child: Icon(Icons.close,size: 18)),
                          ),
                          ))
                    ],
                  ),
                );
              }
          );
        }
    );
  }
}